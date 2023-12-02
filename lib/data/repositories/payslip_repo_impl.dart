import 'package:etms/app/utils/api_link.dart';
import 'package:etms/data/datasources/request/payroll_detail_data.dart';
import 'package:etms/data/datasources/response/payslip/payslip_response.dart';
import 'package:etms/domain/repositories/payslip_respository.dart';
import 'package:get/get.dart';
import '../../app/api/base_provider.dart';
import '../../app/config/api_constants.dart';
import '../../app/helpers/error_handling/unknown_error.dart';
import '../../app/helpers/shared_preference_helper.dart';

class PaySlipRepoImpl extends BaseProvider implements PaySlipRepository{
  @override
  Future<List<PayrollPeriodResponse>> getPayPeriod() async{
    try{
      String apiLink = await ApiConstants.getPayrollPayPeriod.link();
      SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
      String sysId= await _sharedPrefs.getEmpSysId;

      final Response response  = await get(apiLink+'?Emp_Sys_ID=$sysId');
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode==200){

        List<PayrollPeriodResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(PayrollPeriodResponse.fromJson(response.body[i]));
        }
        return list;
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }
    catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<PayrollDetailResponse> getPayDetail(PayrollDetailData data) async {
    try{
      String apiLink = await ApiConstants.getPayrollDetail.link();
      apiLink = '$apiLink?Emp_Sys_ID=${data.empSysId}&unit_id=${data.unitId}&Payroll_Period_ID=${data.id}';
      final Response response  = await get(apiLink);
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode==200){
        return PayrollDetailResponse.fromJson(response.body[0]);
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }
    catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<PayslipAllowanceResponse>> getPayslipAllowance(PayrollDetailData data) async {
    try{
      String apiLink = await ApiConstants.getPayslipAllowance.link();
      apiLink = '$apiLink?Emp_Sys_ID=${data.empSysId}&unit_id=${data.unitId}&Payroll_Period_ID=${data.id}';
      final Response response  = await get(apiLink);
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode==200){
        List<PayslipAllowanceResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(PayslipAllowanceResponse.fromJson(response.body[i]));
        }
        return list;
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }
    catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<PayslipDeductionResponse>> getPayslipDeduction(PayrollDetailData data) async {
    try{
      String apiLink = await ApiConstants.getPayslipDeduction.link();
      apiLink = '$apiLink?Emp_Sys_ID=${data.empSysId}&unit_id=${data.unitId}&Payroll_Period_ID=${data.id}';
      final Response response  = await get(apiLink);
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode==200){
        List<PayslipDeductionResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(PayslipDeductionResponse.fromJson(response.body[i]));
        }
        return list;
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }
    catch(e){
      throw UnknownException(e.toString());
    }
  }

}