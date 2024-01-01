import 'package:etms/app/route/route_name.dart';
import 'package:etms/presentation/apply_leave/leave.dart';
import 'package:etms/presentation/apply_leave/leave_list.dart';
import 'package:etms/presentation/apply_leave/leave_status.dart';
import 'package:etms/presentation/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/config/config.dart';

class ApplyLeavePage extends StatefulWidget {
  const ApplyLeavePage({super.key});

  @override
  State<ApplyLeavePage> createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends State<ApplyLeavePage>with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int tabIndex=0;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleSelected);
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
          // backgroundColor: ColorResources.background,
          backgroundColor: ColorResources.secondary500,
          appBar: MyAppBar(title: 'Leave',
            widget:  GestureDetector(
              onTap: ()=> Get.toNamed(RouteName.leave_calendar),
              child: Text('Leave Calendar',style: latoRegular.copyWith(color: ColorResources.white,
                  decoration: TextDecoration.underline),),
            ),),
          body: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: TabBar(
                  padding: EdgeInsets.only(left: 15),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: ColorResources.primary500,
                  indicatorWeight: 1.5,
                  dividerColor:  Colors.transparent,
                  controller: _tabController,
                  labelColor: ColorResources.primary500,
                  tabs: [
                    Tab(
                      // height: 70,
                      child:
                      Text('Apply Leave',style: tabIndex==0?
                          latoBold:latoRegular.copyWith(color: ColorResources.primary600))
                      // TextStyle(fontFamily: 'Inter',
                      //     fontWeight: tabIndex==0?FontWeight.bold:FontWeight.normal,color:ColorResources.primary500,fontSize: 16),
                    ),

                    Tab(
                      // height: 70,
                      child:
                      Text('Leave List',style: tabIndex==1?
                      latoBold:latoRegular.copyWith(color: ColorResources.primary600)),
                    ),

                    Tab(
                      // height: 70,
                      child:
                      Text('Leave Status',style: tabIndex==2?
                      latoBold:latoRegular.copyWith(color: ColorResources.primary600)),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      LeaveView().paddingOnly(left: 20,right: 20),
                      LeaveListView().paddingOnly(left: 20,right: 20),
                      LeaveStatusView()
                    ],
              )
              )
            ],
          ),
        )
    );
  }
}
