import 'dart:convert';
import 'dart:typed_data';
import 'package:etms/app/config/config.dart';
import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/data/datasources/request/attendance_report_data.dart';
import 'package:etms/data/datasources/response/attendance_report/attendance_report_response.dart';
import 'package:etms/presentation/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/helpers/shared_preference_helper.dart';
import '../../../data/datasources/request/leave_status_001_data.dart';
import '../../../data/datasources/request/leave_status_data.dart';
import '../../../data/datasources/response/apply_leave/leave_status_response.dart';
import '../../apply_leave/widgets/leave_status_list.dart';
import '../../controllers/attendance_controller.dart';
import '../../controllers/leave_controller.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  AttendanceController controller = Get.find();
  LeaveController leaveController = Get.find();
  ProfileController profileController = Get.find();
  AttReportSummaryResponse attSummary = AttReportSummaryResponse();
  bool isEmpty=true;
  // List<LeaveStatusResponse> statusDetailList = [];
  // List<LeaveStatusResponse> statusFirstList = [];
  // List<LeaveStatusResponse> statusSecondList = [];

  // String photo='';
  // Uint8List? photoBytes;

  @override
  void initState() {
    super.initState();
    attSummary=controller.attSummary.value;
    if(attSummary.empFirstName.toString()!='null'){
      setState(() {
        isEmpty=false;
      });
    }
    // getLeaveStatusList();
    getAttReportSummary(DateFormat('MMM yyy').format(DateTime.now()));
    // getLeaveStatusList(DateFormat('yyyy / MMMM').format(DateTime.now()));
  }

  getAttReportSummary(String inputDate) async {
    DateTime parsedMonth = DateFormat('MMM yyyy').parse(inputDate);
    DateTime startOfMonth = DateTime(parsedMonth.year, parsedMonth.month, 1);
    DateTime endOfMonth = DateTime(parsedMonth.year, parsedMonth.month + 1, 0);
    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
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
      await profileController.getMyPhoto();
      // getPhoto();
    }
    getLeaveStatusList();
    // else{
    //   setProfilePhoto();
    // }
  }

  getLeaveStatusList() async{
    // DateTime currentDate = DateTime.now();
    DateTime currentDate = DateTime(2023, 10, 20);
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

  // getPhoto() async{
  //   await profileController.getMyPhoto();
  //   setProfilePhoto();
  // }

  // setProfilePhoto(){
  //   Uint8List bytes = base64.decode(profileController.photo.value.split(',').last);
  //   setState(() {
  //     photoBytes=bytes;
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now();
    final hour = DateTime.now().hour;
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
                          Container(
                              height:50,
                              width: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: MemoryImage(profileController.imageBytes.value)))
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
                    ],
                  ).paddingOnly(top: 40,left: 20,right: 20),
                ),
                SizedBox(height: 80,),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
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
                  ).paddingOnly(bottom: 80),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Hello! ${
                                (DateTime.now().hour >= 6 && DateTime.now().hour<12)?'Good Morning':
                                (DateTime.now().hour >= 12 && DateTime.now().hour < 18)?'Good Afternoon': 'Good Evening'
                            }",style: latoRegular,),
                            Text(DateFormat('hh:mm a').format(DateTime.now()),style: latoBold.copyWith(color: ColorResources.primary700),)
                          ],
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
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(color: Colors.amber,),
          // )
          //Container(color: Colors.amber,)
        ],
      ),
    ));
  }
}
