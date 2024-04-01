import 'package:etms/app/helpers/error_handling/unknown_error.dart';
import 'package:etms/app/utils/api_link.dart';
import 'package:etms/app/utils/response_code.dart';
import 'package:etms/data/datasources/request/auth/reset_password_data.dart';
import 'package:etms/domain/repositories/auth_repository.dart';
import 'package:get/get.dart';
import '../../app/api/base_provider.dart';
import '../../app/config/api_constants.dart';
import '../../app/helpers/helper.dart';
import '../datasources/request/auth/login_data.dart';
import '../datasources/response/auth/login_response.dart';

class AuthRepoImpl extends BaseProvider implements AuthRepository{
  Helper helper = Helper();
  @override
  Future<LoginResponse> logIn({required LogInData data, required String apiLink}) async {
    try{
      await helper.checkInternetConnection();
      final Response response = await post(apiLink, data.toJson());
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      if(response.statusCode==201){
        return LoginResponse.fromJson(response.body);
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }
    catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<bool> resetPassword({required ResetPasswordData data}) async {
    try{
      await helper.checkInternetConnection();
      String apiLink = await ApiConstants.resetPassword.link();
      final Response response = await put(apiLink, data.toJson());
     if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      } else if(response.statusCode!.codeSuccess){
        return true;
      } else{
        throw UnknownException(response.body);
      }
    } catch(e){
      throw UnknownException(e.toString());
    }
  }
}
