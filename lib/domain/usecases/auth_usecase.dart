import 'package:etms/data/datasources/request/auth/reset_password_data.dart';
import 'package:etms/data/datasources/response/auth/login_response.dart';
import 'package:etms/domain/repositories/auth_repository.dart';
import '../../data/datasources/request/auth/login_data.dart';

class AuthUseCase{
  final AuthRepository respository;
  AuthUseCase(this.respository);

  Future<LoginResponse> logIn({required LogInData data, required String apiLink}) async{
    return respository.logIn(data: data, apiLink: apiLink);
  }

  Future<bool> resetPassword({required ResetPasswordData data}) async{
    return respository.resetPassword(data: data);
  }
}