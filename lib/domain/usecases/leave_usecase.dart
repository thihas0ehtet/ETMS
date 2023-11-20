import 'package:etms/data/datasources/request/allowed_dates_data.dart';
import 'package:etms/data/datasources/request/leave_carry_data.dart';
import 'package:etms/data/datasources/request/leave_report_data.dart';
import 'package:etms/data/datasources/response/allowed_date_response.dart';
import 'package:etms/data/datasources/response/leave_carry_response.dart';
import 'package:etms/data/datasources/response/leave_list_response.dart';
import 'package:etms/data/datasources/response/leave_type_response.dart';
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

  Future<List<AllowedDateResponse>> getAllowedDates({required AllowedDatesData data}) async{
    return respository.getAllowedDates(data: data);
  }

  Future<LeaveCarryResponse> getLeaveCarry({required LeaveCarryData data}) async{
    return respository.getLeaveCarry(data: data);
  }
}