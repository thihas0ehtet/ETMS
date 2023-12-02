import 'package:etms/app/utils/custom_snackbar.dart';
import 'package:etms/data/datasources/request/allowed_dates_data.dart';
import 'package:etms/data/datasources/request/leave_carry_data.dart';
import 'package:etms/data/datasources/request/leave_report_data.dart';
import 'package:etms/data/datasources/request/leave_status_data.dart';
import 'package:etms/data/datasources/response/allowed_date_response.dart';
import 'package:etms/data/datasources/response/apply_leave/apply_leave_response.dart';
import 'package:etms/domain/repositories/leave_repository.dart';
import 'package:etms/domain/usecases/leave_usecase.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../app/helpers/error_handling/unknown_error.dart';

class LeaveController extends GetxController with StateMixin{
  final LeaveRepository repository;
  LeaveController({required this.repository});

  // Rx<LeaveTypeResponse> leaveTypeResponse = LeaveTypeResponse().obs;
  RxList<LeaveTypeData> leaveTypes=  RxList<LeaveTypeData>();
  RxList<LeaveReportDataResponse> leaveReportList=  RxList<LeaveReportDataResponse>();
  RxList<AllowedDateResponse> allowedDateList=  RxList<AllowedDateResponse>();
  Rx<LeaveCarryResponse> leaveCarry = LeaveCarryResponse().obs;
  RxList<LeaveStatusResponse> statusDetailList=  RxList<LeaveStatusResponse>();
  RxList<LeaveStatusResponse> statusFirstList=  RxList<LeaveStatusResponse>();
  RxList<LeaveStatusResponse> statusSecondList=  RxList<LeaveStatusResponse>();

  LeaveUseCase useCase = LeaveUseCase(Get.find());

  Future<void> getLeaveTypes() async{
    try{
      await EasyLoading.show();
     List<LeaveTypeData> response = await useCase.getLeaveTypes();
      print("HKJLKK DATA IS $response");
      // attReportResponse.value = response;
      // attReportResponse.refresh();
      leaveTypes.value=response;
      leaveTypes.refresh();
      await EasyLoading.dismiss();

    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<void> getLeaveReportList({required LeaveReportData data}) async{
    try{
      await EasyLoading.show();
      List<LeaveReportDataResponse> response = await useCase.getLeaveReportList(data: data);
      leaveReportList.value=response;
      leaveReportList.refresh();
      await EasyLoading.dismiss();

    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  clearLeaveReportList(){
    leaveReportList.clear();
    leaveReportList.refresh();
  }

  clearLeaveCarry(){
    leaveCarry.value=LeaveCarryResponse();
    leaveCarry.refresh();
  }

  Future<void> getAllowedDates({required AllowedDatesData data, required int start, required int end}) async{
    try{
      await EasyLoading.show();
      List<AllowedDateResponse> response = await useCase.getAllowedDates(data: data, start: start, end: end);
      print("HKJLKK DATA IS $response");
      // attReportResponse.value = response;
      // attReportResponse.refresh();
      allowedDateList.value=response;
      allowedDateList.refresh();
      await EasyLoading.dismiss();

    }on UnknownException catch(e){
      print("ERROR IS $e");
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<void> getLeaveCarry({required LeaveCarryData data}) async{
    try{
      await EasyLoading.show();
      LeaveCarryResponse response = await useCase.getLeaveCarry(data: data);
      leaveCarry.value=response;
      leaveCarry.refresh();
      await EasyLoading.dismiss();

    }on UnknownException catch(e){
      print("ERROR IS $e");
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<void> getLeaveStatusDetail({required LeaveStatusData data}) async{
    try{
      await EasyLoading.show();
      List<LeaveStatusResponse> response = await useCase.getLeaveStatusDetail(data: data);
      statusDetailList.value=response;
      statusDetailList.refresh();
      print("HLKJKERJ THIS IS${statusDetailList}");
      await EasyLoading.dismiss() ;

    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<void> getLeaveStatusFirst({required LeaveStatusData data}) async{
    try{
      await EasyLoading.show();
      List<LeaveStatusResponse> response = await useCase.getLeaveStatusFirst(data: data);
      statusFirstList.value=response;
      statusFirstList.refresh();
      await EasyLoading.dismiss();

    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<void> getLeaveStatusSecond({required LeaveStatusData data}) async{
    try{
      await EasyLoading.show();
      List<LeaveStatusResponse> response = await useCase.getLeaveStatusSecond(data: data);
      statusSecondList.value=response;
      statusSecondList.refresh();
      await EasyLoading.dismiss();

    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }


}