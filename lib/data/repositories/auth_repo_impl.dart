import 'package:etms/app/helpers/error_handling/unknown_error.dart';
import 'package:etms/app/helpers/shared_preference_helper.dart';
import 'package:etms/app/utils/api_link.dart';
import 'package:etms/data/datasources/request/login_data.dart';
import 'package:etms/domain/repositories/auth_repository.dart';
import 'package:get/get.dart';
import '../../app/api/base_provider.dart';
import '../../app/config/api_constants.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../datasources/response/login_response.dart';

class AuthRepoImpl extends BaseProvider implements AuthRepository{
  @override
  Future<LoginResponse> logIn({required LogInData data}) async {
    try{
      // final Response response = await post(':'+companyCode+'/api/'+ApiConstants.login, data.toJson());
      String apiLink= await ApiConstants.login.link();
      final Response response = await post(apiLink, data.toJson());
      print("HEYY RESPONSE IS $apiLink ${response.body} ${response.statusCode}");
      if(response.statusCode!=201){
        throw UnknownException(response.body['message']);
      }
      return LoginResponse.fromJson(response.body);
    }
    catch(e){
      throw UnknownException("There is something wrong!");
    }
  }
}