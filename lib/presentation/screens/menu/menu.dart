import 'package:etms/app/config/config.dart';
import 'package:etms/app/route/route_name.dart';
import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/data/datasources/request/attendance/attendance_report_data.dart';
import 'package:etms/data/datasources/response/attendance_report/attendance_report_response.dart';
import 'package:etms/presentation/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../app/helpers/shared_preference_helper.dart';
import '../../../data/datasources/request/leave/leave_status_001_data.dart';
import '../../apply_leave/widgets/leave_status_list.dart';
import '../../approval/leave_approval/leave_proposal_list.dart';
import '../../controllers/approval_controller.dart';
import '../../controllers/attendance_controller.dart';
import '../../controllers/leave_controller.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with SingleTickerProviderStateMixin{
  AttendanceController controller = Get.find();
  LeaveController leaveController = Get.find();
  ApprovalController approvalController = Get.find();
  ProfileController profileController = Get.find();
  AttReportSummaryResponse attSummary = AttReportSummaryResponse();
  bool isEmpty=true;
  bool getData = true;
  final RefreshController refreshControllerInbox = RefreshController(initialRefresh: false);
  final RefreshController refreshControllerOutbox = RefreshController(initialRefresh: false);
  late TabController _tabController;
  int tabIndex=0;
  bool supFlag = false;
  bool isLeaveStatusListLoading = true;
  bool hasNotiCount = false;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleSelected);

    attSummary=controller.attSummary.value;
    if(attSummary.empFirstName.toString()!='null'){
      setState(() {
        isEmpty=false;
      });
    }
    getAttReportSummary(DateFormat('MMM yyy').format(DateTime.now()));
  }


  void _handleSelected() {
    setState(() {
      tabIndex=_tabController.index;
    });
  }

  getAttReportSummary(String inputDate) async {
    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
    bool isSupFlag= await _sharedPrefs.getSupFlag;
    setState(() {
      supFlag = isSupFlag;
    });
    await approvalController.getNotiCount();
    int totalCount = 0;
    for(var i=0;i<approvalController.notiCount.value.length;i++){
      totalCount+= approvalController.notiCount[i].count!;
    }
    setState(() {
      hasNotiCount = totalCount!=0;
    });

    DateTime parsedMonth = DateFormat('MMM yyyy').parse(inputDate);
    DateTime startOfMonth = DateTime(parsedMonth.year, parsedMonth.month, 1);
    DateTime endOfMonth = DateTime(parsedMonth.year, parsedMonth.month + 1, 0);

    String sysId= await _sharedPrefs.getEmpSysId;

    AttendanceReportData data = AttendanceReportData(
      unitId: 0,
      empSysId: sysId,
      active: 'All',
      sDate: startOfMonth.dMY(),
      eDate: endOfMonth.dMY(),
      uid: 1
    );
    await controller.getAttReportSummary(data: data);
    if(controller.attSummary.value.empFirstName.toString()!='null'){
      if(mounted){
        isEmpty=false;
        attSummary=controller.attSummary.value;
        setState(() {});
      }
    }
    if(profileController.imageBytes.value.isEmpty){
      profileController.getPhotoLoading.value=true;
      await profileController.getMyPhoto();
      // getPhoto();
    }
    await getLeaveStatusList();
    setState(() {
      isLeaveStatusListLoading = false;
    });

    if(isSupFlag){
      await approvalController.getLeaveProposalList();
    }
  }

  getLeaveStatusList() async{
    DateTime currentDate = DateTime.now();
    DateTime previousDate = DateTime(currentDate.year, currentDate.month - 1, currentDate.day);

    String eDate = currentDate.dMY()!;
    String sDate = previousDate.dMY()!;


    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
    String sysId= await _sharedPrefs.getEmpSysId;
    LeaveStatus001Data leaveStatusData = LeaveStatus001Data(
        empSysId: sysId,
        sdate: sDate,
        edate: eDate
    );

    await leaveController.getLeaveStatusList_001(data: leaveStatusData);
  }


  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
      height: context.height,
      child: Stack(
        alignment: Alignment.center,
        //textDirection: TextDirection.ltr,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Container(
                  height: 200,
                  color: ColorResources.primary800,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          profileController.imageBytes.value.isNotEmpty?
                          GestureDetector(
                            onTap: (){
                              Get.toNamed(RouteName.profile_edit);
                            },
                            child: Container(
                                height:50,
                                width: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: MemoryImage(profileController.imageBytes.value)))
                            ),
                          ):Container(
                              height:50,
                              width: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorResources.white
                              )),
                          SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(isEmpty?'-':"${attSummary.empFirstName} ${attSummary.empLastName}",style: latoBold.copyWith(fontSize: 18,color: ColorResources.text50),),
                              Text(isEmpty?'-':"${attSummary.jobName}",style: latoRegular.copyWith(fontSize: 14,color: ColorResources.text50),),
                            ],
                          ),
                        ],
                      ),
                      if(supFlag)
                        GestureDetector(
                          onTap: (){
                            Get.toNamed(RouteName.approval);
                          },
                          child: Stack(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: ColorResources.primary500,width: 1)
                                  ),
                                  child: Image.asset('assets/images/check.png', height: 20, width: 20,)),
                              hasNotiCount?
                              Positioned(
                                left: 30,
                                child: Icon(Icons.circle, size: 10, color: ColorResources.red,),
                              ):Container(),

                            ],
                          )
                        )
                    ],
                  ).paddingOnly(top: 40,left: 20,right: 20),
                ),
                SizedBox(height: 80,),
                if(!supFlag && isLeaveStatusListLoading==false)
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: [
                        if(leaveController.statusDetailList_001.isEmpty && leaveController.statusFirstList_001.isEmpty && leaveController.statusSecondList_001.isEmpty && leaveController.isStatusList_001Loading.value==false)
                          Center(child: Text('There is no data.')).paddingOnly(top: 30),
                        // :Container(),
                        if(leaveController.statusDetailList_001.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 15,),
                              Text('Reviewed Leave', style: latoSemibold.copyWith(fontSize: 15, color: ColorResources.green),).paddingOnly(left: 10),
                              SizedBox(height: 10,),
                              LeaveStatusList(list: leaveController.statusDetailList_001),
                              SizedBox(height: 20,)
                            ],
                          ),
                        if(leaveController.statusFirstList_001.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 15,),
                              Text('Pending Leave (First Person Approval)', style: latoSemibold.copyWith(fontSize: 15, color: ColorResources.green),).paddingOnly(left: 10),
                              SizedBox(height: 10,),
                              LeaveStatusList(list: leaveController.statusFirstList_001),
                              SizedBox(height: 20,)
                            ],
                          ),
                        if(leaveController.statusSecondList_001.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 15,),
                              Text('Pending Leave (Second Person Approval)', style: latoSemibold.copyWith(fontSize: 15, color: ColorResources.green),).paddingOnly(left: 10),
                              SizedBox(height: 10,),
                              LeaveStatusList(list: leaveController.statusSecondList_001),
                              SizedBox(height: 20,)
                            ],
                          ),
                      ],
                    ).paddingOnly(left: 20,right: 20,bottom: 45),
                  ),
                if(supFlag)
                TabBar(
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
                        Text('Inbox',style: tabIndex==0?
                        latoBold.copyWith(color: ColorResources.primary500):latoRegular.copyWith(color: ColorResources.primary600))
                      // TextStyle(fontFamily: 'Inter',
                      //     fontWeight: tabIndex==0?FontWeight.bold:FontWeight.normal,color:ColorResources.primary500,fontSize: 16),
                    ),

                    Tab(
                      // height: 70,
                      child:
                      Text('Outbox',style: tabIndex==1?
                      latoBold.copyWith(color: ColorResources.primary500):latoRegular.copyWith(color: ColorResources.primary600)),
                    ),
                  ],
                ),
                if(supFlag)
                Expanded(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                        SmartRefresher(
                          controller: refreshControllerInbox,
                          enablePullDown: true,
                          // enablePullUp: !orderController.hasReachMax,
                          onRefresh: () async {
                            await approvalController.getLeaveProposalList();
                            refreshControllerInbox.refreshCompleted();
                          },
                          onLoading: () async {
                            // await orderController.nextPage();
                            refreshControllerInbox.loadComplete();
                          },
                          header: const WaterDropHeader(),
                          child: ListView(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            children: [
                              // leaveController.leaveProposalList.isEmpty
                              //   Center(child: Text('There is no data.')).paddingOnly(top: 30):
                              // :Container(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 15,),
                                  LeaveProposalListView(),
                                  SizedBox(height: 20,)
                                ],
                              ),
                            ],
                          ).paddingOnly(bottom: 45),
                        ).paddingOnly(left: 20,right: 20),
                        SmartRefresher(
                          controller: refreshControllerOutbox,
                          enablePullDown: true,
                          // enablePullUp: !orderController.hasReachMax,
                          onRefresh: () async {
                            await getLeaveStatusList();
                            refreshControllerOutbox.refreshCompleted();
                          },
                          onLoading: () async {
                            // await orderController.nextPage();
                            refreshControllerOutbox.loadComplete();
                          },
                          header: const WaterDropHeader(),
                          child: ListView(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            children: [
                              if(leaveController.statusDetailList_001.isEmpty && leaveController.statusFirstList_001.isEmpty && leaveController.statusSecondList_001.isEmpty && leaveController.isStatusList_001Loading.value==false)
                                Center(child: Text('There is no data.')).paddingOnly(top: 30),
                              // :Container(),
                              if(leaveController.statusDetailList_001.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 15,),
                                    Text('Reviewed Leave', style: latoSemibold.copyWith(fontSize: 15, color: ColorResources.green),).paddingOnly(left: 10),
                                    SizedBox(height: 10,),
                                    LeaveStatusList(list: leaveController.statusDetailList_001),
                                    SizedBox(height: 20,)
                                  ],
                                ),
                              if(leaveController.statusFirstList_001.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 15,),
                                    Text('Pending Leave (First Person Approval)', style: latoSemibold.copyWith(fontSize: 15, color: ColorResources.green),).paddingOnly(left: 10),
                                    SizedBox(height: 10,),
                                    LeaveStatusList(list: leaveController.statusFirstList_001),
                                    SizedBox(height: 20,)
                                  ],
                                ),
                              if(leaveController.statusSecondList_001.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 15,),
                                    Text('Pending Leave (Second Person Approval)', style: latoSemibold.copyWith(fontSize: 15, color: ColorResources.green),).paddingOnly(left: 10),
                                    SizedBox(height: 10,),
                                    LeaveStatusList(list: leaveController.statusSecondList_001),
                                    SizedBox(height: 20,)
                                  ],
                                ),
                            ],
                          ).paddingOnly(bottom: 45),
                        ).paddingOnly(left: 20,right: 20),
                      ],
                    )
                ),
              ],
            ),
          ),
          Positioned(
            top: 100,
            child: SizedBox(
              width: context.width,
              child: Card(
                  elevation: 2,
                  child: Container(
                    // height: 170,
                    decoration: BoxDecoration(
                        color: ColorResources.secondary500,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Column(
                      children: [
                        StreamBuilder(
                          stream: Stream.periodic(Duration(seconds: 1), (i) => DateTime.now()),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              DateTime currentTime = snapshot.data!;
                              String hour = currentTime.hour.toString().padLeft(2, '0');
                              return
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Text("Hello! ${
                                        (int.parse(hour) >= 6 && DateTime.now().hour<12)?'Good Morning':
                                        (int.parse(hour) >= 12 && DateTime.now().hour < 18)?'Good Afternoon': 'Good Evening'
                                    }",style: latoRegular,),
                                    Text(DateFormat('hh:mm a').format(DateTime.now()),style: latoBold.copyWith(color: ColorResources.primary700),)
                                  ],
                                );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                        Text(
                          // "Saturday 23 September 2023",
                          DateFormat('EEEE dd MMMM yyyy').format(DateTime.now()),
                          style: latoRegular.copyWith(fontSize: 16),).paddingOnly(top: 22,bottom: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(isEmpty?'-':attSummary.workedDays.toString()),
                                Text("Present")
                              ],
                            ),
                            Column(
                              children: [
                                Text(isEmpty?'-':attSummary.absDays.toString()),
                                Text("Leave")
                              ],
                            ),
                            Column(
                              children: [
                                Text(isEmpty?'-':
                                (attSummary.pDays!+attSummary.nDays!).toString()
                                ),
                                Text("Absent")
                              ],
                            )
                          ],
                        ),
                      ],
                    ).paddingAll(22),
                  )
              ).paddingOnly(left: 20,right: 20),
            ),
          )
        ],
      ),
    ));
  }
}
