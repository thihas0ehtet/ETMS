import 'package:etms/app/config/config.dart';
import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/data/datasources/request/approval/compoff_proposal_request.dart';
import 'package:etms/presentation/controllers/approval_controller.dart';
import 'package:etms/presentation/widgets/custom_button.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/datasources/response/approval/comp_approval_data_response.dart';

class CompOffProposalDetailView extends StatefulWidget {
  CompApprovalDataResponse data;
  CompOffProposalDetailView({super.key, required this.data});

  @override
  State<CompOffProposalDetailView> createState() => _CompOffProposalDetailViewState();
}

class _CompOffProposalDetailViewState extends State<CompOffProposalDetailView> {
  ApprovalController controller = Get.find();
  TextEditingController _apprHourController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _apprHourController.text = widget.data.apprHour.toString();
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
                            Text(widget.data.empName.toString()),
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
                        Text('Comp Off', style: latoSemibold,).paddingOnly(right: 10),
                        Flexible(child: Text(DateTime.parse(widget.data.requestedTime.toString()).dMY().toString(), style: latoRegular.copyWith(fontSize: 14),)),
                      ],
                    ).paddingOnly(bottom: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(child: Text('Worked Date', style: latoSemibold,).paddingOnly(right: 10)),
                        Flexible(child: Text(DateTime.parse(widget.data.attDat.toString()).dMY().toString(), style: latoRegular.copyWith(fontSize: 14),)),
                      ],
                    ).paddingOnly(bottom: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Duration', style: latoSemibold,).paddingOnly(right: 10),
                        Text(widget.data.duration.toString(), style: latoRegular.copyWith(fontSize: 14),),
                      ],
                    ).paddingOnly(bottom: 10),
                    Text('Remark', style: latoSemibold,),
                    Text(
                      widget.data.reason.toString()=='null'||widget.data.reason.toString()=='-'?'-':widget.data.reason.toString(),
                      style: latoRegular.copyWith(fontSize: 14),).paddingOnly(bottom: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomButton(
                            width: context.width/2.5,
                            color: ColorResources.secondary700,
                            onTap: (){
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Are you sure reject this comp off proposal?',
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
                                            CompOffProposalRequest request = CompOffProposalRequest(
                                              reason: widget.data.reason,
                                              duration: widget.data.duration,
                                              status: 2
                                            );
                                            await controller.saveCompOffProposal(data: request, requestId: widget.data.requestID.toString());
                                            await controller.getNotiCount();
                                          },
                                        ),
                                      ],
                                    );
                                  }
                              );
                            }, text: 'Reject'),
                        CustomButton(
                            width: context.width/2.5,
                            onTap: (){
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Are you sure approve this comp off proposal?',
                                            style: latoSemibold,
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: Text(
                                            'Cancel',
                                            style: latoMedium.copyWith(color: ColorResources.primary600),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        CupertinoDialogAction(
                                          child: Text(
                                              'Yes', style: latoMedium.copyWith(color: ColorResources.red)),
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            CompOffProposalRequest request = CompOffProposalRequest(
                                                reason: widget.data.reason,
                                                duration: widget.data.duration,
                                                status: 1
                                            );
                                            await controller.saveCompOffProposal(data: request, requestId: widget.data.requestID.toString());
                                          },
                                        ),
                                      ],
                                    );
                                  }
                              );
                            },
                            text: 'Approve')
                      ],
                    )
                  ],
                ).paddingOnly(left: 13 ,right: 13, bottom: 10),
              )
              // .paddingOnly(left: 13 ,right: 13),
            ],
          )
              .paddingOnly(top: 15, bottom: 15),
        ),
      );
  }
}
