import 'package:etms/app/helpers/shared_preference_helper.dart';
import 'package:etms/data/repositories/auth_repo_impl.dart';
import 'package:etms/domain/repositories/auth_repository.dart';
import 'package:etms/presentation/controllers/auth_controller.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings{
  @override
  Future<void> dependencies() async{
    Get.put(SharedPreferenceHelper(), permanent: true);
    Get.lazyPut(()=>AuthRepoImpl());
    Get.put<AuthController>(AuthController(authRepository: Get.find<AuthRepoImpl>()));
  }
}