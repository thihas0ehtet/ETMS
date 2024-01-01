import 'package:etms/data/datasources/request/attendance_approval_data.dart';
import 'package:etms/data/datasources/request/attendance_report_data.dart';
import 'package:etms/data/datasources/response/attendance_report/attendance_report_response.dart';
import '../../data/datasources/response/attendance_report/general_setting_response.dart';
import '../../data/datasources/response/attendance_report/qr_code_response.dart';

abstract class AttendanceRepository{
  Future<List<AttReportResponse>> getAttendanceReport({required AttendanceReportData data});
  Future<AttReportSummaryResponse> getAttReportSummary({required AttendanceReportData data});
  Future<List<QRCodeResponse>> getQRCodeList();
  Future<GeneralSettingResponse> getGeneralSetting();
  Future<bool> applyAttendance({required AttendanceApprovalData data});
}