import 'package:etms/app/utils/custom_snackbar.dart';
import 'package:etms/data/datasources/request/attendance_report_data.dart';
import 'package:etms/data/datasources/response/attendance_report/attendance_report_response.dart';
import 'package:etms/domain/repositories/attendance_repository.dart';
import 'package:etms/domain/usecases/attendance_usecase.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../app/helpers/error_handling/unknown_error.dart';

class AttendanceController extends GetxController with StateMixin{
  final AttendanceRepository repository;
  AttendanceController({required this.repository});

  AttendanceUseCase useCase=AttendanceUseCase(Get.find());

  RxList<AttReportResponse> attendanceReportList=  RxList<AttReportResponse>();
  Rx<AttReportSummaryResponse> attSummary=AttReportSummaryResponse().obs;

  Future<void> getAttendanceReport({required AttendanceReportData data}) async{
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

  Future<void> getAttReportSummary({required AttendanceReportData data}) async{
    try{
      //don't want to show loading after the data is exist, but want to update the data
      if(attSummary.value.empFirstName==null){
        await EasyLoading.show();
      }
      print("JDSLFJSJFS ");
      AttReportSummaryResponse response = await useCase.getAttReportSummary(data: data);
      print('THisisisis ${response.toJson()}');
      attSummary.value = response;
      attSummary.refresh();
      await EasyLoading.dismiss();
    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }
}