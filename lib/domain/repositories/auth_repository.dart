import 'package:etms/data/datasources/request/login_data.dart';
import 'package:etms/data/datasources/response/login_response.dart';
import 'package:get/get.dart';

abstract class AuthRepository{
  Future<LoginResponse> logIn({required LogInData data, required String apiLink});
}