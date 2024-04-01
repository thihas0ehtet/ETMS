import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/data/datasources/response/approval/leave_proposal_response.dart';
import 'package:etms/presentation/approval/leave_approval/leave_proposal_detail.dart';
import 'package:etms/presentation/widgets/custom_button.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/config/config.dart';
import '../../controllers/approval_controller.dart';

class LeaveProposalListView extends StatefulWidget {
  const LeaveProposalListView({super.key});

  @override
  State<LeaveProposalListView> createState() => _LeaveProposalListViewState();
}

class _LeaveProposalListViewState extends State<LeaveProposalListView> {
  ApprovalController leaveController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async{
    await leaveController.getLeaveProposalList();
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
    return Obx(()=>leaveController.leaveProposalList.isEmpty?
    Center(child: Text('There is no data.')).paddingOnly(top: 30):
    ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: leaveController.leaveProposalList.length,
        itemBuilder: (context,index){
          LeaveProposalResponse data = leaveController.leaveProposalList[index];
          return Card(
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
                            Text(data.empFirstName.toString(), style: latoMedium.copyWith(fontSize: 15),),
                            Text(data.empLastName.toString(), style: latoMedium.copyWith(fontSize: 15),)
                          ],
                        ),
                        Flexible(child: Text(DateTime.parse(data.leaveProposeDate.toString()).dMY().toString(), style: latoRegular.copyWith(fontSize: 14),)),
                      ],
                    ).paddingOnly(bottom: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('From', style: latoSemibold,).paddingOnly(right: 10),
                        Flexible(child: Text(DateTime.parse(data.leaveStartDate.toString()).dMY().toString(), style: latoRegular.copyWith(fontSize: 14),)),
                      ],).paddingOnly(bottom: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(child: Text('To', style: latoSemibold,).paddingOnly(right: 10)),
                        Flexible(child: Text(DateTime.parse(data.leaveEndDate.toString()).dMY().toString(), style: latoRegular.copyWith(fontSize: 14),)),
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
                                    return LeaveProposalDetailView(proposalId: data.leaveProposeID.toString(),);
                                  });
                            },
                            text: 'Check')
                      ],
                    ),
                  ],
                ),
              )
            // .paddingOnly(left: 10, right: 10, top: 10, bottom: 10),
          );
        }
        )
    );
  }
}
