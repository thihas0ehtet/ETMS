import 'dart:core';
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
import 'package:intl/intl.dart';
import '../../app/helpers/error_handling/unknown_error.dart';
import '../../data/datasources/request/leave_status_001_data.dart';

class LeaveController extends GetxController with StateMixin{
  final LeaveRepository repository;
  LeaveController({required this.repository});

  // Rx<LeaveTypeResponse> leaveTypeResponse = LeaveTypeResponse().obs;
  RxList<LeaveTypeData> leaveTypes=  RxList<LeaveTypeData>();
  RxList<LeaveReportDataResponse> leaveReportList=  RxList<LeaveReportDataResponse>();
  RxList<AllowedDateResponse> allowedDateList=  RxList<AllowedDateResponse>();
  RxList<AllowedDateResponse> allowedDateDetail =  RxList<AllowedDateResponse>();
  Rx<LeaveCarryResponse> leaveCarry = LeaveCarryResponse().obs;
  RxList<LeaveStatusResponse> statusDetailList=  RxList<LeaveStatusResponse>();
  RxList<LeaveStatusResponse> statusFirstList=  RxList<LeaveStatusResponse>();
  RxList<LeaveStatusResponse> statusSecondList=  RxList<LeaveStatusResponse>();

  RxList<LeaveStatusResponse> statusDetailList_001=  RxList<LeaveStatusResponse>();
  RxList<LeaveStatusResponse> statusFirstList_001=  RxList<LeaveStatusResponse>();
  RxList<LeaveStatusResponse> statusSecondList_001=  RxList<LeaveStatusResponse>();

  RxBool isStatusListLoading = false.obs;
  RxBool isStatusList_001Loading = true.obs;
  RxMap<dynamic, List<LeaveStatusResponse>> kEvents = <dynamic, List<LeaveStatusResponse>>{}.obs;

  LeaveUseCase useCase = LeaveUseCase(Get.find());

  Future<void> getLeaveTypes() async{
    try{
      await EasyLoading.show();
     List<LeaveTypeData> response = await useCase.getLeaveTypes();
      leaveTypes.value=response;
      leaveTypes.refresh();
      refresh();
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
      refresh();
      await EasyLoading.dismiss();

    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  clearLeaveReportList(){
    leaveReportList.clear();
    leaveReportList.refresh();
    refresh();
  }

  clearLeaveCarry(){
    leaveCarry.value=LeaveCarryResponse();
    leaveCarry.refresh();
    refresh();
  }

  Future<void> getAllowedDates({required AllowedDatesData data, required int start, required int end}) async{
    try{
      await EasyLoading.show();
      List<AllowedDateResponse> response = await useCase.getAllowedDates(data: data, start: start, end: end);
      allowedDateList.value=response;
      allowedDateList.refresh();
      refresh();
      response = await useCase.getDateDetail(data: data, start: start, end: end);
      allowedDateDetail.value = response;
      allowedDateDetail.refresh();
      refresh();
      await EasyLoading.dismiss();

    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  // Future<void> getDateDetail({required AllowedDatesData data, required int start, required int end}) async{
  //   try{
  //     await EasyLoading.show();
  //     List<AllowedDateResponse> response = await useCase.getAllowedDates(data: data, start: start, end: end);
  //     allowedDateDetail.value=response;
  //     allowedDateDetail.refresh();
  //     await EasyLoading.dismiss();
  //
  //   }on UnknownException catch(e){
  //     e.toString().error();
  //     await EasyLoading.dismiss();
  //   }
  // }

  Future<void> getLeaveCarry({required LeaveCarryData data}) async{
    try{
      await EasyLoading.show();
      LeaveCarryResponse response = await useCase.getLeaveCarry(data: data);
      leaveCarry.value=response;
      leaveCarry.refresh();
      refresh();
      await EasyLoading.dismiss();

    }on UnknownException catch(e){
      print("ERROR IS $e");
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<void> getLeaveStatusList({required LeaveStatusData data}) async{
    try{
      isStatusListLoading.value = true;
      await EasyLoading.show();
      List<LeaveStatusResponse> detailList = await useCase.getLeaveStatusDetail(data: data);
      statusDetailList.value=detailList;
      statusDetailList.refresh();
      List<LeaveStatusResponse> firstList = await useCase.getLeaveStatusFirst(data: data);
      statusFirstList.value=firstList;
      statusFirstList.refresh();

      List<LeaveStatusResponse> secondList = await useCase.getLeaveStatusSecond(data: data);
      statusSecondList.value=secondList;
      statusSecondList.refresh();


      List<String> dateTimeList=[];
      DateTime dateTime = DateFormat("dd-MMM-yyyy").parse(data.selectDate.toString());
      DateTime currentDate = DateTime(dateTime.year, dateTime.month, 1);

      // Get the last day of the month
      DateTime lastDateOfMonth = DateTime(dateTime.year, dateTime.month + 1, 0);

      // Iterate through the days of the month
      while (currentDate.isBefore(lastDateOfMonth) || currentDate.isAtSameMomentAs(lastDateOfMonth)) {
        dateTimeList.add(DateFormat('dd-MMM-yyyy').format(currentDate));
        // dateTimeList.add(DateFormat("dd-MMM-yyyy").parse(currentDate.toString()));
        currentDate = currentDate.add(Duration(days: 1));
      }
      if((detailList+firstList+secondList).isNotEmpty){
        Map<dynamic, List<LeaveStatusResponse>> kEventTemp = {};
        for(var i=0;i<dateTimeList.length;i++){
          kEventTemp[dateTimeList[i]]=[];
        }
        List<LeaveStatusResponse> list = detailList+firstList+secondList;
        for(var i=0;i<list.length;i++){
          String leaveDate = DateFormat('dd-MMM-yyyy').format(DateTime.parse(list[i].leaveDate!));

          // kEvents.value={};
          kEventTemp[leaveDate]!.add(list[i]);
          // kEvents.addAll({leaveDate: list[i]});

          // if(dateTimeList.contains(leaveDate)){
          //
          // }
        }

        kEventTemp.removeWhere((key, value) => value.isEmpty);
        print("HELLO kEventTemp is $kEventTemp");

        // if(kEvents.containsKey(data.selectDate)){
        //   kEvents[data.selectDate]=detailList+firstList+secondList;
        // } else{
        //   kEvents.addAll({
        //     data.selectDate:detailList+firstList+secondList
        //   });
        // }
        kEvents.value=kEventTemp;
        kEvents.refresh();
        refresh();

      } else{
        kEvents.value={};
        kEvents.removeWhere((key, value) => key==data.selectDate);
      }
      kEvents.refresh();
      await EasyLoading.dismiss() ;
      isStatusListLoading.value = false;
      refresh();

    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
      isStatusListLoading.value = false;
      refresh();
    }
  }

  Future<void> getLeaveStatusList_001({required LeaveStatus001Data data}) async{
    try{
      isStatusList_001Loading.value = true;
      await EasyLoading.show();
      List<LeaveStatusResponse> detailList = await useCase.getLeaveStatusDetail_001(data: data);
      statusDetailList_001.value=detailList;
      statusDetailList_001.refresh();
      List<LeaveStatusResponse> firstList = await useCase.getLeaveStatusFirstApproval_001(data: data);
      statusFirstList_001.value=firstList;
      statusFirstList_001.refresh();

      List<LeaveStatusResponse> secondList = await useCase.getLeaveStatusSecondApproval_001(data: data);
      statusSecondList_001.value=secondList;
      statusSecondList_001.refresh();

      await EasyLoading.dismiss() ;
      isStatusList_001Loading.value = false;
      refresh();

    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
      isStatusList_001Loading.value = false;
      refresh();
    }
  }

  // Future<void> getLeaveStatusFirst({required LeaveStatusData data}) async{
  //   try{
  //     isStatusFirstLoading = true;
  //     await EasyLoading.show();
  //     List<LeaveStatusResponse> response = await useCase.getLeaveStatusFirst(data: data);
  //     statusFirstList.value=response;
  //     statusFirstList.refresh();
  //     refresh();
  //     await EasyLoading.dismiss();
  //     isStatusFirstLoading = false;
  //
  //   }on UnknownException catch(e){
  //     e.toString().error();
  //     await EasyLoading.dismiss();
  //     isStatusFirstLoading = false;
  //   }
  // }

  // Future<void> getLeaveStatusSecond2({required LeaveStatusData data}) async{
  //   try{
  //     isStatusSecondLoading = true;
  //     await EasyLoading.show();
  //     List<LeaveStatusResponse> response = await useCase.getLeaveStatusSecond(data: data);
  //     statusSecondList.value=response;
  //     statusSecondList.refresh();
  //     refresh();
  //     await EasyLoading.dismiss();
  //     isStatusSecondLoading = false;
  //
  //   }on UnknownException catch(e){
  //     e.toString().error();
  //     await EasyLoading.dismiss();
  //     isStatusSecondLoading = false;
  //   }
  // }


}