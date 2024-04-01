import 'package:etms/presentation/approval/leave_approval/leave_proposal_list.dart';
import 'package:etms/presentation/approval/other_claim_approval/other_approval_list.dart';
import 'package:etms/presentation/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/config/config.dart';
import '../controllers/approval_controller.dart';
import 'compoff_approval/compoff_proposal_list.dart';
import 'ot_approval/ot_approval_list.dart';

class ApprovalPage extends StatefulWidget {
  const ApprovalPage({super.key});

  @override
  State<ApprovalPage> createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage>with SingleTickerProviderStateMixin {
  ApprovalController controller = Get.find();
  late TabController _tabController;
  int tabIndex=0;
  int leaveCount = 0;
  int otCount = 0;
  int claimCount = 0;
  int compOffCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 4, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleSelected);
    getNotiCount();
  }

  getNotiCount(){
    for(var i=0;i<controller.notiCount.length;i++){
      var leaveItem = controller.notiCount.firstWhere((item) => item.type?.toLowerCase() == 'leave');
      var otItem = controller.notiCount.firstWhere((item) => item.type?.toLowerCase() == 'ot');
      var claimItem = controller.notiCount.firstWhere((item) => item.type?.toLowerCase() == 'claim');
      var compOffItem = controller.notiCount.firstWhere((item) => item.type?.toLowerCase() == 'compoff');

      setState(() {
        leaveCount=leaveItem.count!;
        otCount=otItem.count!;
        claimCount=claimItem.count!;
        compOffCount=compOffItem.count!;
      });
    }

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleSelected() {
    setState(() {
      tabIndex=_tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: ColorResources.secondaryBackground,
          // backgroundColor: ColorResources.secondary500,
          appBar: MyAppBar(title: 'Approval'),
          body: Obx(()=>
              Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: TabBar(
                      // padding: EdgeInsets.only(left: 15),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: ColorResources.primary500,
                      indicatorWeight: 1.5,
                      dividerColor:  Colors.transparent,
                      controller: _tabController,
                      labelColor: ColorResources.primary500,
                      isScrollable: true,
                      tabs: [
                        Tab(
                          // height: 70,
                            child:
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Leave Approval',style: tabIndex==0?
                                latoBold.copyWith(color: ColorResources.primary500):latoRegular.copyWith(color: ColorResources.primary600)),
                                if(controller.notiCount.firstWhere((item) => item.type?.toLowerCase() == 'leave').count!>0)
                                  Icon(Icons.circle, color: ColorResources.red, size: 8,).paddingOnly(left: 5)
                              ],
                            )
                        ),

                        Tab(
                          // height: 70,
                            child:
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('OT Approval',style: tabIndex==1?
                                latoBold.copyWith(color: ColorResources.primary500):latoRegular.copyWith(color: ColorResources.primary600)),
                                if(controller.notiCount.firstWhere((item) => item.type?.toLowerCase() == 'ot').count!>0)
                                  Icon(Icons.circle, color: ColorResources.red, size: 8,).paddingOnly(left: 5)
                              ],
                            )

                        ),

                        Tab(
                          // height: 70,
                            child:
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Comp Off Approval',style: tabIndex==2?
                                latoBold.copyWith(color: ColorResources.primary500):latoRegular.copyWith(color: ColorResources.primary600)),
                                if(controller.notiCount.firstWhere((item) => item.type?.toLowerCase() == 'compoff').count!>0)
                                  Icon(Icons.circle, color: ColorResources.red, size: 8,).paddingOnly(left: 5)
                              ],
                            )
                        ),

                        Tab(
                          // height: 70,
                            child:
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Other Claim Approval',style: tabIndex==3?
                                latoBold.copyWith(color: ColorResources.primary500):latoRegular.copyWith(color: ColorResources.primary600)),
                                if(controller.notiCount.firstWhere((item) => item.type?.toLowerCase() == 'claim').count!>0)
                                  Icon(Icons.circle, color: ColorResources.red, size: 8,).paddingOnly(left: 5)
                              ],
                            )
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        children: [
                          LeaveProposalListView().paddingOnly(left: 10,right: 10, top: 10, bottom: 10),
                          OTApprovalListView().paddingOnly(left: 10,right: 10, top: 10, bottom: 10),
                          CompOffProposalListView().paddingOnly(left: 10,right: 10, top: 10, bottom: 10),
                          OtherApprovalListView().paddingOnly(left: 10,right: 10, top: 10, bottom: 10),
                        ],
                      )
                  )
                ],
              )),
        )
    );
  }
}
