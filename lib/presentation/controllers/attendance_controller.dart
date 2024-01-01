import 'package:etms/app/utils/custom_snackbar.dart';
import 'package:etms/data/datasources/request/attendance_report_data.dart';
import 'package:etms/data/datasources/response/attendance_report/attendance_report_response.dart';
import 'package:etms/data/datasources/response/attendance_report/general_setting_response.dart';
import 'package:etms/data/datasources/response/attendance_report/qr_code_response.dart';
import 'package:etms/domain/repositories/attendance_repository.dart';
import 'package:etms/domain/usecases/attendance_usecase.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../app/helpers/error_handling/unknown_error.dart';
import '../../data/datasources/request/attendance_approval_data.dart';

enum AvailableState {both, location, nothing}

class AttendanceController extends GetxController with StateMixin{

  final AttendanceRepository repository;
  AttendanceController({required this.repository});

  AttendanceUseCase useCase=AttendanceUseCase(Get.find());

  RxList<AttReportResponse> attendanceReportList=  RxList<AttReportResponse>();
  Rx<AttReportSummaryResponse> attSummary=AttReportSummaryResponse().obs;
  Rx<AvailableState> availableState = AvailableState.nothing.obs;
  RxList<QRCodeResponse> qrCodeList=  RxList<QRCodeResponse>();

  Future<void> getAttendanceReport({required AttendanceReportData data}) async{
    try{
      await EasyLoading.show();
      List<AttReportResponse> response = await useCase.getAttendanceReport(data: data);
      attendanceReportList.value = response;
      attendanceReportList.refresh();
     refresh();
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
      AttReportSummaryResponse response = await useCase.getAttReportSummary(data: data);
      attSummary.value = response;
      attSummary.refresh();
      refresh();
      await EasyLoading.dismiss();
    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<void> getGeneralSetting() async{
    try{
      await EasyLoading.show();
      GeneralSettingResponse response = await useCase.getGeneralSetting();
      String value=response.keyValue!.toLowerCase();
      if(value.contains('location') && value.contains('qr')){
        availableState.value = AvailableState.both;
      } else if(value.contains('location')){
        availableState.value = AvailableState.location;
      }
      availableState.refresh();
      refresh();
      await EasyLoading.dismiss();
    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<void> getQRCodeList() async{
    try{
      List<QRCodeResponse> response = await useCase.getQRCodeList();
      qrCodeList.value = response;
      qrCodeList.refresh();
      refresh();
      await EasyLoading.dismiss();
    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<void> applyAttendance({required AttendanceApprovalData data}) async{
    try{
      await EasyLoading.show();
      bool success = await useCase.applyAttendance(data: data);
      if(success){
        'Successfully check in/out'.success();
      } else{
        'Failed to check in/out'.error();
      }
      await EasyLoading.dismiss();
    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

}