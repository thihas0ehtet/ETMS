import 'package:etms/data/datasources/request/attendance_report_data.dart';
import 'package:etms/data/datasources/request/login_data.dart';
import 'package:etms/data/datasources/response/att_report_response.dart';
import 'package:etms/data/datasources/response/login_response.dart';
import 'package:etms/domain/repositories/attendance_repository.dart';
import 'package:etms/domain/repositories/auth_repository.dart';
import 'package:get/get.dart';

class AttendanceUseCase{
  final AttendanceRepository respository;
  AttendanceUseCase(this.respository);

  Future<List<AttReportResponse>> getAttendanceReport({required AttendanceReportData data}) async{
    return respository.getAttendanceReport(data: data);
  }
}