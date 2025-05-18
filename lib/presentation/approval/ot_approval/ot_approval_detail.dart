import 'package:etms/app/config/config.dart';
import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/data/datasources/request/approval/ot_proposal_request.dart';
import 'package:etms/presentation/controllers/approval_controller.dart';
import 'package:etms/presentation/widgets/custom_button.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/config/color_resources.dart';
import '../../../data/datasources/response/approval/ot_approval_list_response.dart';
import '../../widgets/simple_text_form.dart';

class OTApprovalDetailView extends StatefulWidget {
  OTApprovalLevel2Response data;
  String selectedDate;
  OTApprovalDetailView({super.key, required this.data, required this.selectedDate});

  @override
  State<OTApprovalDetailView> createState() => _OTApprovalDetailViewState();
}

class _OTApprovalDetailViewState extends State<OTApprovalDetailView> {
  ApprovalController controller = Get.find();
  TextEditingController _apprHourController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apprHourController.text = widget.data.apprHour.toString()=='null'?'':widget.data.apprHour.toString();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _apprHourController.dispose();
    _reasonController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
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
          // direction: Axis.horizontal,
          children: [
            Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(FeatherIcons.user, color: ColorResources.primary500, size: 18,).paddingOnly(right: 10),
                          Text(widget.data.eMPNAME.toString()),
                        ],
                      ),
                      GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
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
                      Text('Approval OT', style: latoSemibold,).paddingOnly(right: 10),
                      Flexible(child: Text(DateTime.parse(widget.data.attDat.toString()).dMY().toString(), style: latoRegular.copyWith(fontSize: 14),)),
                    ],
                  ).paddingOnly(bottom: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('From', style: latoSemibold,).paddingOnly(right: 10),
                      Flexible(child: Text(DateFormat('h:mm a').format(DateTime.parse(widget.data.oTSTime.toString())), style: latoRegular.copyWith(fontSize: 14) ,)),
                    ],).paddingOnly(bottom: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(child: Text('To', style: latoSemibold,).paddingOnly(right: 10)),
                      Flexible(child: Text(DateFormat('h:mm a').format(DateTime.parse(widget.data.oTETime.toString())), style: latoRegular.copyWith(fontSize: 14) ,)),
                    ],
                  ).paddingOnly(bottom: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('OT Hour', style: latoSemibold,).paddingOnly(right: 10),
                      Flexible(child: Text(widget.data.oTHrs.toString(), style: latoRegular.copyWith(fontSize: 14),)),
                    ],
                  ).paddingOnly(bottom: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Rate', style: latoSemibold,).paddingOnly(right: 10),
                      Flexible(child: Text(widget.data.oTRatCas.toString(), style: latoRegular.copyWith(fontSize: 14),)),
                    ],
                  ).paddingOnly(bottom: 10),
                  Text('Remark', style: latoSemibold,),
                  Text(
                    widget.data.remark.toString()=='null'||widget.data.remark.toString()=='-'?'-':widget.data.remark.toString(),
                    style: latoRegular.copyWith(fontSize: 14),).paddingOnly(bottom: 10),
                  Text('Overtime Approval Hour', style: latoSemibold,),
                  SimpleTextFormField(
                    controller: _apprHourController,
                    hintText: 'approval hour',
                    maxLine: 1,
                    isNumber: true,
                  ).paddingOnly(top: 5, bottom: 10),
                  Text('Why do you Approve/Reject overtime?', style: latoSemibold,).paddingOnly(right: 10),
                  SimpleTextFormField(
                    controller: _reasonController,
                    hintText: 'Reason',
                    maxLine: 5,
                  ).paddingOnly(top: 5, bottom: 10),
                  Center(
                    child: CustomButton(
                        width: context.width*0.9,
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Are you sure approve this OT proposal?',
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
                                        OTProposalRequest request = OTProposalRequest(
                                            sysId: widget.data.sysId.toString(),
                                            attDate: widget.data.attDat.toString(),
                                            otHours: double.parse(_apprHourController.text.toString()),
                                            remark: _reasonController.text.toString(),
                                            sTime: widget.data.oTSTime.toString()
                                        );
                                        await controller.saveOTProposal(data: request, selectedDate: widget.selectedDate);
                                      },
                                    ),
                                  ],
                                );
                              }
                          );
                        }, text: 'Approve'),
                  )
                ],
              ).paddingOnly(left: 13 ,right: 13, bottom: 10),
            )
          ],
        ).paddingOnly(top: 15, bottom: 15),
      ),
    );
  }
}
