import 'package:etms/app/config/api_constants.dart';
import 'package:etms/app/utils/api_link.dart';
import 'package:etms/app/utils/response_code.dart';
import 'package:etms/data/datasources/request/allowed_dates_data.dart';
import 'package:etms/data/datasources/request/leave_report_data.dart';
import 'package:etms/data/datasources/response/allowed_date_response.dart';
import 'package:etms/domain/repositories/leave_repository.dart';
import 'package:get/get.dart';
import '../../app/api/base_provider.dart';
import '../../app/helpers/error_handling/unknown_error.dart';
import '../../app/helpers/shared_preference_helper.dart';
import '../datasources/request/leave_carry_data.dart';
import '../datasources/request/leave_status_001_data.dart';
import '../datasources/request/leave_status_data.dart';
import '../datasources/response/apply_leave/apply_leave_response.dart';

class LeaveRepoImpl extends BaseProvider implements LeaveRepository{
  @override
  Future<List<LeaveTypeData>> getLeaveTypes() async{
    try{
      String apiLink = await ApiConstants.getLeaveType.link();
      SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
      String sysId= await _sharedPrefs.getEmpSysId;

      final Response response  = await get(apiLink+'?Emp_Sys_ID=$sysId');
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){

        List<LeaveTypeData> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(LeaveTypeData.fromJson(response.body[i]));
        }
        return list;
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }
    catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<LeaveReportDataResponse>> getLeaveReportList({required LeaveReportData data}) async {
    try{
      String apiLink = await ApiConstants.getLeaveReportList.link();
      SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
      // String dataString='{"emp_sys_id":2882,"ltype":1,"leaveyear":2023,"active":"A","uid":1,"unit_id":0}';
      String dataString='{"emp_sys_id":${data.emp_sys_id},"ltype":${data.ltype},"leaveyear":${data.leaveyear},"active":"A","uid":1,"unit_id":0}';

      final Response response  = await post(apiLink,dataString);
      print("RESPONS IS ${response.body} and $response");
      print(response.statusCode);
      // print("SZ is ${response.body[0]}");
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        List<LeaveReportDataResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(LeaveReportDataResponse.fromJson(response.body[i]));
        }
        return list;
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }
    catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<AllowedDateResponse>> getAllowedDates({required AllowedDatesData data, required int start, required int end}) async {
    try{
      String apiLink = await ApiConstants.getDates.link();

      final Response response  = await post('$apiLink?StartAMPM=$start&EndAMPM=$end',data.toJson());
      print("FJDLFJSDF '$apiLink?StartAMPM=$start&EndAMPM=$end'");
      print(data.toJson());
      print("SZ is ${response.body} ${response.statusCode}");
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        List<AllowedDateResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(AllowedDateResponse.fromJson(response.body[i]));
        }
        return list;
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }
    catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<AllowedDateResponse>> getDateDetail({required AllowedDatesData data, required int start, required int end}) async {
    try{
      String apiLink = await ApiConstants.getDatesDetail.link();

      final Response response  = await post('$apiLink?StartAMPM=$start&EndAMPM=$end',data.toJson());
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        List<AllowedDateResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(AllowedDateResponse.fromJson(response.body[i]));
        }
        return list;
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }
    catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<LeaveCarryResponse> getLeaveCarry({required LeaveCarryData data}) async {
    try{
      String apiLink = await ApiConstants.getLeaveCarry.link();
      SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
      String dataString= '{"Emp_Sys_ID":${data.empSysId},"LeaveType_ID":${data.leaveTypeId},"unitl":"${data.unitl}","Leave_App_ID":0}';

      final Response response  = await post(apiLink,dataString);
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        return LeaveCarryResponse.fromJson(response.body);
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }
    catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<LeaveStatusResponse>> getLeaveStatusDetail({required LeaveStatusData data}) async {
    try{
      String apiLink = await ApiConstants.getLeaveStatusDetail.link();
      apiLink = '$apiLink?EmpSysID=${data.empSysId}&SelectDate=${data.selectDate}';

      final Response response  = await get(apiLink);
      // print("SZ is ${response.body[0]}");
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        List<LeaveStatusResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(LeaveStatusResponse.fromJson(response.body[i]));
        }
        return list;
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }
    catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<LeaveStatusResponse>> getLeaveStatusFirst({required LeaveStatusData data}) async {
    try{
      String apiLink = await ApiConstants.getLeaveStatusFirst.link();
      apiLink = '$apiLink?EmpSysID=${data.empSysId}&SelectDate=${data.selectDate}';

      final Response response  = await get(apiLink);
      // print("SZ is ${response.body[0]}");
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        List<LeaveStatusResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(LeaveStatusResponse.fromJson(response.body[i]));
        }
        return list;
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }
    catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<LeaveStatusResponse>> getLeaveStatusSecond({required LeaveStatusData data}) async {
    try{
      String apiLink = await ApiConstants.getLeaveStatusSecond.link();
      apiLink = '$apiLink?EmpSysID=${data.empSysId}&SelectDate=${data.selectDate}';

      final Response response  = await get(apiLink);
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        List<LeaveStatusResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(LeaveStatusResponse.fromJson(response.body[i]));
        }
        return list;
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }
    catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<LeaveStatusResponse>> getLeaveStatusDetail_001({required LeaveStatus001Data data}) async {
    try{
      String apiLink = await ApiConstants.getLeaveStatusDetail_001.link();
      apiLink = '$apiLink?EmpSysID=${data.empSysId}&sdate=${data.sdate}&edate=${data.edate}';
      print("And api Link is $apiLink");
      final Response response  = await get(apiLink);
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        List<LeaveStatusResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(LeaveStatusResponse.fromJson(response.body[i]));
        }
        return list;
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }
    catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<LeaveStatusResponse>> getLeaveStatusFirstApproval_001({required LeaveStatus001Data data}) async {
    try{
      String apiLink = await ApiConstants.getLeaveStatusFirstApproval_001.link();
      apiLink = '$apiLink?EmpSysID=${data.empSysId}&sdate=${data.sdate}&edate=${data.edate}';

      final Response response  = await get(apiLink);
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        List<LeaveStatusResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(LeaveStatusResponse.fromJson(response.body[i]));
        }
        return list;
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }
    catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<LeaveStatusResponse>> getLeaveStatusSecondApproval_001({required LeaveStatus001Data data}) async {
    try{
      String apiLink = await ApiConstants.getLeaveStatusSecondApproval_001.link();
      apiLink = '$apiLink?EmpSysID=${data.empSysId}&sdate=${data.sdate}&edate=${data.edate}';

      final Response response  = await get(apiLink);
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        List<LeaveStatusResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(LeaveStatusResponse.fromJson(response.body[i]));
        }
        return list;
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }
    catch(e){
      throw UnknownException(e.toString());
    }
  }
}