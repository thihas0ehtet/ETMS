import 'package:etms/data/datasources/request/allowed_dates_data.dart';
import 'package:etms/data/datasources/request/leave_carry_data.dart';
import 'package:etms/data/datasources/request/leave_report_data.dart';
import 'package:etms/data/datasources/request/leave_status_data.dart';
import 'package:etms/data/datasources/response/allowed_date_response.dart';
import 'package:etms/data/datasources/response/apply_leave/apply_leave_response.dart';
import 'package:etms/domain/repositories/leave_repository.dart';

class LeaveUseCase{
  final LeaveRepository respository;
  LeaveUseCase(this.respository);

  Future<List<LeaveTypeData>> getLeaveTypes() async{
    return respository.getLeaveTypes();
  }

  Future<List<LeaveReportDataResponse>> getLeaveReportList({required LeaveReportData data}) async{
    return respository.getLeaveReportList(data: data);
  }

  Future<List<AllowedDateResponse>> getAllowedDates({required AllowedDatesData data, required int start, required int end}) async{
    return respository.getAllowedDates(data: data, start: start, end: end);
  }

  Future<LeaveCarryResponse> getLeaveCarry({required LeaveCarryData data}) async{
    return respository.getLeaveCarry(data: data);
  }

  Future<List<LeaveStatusResponse>> getLeaveStatusDetail({required LeaveStatusData data}) async{
    return respository.getLeaveStatusDetail(data: data);
  }
  Future<List<LeaveStatusResponse>> getLeaveStatusFirst({required LeaveStatusData data}) async{
    return respository.getLeaveStatusFirst(data: data);
  }
  Future<List<LeaveStatusResponse>> getLeaveStatusSecond({required LeaveStatusData data}) async{
    return respository.getLeaveStatusSecond(data: data);
  }
}