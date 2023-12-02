import 'package:etms/app/utils/custom_snackbar.dart';
import 'package:etms/data/datasources/response/payslip/payslip_response.dart';
import 'package:etms/domain/repositories/payslip_respository.dart';
import 'package:etms/domain/usecases/payslip_usecase.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../app/helpers/error_handling/unknown_error.dart';
import '../../data/datasources/request/payroll_detail_data.dart';

class PaySlipController extends GetxController with StateMixin{
  final PaySlipRepository repository;
  PaySlipController({required this.repository});

  // Rx<LeaveTypeResponse> leaveTypeResponse = LeaveTypeResponse().obs;
  RxList<PayrollPeriodResponse> payPeriodList=  RxList<PayrollPeriodResponse>();
  Rx<PayrollDetailResponse> payDetail = PayrollDetailResponse().obs;
  RxList<PayslipAllowanceResponse> payslipAllowList=  RxList<PayslipAllowanceResponse>();
  RxList<PayslipDeductionResponse> payslipDedList=  RxList<PayslipDeductionResponse>();

  PaySlipUsecase useCase = PaySlipUsecase(Get.find());

  Future<void> getPayPeriod() async{
    try{
      await EasyLoading.show();
      List<PayrollPeriodResponse> response = await useCase.getPayPeriod();
      payPeriodList.value=response;
      payPeriodList.refresh();
      await EasyLoading.dismiss();

    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<void> getPayDetail(PayrollDetailData data) async{
    try{
      await EasyLoading.show();
      PayrollDetailResponse response = await useCase.getPayDetail(data);
      payDetail.value=response;
      payDetail.refresh();
      await EasyLoading.dismiss();

    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<void> getPayslipAllowance(PayrollDetailData data) async{
    try{
      await EasyLoading.show();
      List<PayslipAllowanceResponse> response = await useCase.getPayslipAllowance(data);
      payslipAllowList.value=response;
      payslipAllowList.refresh();
      await EasyLoading.dismiss();

    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<void> getPayslipDeduction(PayrollDetailData data) async{
    try{
      await EasyLoading.show();
      List<PayslipDeductionResponse> response = await useCase.getPayslipDeduction(data);
      payslipDedList.value=response;
      payslipDedList.refresh();
      await EasyLoading.dismiss();

    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }
}