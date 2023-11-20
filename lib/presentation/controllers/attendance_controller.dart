import 'package:etms/app/utils/custom_snackbar.dart';
import 'package:etms/data/datasources/request/attendance_report_data.dart';
import 'package:etms/data/datasources/response/att_report_response.dart';
import 'package:etms/domain/repositories/attendance_repository.dart';
import 'package:etms/domain/usecases/attendance_usecase.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../app/helpers/error_handling/unknown_error.dart';

class AttendanceController extends GetxController with StateMixin{
  final AttendanceRepository repository;
  AttendanceController({required this.repository});

  // Rx<AttReportResponse> attReportResponse = AttReportResponse().obs;
  RxList<AttReportResponse> attendanceReportList=  RxList<AttReportResponse>();

  AttendanceUseCase useCase=AttendanceUseCase(Get.find());

  Future<void> getAttendanceReport({required AttendanceReportData data}) async{
    print("DAT IS ${data.toJson()}");
    try{
      await EasyLoading.show();
      List<AttReportResponse> response = await useCase.getAttendanceReport(data: data);
      attendanceReportList.value = response;
      attendanceReportList.refresh();
      await EasyLoading.dismiss();
    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }
}