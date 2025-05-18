import 'package:etms/data/datasources/request/attendance/attendance_report_data.dart';
import 'package:etms/domain/repositories/attendance_repository.dart';
import '../../data/datasources/request/attendance/attendance_approval_data.dart';
import '../../data/datasources/response/attendance_report/attendance_report_response.dart';
import '../../data/datasources/response/attendance_report/general_setting_response.dart';
import '../../data/datasources/response/attendance_report/qr_code_response.dart';

class AttendanceUseCase{
  final AttendanceRepository respository;
  AttendanceUseCase(this.respository);

  Future<List<AttReportResponse>> getAttendanceReport({required AttendanceReportData data}) async{
    return respository.getAttendanceReport(data: data);
  }

  Future<AttReportSummaryResponse> getAttReportSummary({required AttendanceReportData data}) async{
    return respository.getAttReportSummary(data: data);
  }

  Future<GeneralSettingResponse> getGeneralSetting() async{
    return respository.getGeneralSetting();
  }

  Future<List<QRCodeResponse>> getQRCodeList() async{
    return respository.getQRCodeList();
  }

  Future<bool> applyAttendance({required AttendanceApprovalData data}) async{
    return respository.applyAttendance(data: data);
  }
}