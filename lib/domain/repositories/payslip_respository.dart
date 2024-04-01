import 'package:etms/data/datasources/request/payslip/payroll_detail_data.dart';
import 'package:etms/data/datasources/response/payslip/payslip_response.dart';

abstract class PaySlipRepository {
  Future<List<PayrollPeriodResponse>> getPayPeriod();
  Future<PayrollDetailResponse> getPayDetail(PayrollDetailData data);
  Future<List<PayslipAllowanceResponse>> getPayslipAllowance(PayrollDetailData data);
  Future<List<PayslipDeductionResponse>> getPayslipDeduction(PayrollDetailData data);
}