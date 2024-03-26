import 'package:etms/app/config/config.dart';
import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/data/datasources/response/approval/leave_proposal_detail.dart';
import 'package:etms/presentation/widgets/custom_button.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app/config/color_resources.dart';
import '../../app/helpers/shared_preference_helper.dart';
import '../controllers/leave_controller.dart';
import '../widgets/my_app_bar.dart';

class LeaveProposalDetailView extends StatefulWidget {
  const LeaveProposalDetailView({super.key});

  @override
  State<LeaveProposalDetailView> createState() => _LeaveProposalDetailViewState();
}

class _LeaveProposalDetailViewState extends State<LeaveProposalDetailView> {
  LeaveController controller = Get.find();
  List<LeaveProposalDetailResponse> dataList = [];
  double totalDuration = 0;
  List<bool> checkBoxList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async{
    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
    // String sysId= await _sharedPrefs.getEmpSysId;
    String sysId= '2884';

    await controller.getLeaveProposalDetailList(notifyId: sysId, proposalId: Get.arguments.toString());
    for(var i=0;i<controller.leaveProposalDetailList.length;i++){
      totalDuration += controller.leaveProposalDetailList[i].leaveDuration!;
      checkBoxList.add(false);
    }
    setState(() {
      dataList = controller.leaveProposalDetailList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: ColorResources.secondaryBackground,
          appBar: MyAppBar(title: 'Leave Proposal Detail'),
          body: dataList.isEmpty?Container():
          Obx(()=>
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(FeatherIcons.user, color: ColorResources.primary500, size: 18,).paddingOnly(right: 10),
                          Text(dataList[0].empFirstName.toString()),
                          Text(dataList[0].empFirstName.toString())
                        ],
                      ).paddingOnly(bottom: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dataList[0].leaveTypeName.toString(), style: latoSemibold,).paddingOnly(right: 10),
                          Flexible(child: Text(DateTime.parse(dataList[0].leaveDate.toString()).dMY().toString(), style: latoRegular.copyWith(fontSize: 14),)),
                        ],
                      ).paddingOnly(bottom: 10),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('From', style: latoSemibold,).paddingOnly(right: 10),
                          Flexible(child: Text(DateTime.parse(dataList[0].leaveStartDate.toString()).dMY().toString(), style: latoRegular.copyWith(fontSize: 14),)),
                        ],).paddingOnly(bottom: 10),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(child: Text('To', style: latoSemibold,).paddingOnly(right: 10)),
                          Flexible(child: Text(DateTime.parse(dataList[0].leaveEndDate.toString()).dMY().toString(), style: latoRegular.copyWith(fontSize: 14),)),
                        ],
                      ).paddingOnly(bottom: 10),
                      Row(
                        children: [
                          Text('Duration', style: latoSemibold,).paddingOnly(right: 10),
                          Flexible(child: Text(totalDuration.toString(), style: latoRegular.copyWith(fontSize: 14),)),
                        ],
                      ),
                    ],
                  ).paddingOnly(left: 13 ,right: 13),
                  Divider(color: Color(0xff475772),).paddingOnly(top: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Remark', style: latoSemibold,).paddingOnly(right: 10),
                      Text(dataList[0].remark.toString(), style: latoRegular.copyWith(fontSize: 14),),
                    ],
                  ).paddingOnly(left: 13 ,right: 13),
                  Divider(color: Color(0xff475772),).paddingOnly(top: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Please choose approval days', style: latoSemibold,).paddingOnly(left: 13, right: 10),
                      Container(
                        color: ColorResources.primary200,
                        child: Row(
                          children: [
                            SizedBox(
                              width: context.width/4-10,
                              child: Text(' Date', style: latoSemibold, textAlign: TextAlign.left),
                            ).paddingOnly(left: 10),
                            SizedBox(
                              width: context.width/4-10,
                              child: Text(' Day', style: latoSemibold, textAlign: TextAlign.left),
                            ),
                            SizedBox(
                              width: context.width/4-10,
                              child: Text(' Leave Type', style: latoSemibold, textAlign: TextAlign.left),
                            ),
                            Expanded(
                              child: Text('Approve', style: latoSemibold, textAlign: TextAlign.right,),
                            ),
                            SizedBox(width: 10,)
                          ],
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: dataList.length,
                          itemBuilder: (context,index){
                            return Container(
                              color: index%2==0?ColorResources.secondary500:ColorResources.primary50,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: context.width/4-10,
                                    child: Text(DateTime.parse(dataList[0].leaveDate.toString()).dMY().toString(), style: latoRegular.copyWith(fontSize: 12), textAlign: TextAlign.left),
                                  ).paddingOnly(left: 10),
                                  SizedBox(
                                    width: context.width/4-10,
                                    child: Text(DateFormat('EEEE').format(DateTime.parse(dataList[index].leaveDate!)).toString(), style: latoRegular.copyWith(fontSize: 12), textAlign: TextAlign.left),
                                  ),
                                  SizedBox(
                                    width: context.width/4-10,
                                  child: Text(dataList[index].leaveAMPM.toString(), style: latoRegular.copyWith(fontSize: 12), textAlign: TextAlign.left),
                                  ),
                                  Expanded(
                                    child: Checkbox(
                                      value: checkBoxList[index],
                                      activeColor: ColorResources.primary500,
                                      checkColor: ColorResources.white,
                                      side: BorderSide(color: ColorResources.primary500, width: 2),
                                      onChanged: (bool? value){
                                        setState(() {
                                          checkBoxList[index]=value!;
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomButton(
                              width: context.width/2.5,
                              color: ColorResources.secondary700,
                              onTap: ()=>{}, text: 'Reject'),
                          CustomButton(
                              width: context.width/2.5,
                              onTap: ()=>{}, text: 'Approve')
                        ],
                      )

                    ],
                  )
                      // .paddingOnly(left: 13 ,right: 13),
                ],
              )
          ).paddingOnly(top: 15, bottom: 15),
        )
    );
  }
}
