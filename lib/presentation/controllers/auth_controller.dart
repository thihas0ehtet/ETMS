import 'package:etms/app/route/route_name.dart';
import 'package:etms/app/utils/custom_snackbar.dart';
import 'package:etms/data/datasources/request/login_data.dart';
import 'package:etms/data/datasources/response/login_response.dart';
import 'package:etms/domain/usecases/auth_usecase.dart';
import 'package:get/get.dart';
import '../../app/helpers/error_handling/unknown_error.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthController extends GetxController with StateMixin{
  final AuthRepository authRepository;
  AuthController({required this.authRepository});

  Rx<LoginResponse> loginResponse=LoginResponse().obs;
  final companyCode=''.obs;

  Future<void> logIn({required LogInData data})async {
    AuthUseCase useCase=AuthUseCase(authRepository);
    print("THIS IS LOGIN");
    try{
     LoginResponse response = await useCase.logIn(data: data);
     loginResponse.value=response;
     print("RESPONS IS ${response.toJson()}");
     Get.toNamed(RouteName.dashboard);
    }on UnknownException catch(e){
      e.toString().error();
    }
  }
}