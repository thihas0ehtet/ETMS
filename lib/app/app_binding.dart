import 'package:etms/app/helpers/shared_preference_helper.dart';
import 'package:etms/data/repositories/attendance_repo_impl.dart';
import 'package:etms/data/repositories/auth_repo_impl.dart';
import 'package:etms/data/repositories/leave_repo_impl.dart';
import 'package:etms/domain/repositories/attendance_repository.dart';
import 'package:etms/domain/repositories/auth_repository.dart';
import 'package:etms/presentation/controllers/attendance_controller.dart';
import 'package:etms/presentation/controllers/auth_controller.dart';
import 'package:etms/presentation/controllers/leave_controller.dart';
import 'package:get/get.dart';

import '../domain/repositories/leave_repository.dart';

class AppBinding extends Bindings{
  @override
  Future<void> dependencies() async{
    Get.put(SharedPreferenceHelper(), permanent: true);
    Get.lazyPut(()=>AuthRepoImpl());
    Get.lazyPut(()=>AttendanceRepoImpl());
    // Get.lazyPut(()=>LeaveRepoImpl());
    // Get.put(LeaveRepoImpl());
    Get.lazyPut<LeaveRepository>(() => LeaveRepoImpl());
    Get.lazyPut<AttendanceRepository>(() => AttendanceRepoImpl());
    Get.put<AuthController>(AuthController(authRepository: Get.find<AuthRepoImpl>()));
    Get.put<AttendanceController>(AttendanceController(repository: Get.find<AttendanceRepository>()));
    Get.put<LeaveController>(LeaveController(repository: Get.find<LeaveRepository>()));
  }
}