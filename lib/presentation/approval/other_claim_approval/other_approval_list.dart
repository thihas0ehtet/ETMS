import 'dart:convert';
import 'dart:typed_data';
import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/data/datasources/response/claim/other_approval_response.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/config/config.dart';
import '../../controllers/approval_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/overlay_photo.dart';


class OtherApprovalListView extends StatefulWidget {
  const OtherApprovalListView({super.key});

  @override
  State<OtherApprovalListView> createState() => _OtherApprovalListViewState();
}

class _OtherApprovalListViewState extends State<OtherApprovalListView> {
  ApprovalController approvalController = Get.find();
  List<OtherApprovalResponse> list = [];
  DateTime filteredDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async{
    await approvalController.getClaimApprovalList();
    setState(() {
      list = approvalController.claimApprovalList;
    });
  }

  Color generateColor(String text){
    if(text.toLowerCase()=='pending'){
      return ColorResources.yellow;
    }
    else if(text.toLowerCase().contains('reject')){
      return ColorResources.red;
    }
    return ColorResources.green;
  }

  Color generateTextColor(String text){
    if(text.toLowerCase()=='pending'){
      return Colors.black;
    }
    return ColorResources.white;
  }

  @override
  Widget build(BuildContext context) {
    return
      Obx(() =>  approvalController.claimApprovalLoading.value?Center(child: Container(),)
          :list.isEmpty?Center(child: Text('There is no data.')).paddingOnly(top: 30):
      ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index){
          OtherApprovalResponse data = list[index];
          return GestureDetector(
            child: Card(
                color: Colors.white,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(FeatherIcons.user, color: ColorResources.primary500, size: 18,).paddingOnly(right: 10),
                          Text(data.name.toString(), style: latoMedium.copyWith(fontSize: 15),),
                        ],
                      ).paddingOnly(bottom: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(data.groupName.toString(), style: latoSemibold,).paddingOnly(right: 10),
                          Flexible(child: Text(DateTime.parse(data.receiptDate.toString()).dMY().toString(), style: latoRegular.copyWith(fontSize: 14),)),
                        ],).paddingOnly(bottom: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text('Claim Name', style: latoSemibold,).paddingOnly(right: 10)),
                          Flexible(child: Text(data.claimName.toString(), style: latoRegular.copyWith(fontSize: 14),)),
                        ],
                      ).paddingOnly(bottom: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text('Amount', style: latoSemibold,).paddingOnly(right: 10)),
                          Flexible(child: Text(data.amount.toString(), style: latoRegular.copyWith(fontSize: 14),)),
                        ],
                      ).paddingOnly(bottom: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text('Status', style: latoSemibold,).paddingOnly(right: 10)),
                          Flexible(child: Text(data.status.toString(), style: latoRegular.copyWith(fontSize: 14),)),
                        ],
                      ).paddingOnly(bottom: 10),
                      if(data.receiptImg!=null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text('Photo Attachment', style: latoSemibold,).paddingOnly(right: 10)),
                          GestureDetector(
                            onTap: (){
                              Uint8List bytes = base64.decode(data.receiptImg.toString());
                              Navigator.of(context).push(PhotoViewOverlay(imageBytes: bytes));

                            },
                            child: Card(
                              color: ColorResources.secondary500,
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              child: Container(
                                padding: EdgeInsets.all(7),
                                  child: Icon(Icons.cloud_download_outlined, color: ColorResources.black,))
                            ),
                          )
                        ],
                      ).paddingOnly(bottom: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                              'Are you sure reject this claim proposal?',
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
                                              await approvalController.rejectClaim(id: data.id!);
                                              // Navigator.pop(context);
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
                                              'Are you sure approve this claim proposal?',
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
                                              await approvalController.approveClaim(id: data.id!);
                                              // Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                );
                              }, text: 'Approve'),
                        ],
                      ),
                    ],
                  ),
                )
              // .paddingOnly(left: 10, right: 10, top: 10, bottom: 10),
            ),
          );
        },
      )
      );
  }
}
