import 'package:etms/app/helpers/error_handling/unknown_error.dart';
import 'package:etms/app/helpers/shared_preference_helper.dart';
import 'package:etms/app/utils/api_link.dart';
import 'package:etms/data/datasources/request/login_data.dart';
import 'package:etms/domain/repositories/auth_repository.dart';
import 'package:get/get.dart';
import '../../app/api/base_provider.dart';
import '../../app/config/api_constants.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../datasources/response/auth/login_response.dart';

class AuthRepoImpl extends BaseProvider implements AuthRepository{
  @override
  Future<LoginResponse> logIn({required LogInData data, required String apiLink}) async {
    try{
      String apiLink123= await ApiConstants.login.link();
      print("API LINK IS 124 $apiLink and $apiLink123");
      final Response response = await post(apiLink, data.toJson());
      print("HEYY RESPONSE IS125 $apiLink ${response.body} ${response.statusCode}");
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
}
