import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/data/datasources/request/payroll_detail_data.dart';
import 'package:etms/data/datasources/response/payslip/payslip_allowance_response.dart';
import 'package:etms/data/datasources/response/payslip/payslip_deduciton_response.dart';
import 'package:etms/presentation/pay_slip/widget/data_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/config/config.dart';
import '../../app/helpers/shared_preference_helper.dart';
import '../../data/datasources/response/payslip/payroll_detail_response.dart';
import '../controllers/payslip_controller.dart';
import '../widgets/my_app_bar.dart';

class PaySlipDetail extends StatefulWidget {
  const PaySlipDetail({super.key});

  @override
  State<PaySlipDetail> createState() => _PaySlipDetailState();
}

class _PaySlipDetailState extends State<PaySlipDetail> {
  PaySlipController controller = Get.find();
  PayrollDetailResponse? detail;
  List<PayslipAllowanceResponse> allowanceList = [];
  List<PayslipDeductionResponse> deductionList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData()async{
    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
    String sysId= await _sharedPrefs.getEmpSysId;
    PayrollDetailData data = PayrollDetailData(
        empSysId: sysId,
        unitId: '0',
        id: Get.arguments.toString()
    );
    await controller.getPayDetail(data);
    setState(() {
      detail=controller.payDetail.value;
    });

    await controller.getPayslipAllowance(data);
    setState(() {
      allowanceList=controller.payslipAllowList;
    });

    await controller.getPayslipDeduction(data);
    setState(() {
      deductionList=controller.payslipDedList;
    });
  }


  Widget widgetInfo(String title, String info){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: latoRegular.copyWith(color: ColorResources.text300),),
        Text(info,style: latoRegular.copyWith(color: ColorResources.text500),)
      ],
    ).paddingOnly(bottom: 15);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorResources.background,
        appBar:  MyAppBar(
          title: 'Payroll Summary',
        ),
        body: SingleChildScrollView(
          child: detail!=null?
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15,),
              Center(child: Text('Strictly Private & Confidential', style: latoBold.copyWith(fontSize: 15),)),
              const SizedBox(height: 25,),
              widgetInfo('Department', detail!.unitPath.toString()),
              widgetInfo('Pay Period', '${DateTime.parse(detail!.periodStart.toString()).dMY()} To ${DateTime.parse(detail!.periodEnd.toString()).dMY()}'),
              widgetInfo('Payment Date', DateTime.parse(detail!.payDate.toString()).dMY().toString()),
              widgetInfo('Staff Name', detail!.empName.toString()),
              widgetInfo('NRIC/FIN', detail!.finNumber.toString()==''?'-':detail!.finNumber.toString()),

              const SizedBox(height: 20,),

              if(allowanceList.isNotEmpty)
              Text('ADDITIONS',style: latoSemibold).paddingOnly(bottom: 5),
              if(allowanceList.isNotEmpty)
                DataTableWidget(
                    dataList: allowanceList,
                    context: context,
                    isAllowance: true,
                  total: detail!.totalAllowance.toString()
                ).paddingOnly(bottom: 25),

              if(deductionList.isNotEmpty)
                Text('DEDUCTIONS',style: latoSemibold).paddingOnly(bottom: 5),
              if(deductionList.isNotEmpty)
                DataTableWidget(
                    dataList: deductionList,
                    context: context,
                    isAllowance: false,
                    total: detail!.totalDeduction.toString()
                ).paddingOnly(bottom: 25),

              widgetInfo('Net Pay', detail!.netAmount.toString()),
              widgetInfo("Employee's cpf", detail!.employerContribution??'-'),
              widgetInfo("Total cpf", detail!.totalContribution??'-'),
            ],
          ).paddingOnly(left: 20, right: 20)
              :Container(),
        ),
      ),
    );
  }
}
