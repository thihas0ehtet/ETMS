import 'package:etms/app/config/config.dart';
import 'package:etms/app/route/route_name.dart';
import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/data/datasources/request/claim/ot_request_data.dart';
import 'package:etms/presentation/controllers/claim_controller.dart';
import 'package:etms/presentation/widgets/custom_button.dart';
import 'package:etms/presentation/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/datasources/shared_preference_helper.dart';
import '../../../data/datasources/response/claim/ot_approval_response.dart';
import '../../widgets/simple_text_form.dart';

class OtClaimListView extends StatefulWidget {
  const OtClaimListView({super.key});

  @override
  State<OtClaimListView> createState() => _OtClaimListViewState();
}

class _OtClaimListViewState extends State<OtClaimListView> {
  ClaimController controller = Get.find();
  TextEditingController reasonController =  TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getOtApprovalList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    reasonController.dispose();
  }

  resetData(){
    reasonController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorResources.secondaryBackground,
            appBar: MyAppBar(title: 'OT Claim',
                widget: InkWell(
                    onTap: () async{
                      Get.toNamed(RouteName.otHistory);
                    },
                    child: Row(
                      children: [
                        Text('History',style: latoRegular.copyWith(color: ColorResources.white,
                            decoration: TextDecoration.underline, decorationColor: ColorResources.white),).paddingOnly(right: 10),
                        SvgPicture.asset('assets/images/history.svg',width: 16,height: 16,
                          color: ColorResources.white,)
                      ],
                    )
                )),
            body: Obx(()=>
            controller.listLoading.value && controller.otApprovalList.isEmpty? Container():
            controller.otApprovalList.isEmpty?
            Center(child: Text('There is no data.')).paddingOnly(top: 30):
            ListView.builder(
              shrinkWrap: true,
              itemCount: controller.otApprovalList.length,
              itemBuilder: (context,index){
                OtApprovalResponse data = controller.otApprovalList[index];
                return Material(
                  elevation: 1,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: ColorResources.secondary500,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(child: Text('You Worked Overtime', style: latoSemibold.copyWith(fontSize: 16),
                            )),
                            Text(DateTime.parse(data.attDat!).dMY().toString()).paddingOnly(left: 10)
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text('From', style: latoSemibold,).paddingOnly(right: 10).paddingOnly(right: 10),
                                Text(DateFormat('hh:mm a').format(DateTime.parse(data.sTime!)).toString(),)
                              ],
                            ),
                            Row(
                              children: [
                                Text('To', style: latoSemibold,).paddingOnly(right: 10),
                                Text(DateFormat('hh:mm a').format(DateTime.parse(data.eTime!)).toString(),)
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Text('OT Hour', style: latoSemibold,).paddingOnly(right: 10),
                            Text(data.hours.toString())
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Text('Rate', style: latoSemibold,).paddingOnly(right: 10),
                            Text(data.rate.toString())
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: CustomButton(
                              width: 100,
                              paddingTop: 7,
                              paddingBottom: 7,
                              onTap: (){
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                      backgroundColor: ColorResources.white,
                                      surfaceTintColor: ColorResources.white,
                                      content: Wrap(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Flexible(child: Text('You Worked Overtime', style: latoSemibold.copyWith(fontSize: 16),
                                              )),
                                              Text(DateTime.parse(data.attDat!).dMY().toString()).paddingOnly(left: 10)
                                            ],
                                          ).paddingOnly(bottom: 10),
                                          // SizedBox(height: 10,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text('From', style: latoSemibold,).paddingOnly(right: 10),
                                                  Text(DateFormat('hh:mm a').format(DateTime.parse(data.sTime!)).toString(),)
                                                ],
                                              ),
                                              Flexible(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text('To', style: latoSemibold,).paddingOnly(right: 10),
                                                      Flexible(child: Text(DateFormat('hh:mm a').format(DateTime.parse(data.eTime!)).toString(),))
                                                    ],
                                                  )
                                              )
                                            ],
                                          ).paddingOnly(bottom: 10),
                                          Text('Remark', style: latoSemibold,).paddingOnly(bottom: 5),
                                          SimpleTextFormField(
                                            controller: reasonController!,
                                            hintText: 'Why did you work overtime?',
                                            // isLate!?'Why are you late?':'Why are you too early?',
                                            maxLine: 3,
                                          ).paddingOnly(bottom: 10),
                                          Row(
                                            children: [
                                              Text('OT Hour', style: latoSemibold,).paddingOnly(right: 10),
                                              Text(data.hours.toString())
                                            ],
                                          ).paddingOnly(bottom: 10),
                                          Row(
                                            children: [
                                              Text('Rate', style: latoSemibold,).paddingOnly(right: 10),
                                              Text(data.rate.toString())
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: CustomButton(
                                                width: 100,
                                                paddingTop: 7,
                                                paddingBottom: 7,
                                                onTap: () async{
                                                  SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
                                                  String sysId= await _sharedPrefs.getEmpSysId;
                                                  String sTime = DateFormat('dd-MMM-yyyy HH:mm').format(DateTime.parse(data.eTime!)).toString();
                                                  OtRequestData otRequest =  OtRequestData(
                                                      empSysId: sysId,
                                                      attDate: DateTime.parse(data.attDat!).dMY().toString(),
                                                      remark: reasonController.text,
                                                      sTime: sTime
                                                  );
                                                  Navigator.pop(context);
                                                  bool success = await controller.requestOT(data: otRequest);
                                                  if(success) {
                                                    resetData();
                                                    await controller.getOtApprovalList();
                                                  }
                                                }, text: 'Submit'),
                                          )
                                        ],
                                      )
                                  ),
                                );
                              }, text: 'Submit'),
                        )
                      ],
                    ).paddingAll(10),
                  ).paddingOnly(left: 10, right: 10, top: 10, bottom: 5),
                ).paddingOnly(bottom: 9);
              },
            ).paddingOnly(left: 20, right: 20, top: 15, bottom: 15)
            )
        )
    );
  }
}
