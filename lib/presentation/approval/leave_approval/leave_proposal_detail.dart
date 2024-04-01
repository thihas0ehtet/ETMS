import 'dart:convert';
import 'dart:typed_data';
import 'package:etms/app/config/config.dart';
import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/data/datasources/response/approval/leave_proposal_detail.dart';
import 'package:etms/presentation/controllers/approval_controller.dart';
import 'package:etms/presentation/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/helpers/shared_preference_helper.dart';
import '../../../data/datasources/request/approval/leave_propose_request.dart';
import '../../../data/datasources/response/apply_leave/leave_type_response.dart';
import '../../controllers/leave_controller.dart';
import '../../widgets/overlay_photo.dart';

class LeaveProposalDetailView extends StatefulWidget {
  String proposalId;
  LeaveProposalDetailView({super.key, required this.proposalId});

  @override
  State<LeaveProposalDetailView> createState() => _LeaveProposalDetailViewState();
}

class _LeaveProposalDetailViewState extends State<LeaveProposalDetailView> {
  ApprovalController controller = Get.find();
  LeaveController leaveController = Get.find();
  List<String> typeStringList = [''];
  List<LeaveProposalDetailResponse> dataList = [];
  List<LeaveTypeData> leaveTypeList=[];
  double totalDuration = 0;
  List<bool> checkBoxList = [];
  String leaveType = '';
  bool isFileUploadable = false;
  String leaveProposeId = '';
  String leavePhoto = '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async{
    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
    String sysId= await _sharedPrefs.getEmpSysId;

    await controller.getLeaveProposalDetailList(notifyId: sysId, proposalId: widget.proposalId);
    for(var i=0;i<controller.leaveProposalDetailList.length;i++){
      totalDuration += controller.leaveProposalDetailList[i].leaveDuration!;
      checkBoxList.add(false);
    }
    setState(() {
      dataList = controller.leaveProposalDetailList;
      leaveType = dataList[0].leaveTypeName.toString();
    });
    getLeaveTypes();
  }

  getLeaveTypes() async{
    await leaveController.getLeaveTypes();

    setState(() {
      leaveTypeList.addAll(leaveController.leaveTypes);
      typeStringList.addAll(leaveController.leaveTypes.map((element) => element.leaveTypeName.toString()).toList());
    });
    for(var i=0;i<leaveController.leaveTypes.length;i++){
      if(leaveController.leaveTypes[i].leaveTypeName.toString().toLowerCase()==leaveType.toLowerCase()){
        setState(() {
          isFileUploadable = leaveController.leaveTypes[i].fileUploadable!;
        });
        // break;
      }
    }
    if(isFileUploadable){
      await leaveController.getLeavePhoto(id: dataList[0].leaveProposeID.toString());
      setState(() {
        leavePhoto = leaveController.leavePhoto.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return dataList.isEmpty?Container():
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(dataList[0].empFirstName.toString()),
                              Text(dataList[0].empFirstName.toString())
                            ],
                          ),
                          GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    // ColorResources.secondary500:ColorResources.primary50,
                                  color: ColorResources.primary200,
                                  shape: BoxShape.circle
                                ),
                                child: Icon(Icons.close, color: ColorResources.primary800, size: 17,),
                              )
                          )
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
                      Text(dataList[0].remark.toString()==''||dataList[0].remark.toString()=='null'?'-':dataList[0].remark.toString(), style: latoRegular.copyWith(fontSize: 14),),
                    ],
                  ).paddingOnly(left: 13 ,right: 13),
                  Divider(color: Color(0xff475772),).paddingOnly(top: 10),
                  if(isFileUploadable && leavePhoto.isNotEmpty && leavePhoto.toString()!='null')
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(child: Text('Photo Attachment', style: latoSemibold,).paddingOnly(right: 10)),
                            GestureDetector(
                              onTap: (){
                                Uint8List bytes = base64.decode(leavePhoto.split(',').last);
                                Navigator.of(context).push(PhotoViewOverlay(imageBytes: bytes));
                              },
                              child: Card(
                                  color: ColorResources.secondary500,
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  // padding: EdgeInsets.all(10),
                                  child: Container(
                                      padding: EdgeInsets.all(7),
                                      child: Icon(Icons.cloud_download_outlined, color: ColorResources.black,))
                              ),
                            )
                          ],
                        ).paddingOnly(left: 13 ,right: 13),
                        Divider(color: Color(0xff475772),).paddingOnly(top: 10),
                      ],
                    ),
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
                      Center(
                        child: CustomButton(
                            width: context.width*0.9,
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Are you sure approve this leave proposal?',
                                            style: latoSemibold,
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: Text(
                                            'Cancel',
                                            style: latoMedium.copyWith(color: ColorResources.red),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        CupertinoDialogAction(
                                          child: Text(
                                              'Yes', style: latoMedium.copyWith(color: ColorResources.primary600)),
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            List<LeaveProposalDetailRequest> leaveProposalDetailList = [];
                                            for(var i=0;i<controller.leaveProposalDetailList.length;i++){
                                              //status 1 for approve, 2 for reject
                                              if(checkBoxList[i]==true){
                                                leaveProposalDetailList.add(
                                                    LeaveProposalDetailRequest(
                                                        leaveProposeDetailID: dataList[i].leaveProposeDetailID,
                                                        leaveProposeID: dataList[i].leaveProposeID,
                                                        leaveTypeID: dataList[i].leaveTypeID,
                                                        leaveDate: DateFormat('dd-MMM-yyyy').format(DateTime.parse(dataList[i].leaveDate!)),
                                                        leaveDuration: dataList[i].leaveDuration,
                                                        leaveAMPM: dataList[i].leaveAMPM!.startsWith('1')?1:2,
                                                        leaveStatus: 1,
                                                        leaveStatus2: dataList[i].leaveStatus2
                                                    )
                                                );
                                              }else{
                                                leaveProposalDetailList.add(
                                                    LeaveProposalDetailRequest(
                                                        leaveProposeDetailID: dataList[i].leaveProposeDetailID,
                                                        leaveProposeID: dataList[i].leaveProposeID,
                                                        leaveTypeID: dataList[i].leaveTypeID,
                                                        leaveDate: DateFormat('dd-MMM-yyyy').format(DateTime.parse(dataList[i].leaveDate!)),
                                                        leaveDuration: dataList[i].leaveDuration,
                                                        leaveAMPM: dataList[i].leaveAMPM!.startsWith('1')?1:2,
                                                        leaveStatus: 2,
                                                        leaveStatus2: dataList[i].leaveStatus2
                                                    )
                                                );
                                              }
                                            }
                                            double duration = leaveProposalDetailList.length*0.5;
                                            LeaveProposeRequest request = LeaveProposeRequest(
                                                leaveProposeID: dataList[0].leaveProposeID,
                                                empSysID: dataList[0].empSysId,
                                                leaveStartDate: DateFormat('dd-MMM-yyyy').format(DateTime.parse(dataList[0].leaveStartDate!)),
                                                leaveEndDate: DateFormat('dd-MMM-yyyy').format(DateTime.parse(dataList[0].leaveEndDate!)),
                                                duration: duration,
                                                notifiedTo: dataList[0].notifiedTo,
                                                notifiedTo2: dataList[0].notifiedTo2,
                                                leaveProposeDate: DateFormat('dd-MMM-yyyy').format(DateTime.parse(dataList[0].leaveProposeDate!)),
                                                remark: dataList[0].remark,
                                                leaveTypeId: dataList[0].leaveTypeID,
                                                leaveProposalDetail: leaveProposalDetailList
                                            );
                                            await controller.saveLeaveProposal(request);
                                          },
                                        ),
                                      ],
                                    );
                                  }
                              );
                            }, text: 'Approve'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ).paddingOnly(top: 15, bottom: 15),
      ),
    );
  }
}
