import 'package:etms/data/datasources/request/allowed_dates_data.dart';
import 'package:etms/data/datasources/request/leave_report_data.dart';
import 'package:etms/data/datasources/response/allowed_date_response.dart';
import 'package:etms/data/datasources/response/leave_carry_response.dart';
import 'package:etms/data/datasources/response/leave_list_response.dart';
import 'package:etms/data/datasources/response/leave_type_response.dart';

import '../../data/datasources/request/leave_carry_data.dart';

abstract class LeaveRepository{
  Future<List<LeaveTypeData>> getLeaveTypes();
  Future<List<LeaveReportDataResponse>> getLeaveReportList({required LeaveReportData data});
  Future<List<AllowedDateResponse>> getAllowedDates({required AllowedDatesData data});
  Future<LeaveCarryResponse> getLeaveCarry({required LeaveCarryData data});
}