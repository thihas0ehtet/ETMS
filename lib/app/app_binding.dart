import 'package:etms/app/helpers/shared_preference_helper.dart';
import 'package:etms/data/repositories/approval_repo_impl.dart';
import 'package:etms/data/repositories/attendance_repo_impl.dart';
import 'package:etms/data/repositories/auth_repo_impl.dart';
import 'package:etms/data/repositories/claim_repo_impl.dart';
import 'package:etms/data/repositories/leave_repo_impl.dart';
import 'package:etms/data/repositories/payslip_repo_impl.dart';
import 'package:etms/data/repositories/profile_repo_impl.dart';
import 'package:etms/domain/repositories/approval_repository.dart';
import 'package:etms/domain/repositories/attendance_repository.dart';
import 'package:etms/domain/repositories/auth_repository.dart';
import 'package:etms/domain/repositories/claim_repository.dart';
import 'package:etms/domain/repositories/payslip_respository.dart';
import 'package:etms/domain/repositories/profile_repository.dart';
import 'package:etms/presentation/controllers/approval_controller.dart';
import 'package:etms/presentation/controllers/attendance_controller.dart';
import 'package:etms/presentation/controllers/auth_controller.dart';
import 'package:etms/presentation/controllers/claim_controller.dart';
import 'package:etms/presentation/controllers/leave_controller.dart';
import 'package:etms/presentation/controllers/payslip_controller.dart';
import 'package:etms/presentation/controllers/profile_controller.dart';
import 'package:get/get.dart';

import '../domain/repositories/leave_repository.dart';

class AppBinding extends Bindings{
  @override
  Future<void> dependencies() async{
    Get.put(SharedPreferenceHelper(), permanent: true);
    Get.lazyPut<AuthRepository>(()=>AuthRepoImpl());
    Get.lazyPut(()=>AttendanceRepoImpl());
    Get.lazyPut<LeaveRepository>(() => LeaveRepoImpl());
    Get.lazyPut<AttendanceRepository>(() => AttendanceRepoImpl());
    Get.lazyPut<PaySlipRepository>(() => PaySlipRepoImpl());
    Get.lazyPut<ProfileRepository>(() => ProfileRepoImpl());
    Get.lazyPut<ClaimRepository>(() => ClaimRepoImpl());
    Get.lazyPut<ApprovalRepository>(() => ApprovalRepoImpl());
    Get.put<AuthController>(AuthController(authRepository: Get.find<AuthRepository>()));
    Get.put<AttendanceController>(AttendanceController(repository: Get.find<AttendanceRepository>()));
    Get.put<LeaveController>(LeaveController(repository: Get.find<LeaveRepository>()));
    Get.put<PaySlipController>(PaySlipController(repository: Get.find<PaySlipRepository>()));
    Get.put<ProfileController>(ProfileController(repository: Get.find<ProfileRepository>()));
    Get.put<ClaimController>(ClaimController(repository: Get.find<ClaimRepository>()));
    Get.put<ApprovalController>(ApprovalController(repository: Get.find<ApprovalRepository>()));
  }
}