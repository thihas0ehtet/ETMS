import 'package:etms/app/route/route_name.dart';
import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/presentation/controllers/payslip_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app/config/config.dart';
import '../../data/datasources/response/payslip/payslip_response.dart';
import '../widgets/my_app_bar.dart';

class PaySlipPeriodScreen extends StatefulWidget {
  const PaySlipPeriodScreen({super.key});

  @override
  State<PaySlipPeriodScreen> createState() => _PaySlipPeriodScreenState();
}

class _PaySlipPeriodScreenState extends State<PaySlipPeriodScreen> {
  PaySlipController controller = Get.find();
  List<PayrollPeriodResponse> payPeriodList=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPayPeriod();
  }

  getPayPeriod() async{
    await controller.getPayPeriod();
    setState(() {
      payPeriodList=controller.payPeriodList;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: ColorResources.white,
          appBar: MyAppBar(title: 'PaySlip'),
          body: SingleChildScrollView(
            child:
                ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: payPeriodList.length,
                  itemBuilder: (context,index){
                    var data = payPeriodList[index];
                    return GestureDetector(
                      onTap: (){
                        Get.toNamed(RouteName.payslip_detail,
                        arguments: data.payrollPeriodID);
                      },
                      child: Container(
                        color: ColorResources.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset('assets/images/payslip.svg',width: 25,height: 25,
                                  color: ColorResources.primary800,).paddingOnly(right: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data.payrollPeriodDescription.toString(),
                                      style: latoSemibold.copyWith(color: ColorResources.text500,
                                          fontSize: 16
                                      ),).paddingOnly(bottom: 10),
                                    Text((DateTime.parse(data.payrollDate.toString()).dMYE()).toString(),
                                      style: latoRegular.copyWith(color: ColorResources.text300, fontSize: 12),)
                                  ],
                                )
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios_rounded, size: 20, color: ColorResources.primary800,),
                          ],
                        ).paddingOnly(bottom: 20),
                      ),
                    );
                  },
                )
          ).paddingAll(20),
        ));
  }
}
