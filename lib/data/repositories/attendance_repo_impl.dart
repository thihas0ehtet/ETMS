import 'package:etms/app/config/api_constants.dart';
import 'package:etms/app/helpers/helper.dart';
import 'package:etms/app/utils/api_link.dart';
import 'package:etms/app/utils/response_code.dart';
import 'package:etms/data/datasources/response/attendance_report/attendance_report_response.dart';
import 'package:etms/domain/repositories/attendance_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import '../../app/api/base_provider.dart';
import '../../app/helpers/error_handling/InternetException.dart';
import '../../app/helpers/error_handling/unknown_error.dart';
import '../datasources/request/attendance/attendance_approval_data.dart';
import '../datasources/request/attendance/attendance_report_data.dart';
import '../datasources/response/attendance_report/general_setting_response.dart';
import '../datasources/response/attendance_report/qr_code_response.dart';

class AttendanceRepoImpl extends BaseProvider implements AttendanceRepository{
  Helper helper = Helper();
  @override
  Future<List<AttReportResponse>> getAttendanceReport({required AttendanceReportData data}) async{
    try{
      await helper.checkInternetConnection();
      String apiLink = await ApiConstants.getAttendance.link();
      final Response response  = await post(apiLink,data.toJson());
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode==200){
        List<AttReportResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(AttReportResponse.fromJson(response.body[i]));
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
  Future<AttReportSummaryResponse> getAttReportSummary({required AttendanceReportData data}) async {
    try{
      await helper.checkInternetConnection();
      String apiLink = await ApiConstants.getAttSummary.link();
      final Response response  = await post(apiLink,data.toJson());
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode==200){
        return AttReportSummaryResponse.fromJson(response.body[0]);
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
  Future<GeneralSettingResponse> getGeneralSetting() async{
    try{
      await helper.checkInternetConnection();
      String apiLink = await ApiConstants.getGeneralSetting.link();
      final Response response  = await get(apiLink);
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        return GeneralSettingResponse.fromJson(response.body[0]);
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
  Future<List<QRCodeResponse>> getQRCodeList() async{
    try{
      await helper.checkInternetConnection();
      String apiLink = await ApiConstants.getQRCode.link();
      final Response response  = await get(apiLink);
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        List<QRCodeResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(QRCodeResponse.fromJson(response.body[i]));
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
  Future<bool> applyAttendance({required AttendanceApprovalData data}) async{
    try{
      Helper helper = Helper();
      await helper.checkInternetConnection();
      String apiLink = await ApiConstants.applyAttendance.link();
      final Response response  = await post(apiLink,data.toJson());
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        return true;
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