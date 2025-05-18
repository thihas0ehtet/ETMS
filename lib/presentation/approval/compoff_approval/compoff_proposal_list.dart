import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/presentation/approval/compoff_approval/compoff_proposal_detail.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/config/config.dart';
import '../../../data/datasources/response/approval/comp_approval_data_response.dart';
import '../../controllers/approval_controller.dart';
import '../../widgets/custom_button.dart';

class CompOffProposalListView extends StatefulWidget {
  const CompOffProposalListView({super.key});

  @override
  State<CompOffProposalListView> createState() => _CompOffProposalListViewState();
}

class _CompOffProposalListViewState extends State<CompOffProposalListView> {
  ApprovalController approvalController = Get.find();
  DateTime filteredDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async{
    await approvalController.getCompOffApprovalList();
  }

  @override
  Widget build(BuildContext context) {
    return
      Obx(() =>  approvalController.compOffRequestListLoading.value?Center(child: Container(),)
          :approvalController.compOffApprovalList.isEmpty?Center(child: Text('There is no data.')).paddingOnly(top: 30):
      ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: approvalController.compOffApprovalList.length,
        itemBuilder: (context, index){
          CompApprovalDataResponse data = approvalController.compOffApprovalList[index];
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(FeatherIcons.user, color: ColorResources.primary500, size: 18,).paddingOnly(right: 10),
                              Text(data.empName.toString(), style: latoMedium.copyWith(fontSize: 15),),
                            ],
                          ),
                          Flexible(child: Text(DateTime.parse(data.requestedTime.toString()).dMY().toString(), style: latoRegular.copyWith(fontSize: 14),)),
                        ],
                      ).paddingOnly(bottom: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(child: Text('Worked Date', style: latoSemibold,).paddingOnly(right: 10)),
                          Flexible(child: Text(DateTime.parse(data.attDat.toString()).dMY().toString(), style: latoRegular.copyWith(fontSize: 14),)),
                        ],
                      ).paddingOnly(bottom: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text('Duration', style: latoSemibold,).paddingOnly(right: 10),
                              Text(data.duration.toString(), style: latoRegular.copyWith(fontSize: 14),),
                            ],
                          ),
                          CustomButton(
                              width: 100,
                              paddingTop: 7,
                              paddingBottom: 7,
                              onTap: (){
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: ColorResources.white,
                                    context: context,
                                    elevation: 10,
                                    useSafeArea: true,
                                    builder: (BuildContext context){
                                      return CompOffProposalDetailView(data: data,);
                                    });
                              },
                              text: 'Check')
                        ],
                      ),
                    ],
                  ),
                )
              // .paddingOnly(left: 10, right: 10, top: 10, bottom: 10),
            ),
          );
        },
      ));
  }
}
