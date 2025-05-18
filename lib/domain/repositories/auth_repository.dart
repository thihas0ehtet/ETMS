import 'package:etms/data/datasources/request/auth/reset_password_data.dart';
import 'package:etms/data/datasources/response/auth/login_response.dart';
import '../../data/datasources/request/auth/login_data.dart';

abstract class AuthRepository{
  Future<LoginResponse> logIn({required LogInData data, required String apiLink});
  Future<bool> resetPassword({required ResetPasswordData data});
}