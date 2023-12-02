import 'package:etms/app/route/route_name.dart';
import 'package:etms/app/utils/custom_snackbar.dart';
import 'package:etms/data/datasources/request/login_data.dart';
import 'package:etms/data/datasources/response/auth/login_response.dart';
import 'package:etms/domain/usecases/auth_usecase.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../app/config/api_constants.dart';
import '../../app/helpers/error_handling/unknown_error.dart';
import '../../app/helpers/shared_preference_helper.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthController extends GetxController with StateMixin{
  final AuthRepository authRepository;
  AuthController({required this.authRepository});

  Rx<LoginResponse> loginResponse=LoginResponse().obs;
  final companyCode=''.obs;

  Future<void> logIn({required LogInData data, required String code})async {
    AuthUseCase useCase=AuthUseCase(authRepository);
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
}