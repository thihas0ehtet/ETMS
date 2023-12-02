import 'package:etms/data/datasources/request/attendance_report_data.dart';
import 'package:etms/data/datasources/response/attendance_report/attendance_report_response.dart';

abstract class AttendanceRepository{
  Future<List<AttReportResponse>> getAttendanceReport({required AttendanceReportData data});
  Future<AttReportSummaryResponse> getAttReportSummary({required AttendanceReportData data});
}