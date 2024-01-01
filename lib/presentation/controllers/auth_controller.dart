import 'package:etms/app/route/route_name.dart';
import 'package:etms/app/utils/custom_snackbar.dart';
import 'package:etms/data/datasources/request/login_data.dart';
import 'package:etms/data/datasources/request/reset_password_data.dart';
import 'package:etms/data/datasources/response/auth/login_response.dart';
import 'package:etms/domain/usecases/auth_usecase.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import '../../app/config/api_constants.dart';
import '../../app/helpers/error_handling/unknown_error.dart';
import '../../app/helpers/shared_preference_helper.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthController extends GetxController with StateMixin{
  final AuthRepository authRepository;
  AuthController({required this.authRepository});

  AuthUseCase useCase=AuthUseCase(Get.find());
  Rx<LoginResponse> loginResponse=LoginResponse().obs;
  final companyCode=''.obs;

  Future<void> logIn({required LogInData data, required String code})async {
    String apiLink = '$code/api/${ApiConstants.login}';
    try{
      await EasyLoading.show(
        // status: 'loading123...',
        // maskType: EasyLoadingMaskType.,
      );
      print("THELK DATA IS ${data.toJson()} add $apiLink");
      LoginResponse response = await useCase.logIn(data: data, apiLink: apiLink);
      loginResponse.value=response;
      print("RESPOND DATA IS $response");
      companyCode.value=code;
      companyCode.refresh();
      refresh();
      SharedPreferenceHelper sharedData= Get.find<SharedPreferenceHelper>();
      sharedData.saveCompanyCode(code.toString());
      sharedData.saveSysId(response.empSysID.toString());
      // sharedData.saveSysId(id);

      await EasyLoading.dismiss();
      Get.toNamed(RouteName.dashboard);
    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<void> biometricAuth() async{
    final LocalAuthentication auth = LocalAuthentication();
    final List<BiometricType> availableBiometrics =
    await auth.getAvailableBiometrics();
    print("Available list $availableBiometrics");
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason:
        'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if(authenticated){
        Get.offNamed(RouteName.dashboard);
      }
    } on PlatformException catch (e) {
      print("E IS ${e.toString()}");
      e.toString().error();
    }
  }

  Future<void> resetPassword(ResetPasswordData data)async{
    try{
      await EasyLoading.show();
      bool success = await useCase.resetPassword(data: data);
      if(success==false){
        'failed to reset password'.error();
        await EasyLoading.dismiss();
      } else{
        await EasyLoading.dismiss();
        'Password has been changed successfully'.success();
      }

    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }
}