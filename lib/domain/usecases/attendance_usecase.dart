import 'package:etms/data/datasources/request/attendance_report_data.dart';
import 'package:etms/domain/repositories/attendance_repository.dart';
import '../../data/datasources/response/attendance_report/attendance_report_response.dart';

class AttendanceUseCase{
  final AttendanceRepository respository;
  AttendanceUseCase(this.respository);

  Future<List<AttReportResponse>> getAttendanceReport({required AttendanceReportData data}) async{
    return respository.getAttendanceReport(data: data);
  }

  Future<AttReportSummaryResponse> getAttReportSummary({required AttendanceReportData data}) async{
    return respository.getAttReportSummary(data: data);
  }
}