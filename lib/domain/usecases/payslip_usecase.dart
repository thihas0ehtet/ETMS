import 'package:etms/domain/repositories/payslip_respository.dart';
import '../../data/datasources/request/payslip/payroll_detail_data.dart';
import '../../data/datasources/response/payslip/payslip_response.dart';

class PaySlipUsecase{
  final PaySlipRepository respository;
  PaySlipUsecase(this.respository);

  Future<List<PayrollPeriodResponse>> getPayPeriod() async{
    return respository.getPayPeriod();
  }

  Future<PayrollDetailResponse> getPayDetail(PayrollDetailData data) async{
    return respository.getPayDetail(data);
  }

  Future<List<PayslipAllowanceResponse>> getPayslipAllowance(PayrollDetailData data) async{
    return respository.getPayslipAllowance(data);
  }

  Future<List<PayslipDeductionResponse>> getPayslipDeduction(PayrollDetailData data) async{
    return respository.getPayslipDeduction(data);
  }
}