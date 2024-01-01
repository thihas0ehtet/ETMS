import 'package:etms/data/datasources/request/allowed_dates_data.dart';
import 'package:etms/data/datasources/request/leave_report_data.dart';
import 'package:etms/data/datasources/request/leave_status_data.dart';
import 'package:etms/data/datasources/response/apply_leave/apply_leave_response.dart';
import '../../data/datasources/request/leave_carry_data.dart';
import '../../data/datasources/request/leave_status_001_data.dart';
import '../../data/datasources/response/allowed_date_response.dart';

abstract class LeaveRepository{
  Future<List<LeaveTypeData>> getLeaveTypes();
  Future<List<LeaveReportDataResponse>> getLeaveReportList({required LeaveReportData data});
  Future<List<AllowedDateResponse>> getAllowedDates({required AllowedDatesData data, required int start, required int end});
  Future<List<AllowedDateResponse>> getDateDetail({required AllowedDatesData data, required int start, required int end});
  Future<LeaveCarryResponse> getLeaveCarry({required LeaveCarryData data});
  Future<List<LeaveStatusResponse>> getLeaveStatusDetail({required LeaveStatusData data});
  Future<List<LeaveStatusResponse>> getLeaveStatusFirst({required LeaveStatusData data});
  Future<List<LeaveStatusResponse>> getLeaveStatusSecond({required LeaveStatusData data});

  Future<List<LeaveStatusResponse>> getLeaveStatusFirstApproval_001({required LeaveStatus001Data data});
  Future<List<LeaveStatusResponse>> getLeaveStatusSecondApproval_001({required LeaveStatus001Data data});
  Future<List<LeaveStatusResponse>> getLeaveStatusDetail_001({required LeaveStatus001Data data});
}