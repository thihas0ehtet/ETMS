import 'package:etms/app/config/config.dart';
import 'package:etms/data/datasources/request/attendance_report_data.dart';
import 'package:etms/presentation/attendance/widget/check_inout_status.dart';
import 'package:etms/presentation/attendance/widget/check_inout_widget.dart';
import 'package:etms/presentation/controllers/attendance_controller.dart';
import 'package:etms/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app/helpers/shared_preference_helper.dart';
import '../../data/datasources/response/att_report_response.dart';

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReportScreen> {
  DateTime filteredDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  AttendanceController controller = Get.find();
  List<AttReportResponse> attReportList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAttendanceReport(DateFormat('MMM yyy').format(DateTime.now()));
  }

  getAttendanceReport(String inputDate) async {
    // String inputMonth = 'Jan 2023';
    print("INput date $inputDate");
    DateTime parsedMonth = DateFormat('MMM yyyy').parse(inputDate);

    // Get the start and end dates of the month
    DateTime startOfMonth = DateTime(parsedMonth.year, parsedMonth.month, 1);
    DateTime endOfMonth = DateTime(parsedMonth.year, parsedMonth.month + 1, 0);
    print("Start of month is $startOfMonth");
    print("And end is $endOfMonth");


    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
    String sysId= await _sharedPrefs.getEmpSysId;

    AttendanceReportData data = AttendanceReportData(
      unitId: 0,
      empSysId: sysId,
      active: 'All',
      sDate: startOfMonth.toString(),
      eDate: endOfMonth.toString(),
      uid: 1
    );
    await controller.getAttendanceReport(data: data);
    print("$inputDate HELL O THIS IS ${controller.attendanceReportList}");
    print(controller.attendanceReportList[0].dte.toString());
    setState(() {
      attReportList=controller.attendanceReportList;
    });
  }

  Widget statusCard(String text, String count){
    return Card(
      elevation: 1,
      color: Colors.white,
      child: Container(
          padding: EdgeInsets.only(left: 17,right: 17, top: 12, bottom: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(text=='null'||text==''?'-':text).paddingOnly(bottom: 10),
              Text(count=='null'||count==''?'-':count)
            ],
          )
        // .paddingOnly(left: 10,right: 10,top: 5,bottom: 5),
      ),
    );
    return Card(
      elevation: 1,
      color: Colors.white,
      child: Container(
        // width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(text),
            Text(count)
          ],
        )
            .paddingOnly(left: 10,right: 10,top: 5,bottom: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: ColorResources.background,
          appBar: MyAppBar(title: 'Attendance Report'),
          body: SingleChildScrollView(
            child: Column(
              children: [
                FilterWidget(
                    onDateTimeChanged: (DateTime newDate){
                      setState(() {
                        _selectedDate = newDate;
                      });
                    },
                    onFilterConfirm: (){
                      setState(() {
                        filteredDate=_selectedDate;
                      });
                      Navigator.pop(context);
                      getAttendanceReport(DateFormat('MMM yyyy').format(filteredDate).toString());
                    },
                    filteredDateWidget: Text(DateFormat('yyyy / MMMM').format(filteredDate),style: latoRegular,)
                ),
                if(attReportList.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    itemCount: attReportList.length,
                      itemBuilder: (context,index){
                        bool checkInLate = attReportList[index].lATMIN!>0.0;
                        bool checkOutLate = attReportList[index].eRYOFF!>0.0;
                        return GestureDetector(
                          onTap: (){
                            if(!(attReportList[index].sTIME==null || attReportList[index].eTIME==null)) {
                              showDialog(
                              // barrierColor: ColorResources.background,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: ColorResources.background,
                                    content: Container(
                                      // height: 300,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(DateFormat('MMMM dd, yyyy').format(DateTime.parse(attReportList[index].dte.toString())).toString(),style: latoBold,),
                                                CheckInOutStatus(isOnTime: !((attReportList[index].lATMIN!>0.0)|| (attReportList[index].eRYOFF!>0.0)))
                                              ],
                                            ).paddingOnly(bottom: 20),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start  ,
                                              children: [
                                                Expanded(
                                                  child: CheckInOutWidget(
                                                      isCheckIn: true,
                                                      isOnTime: !(attReportList[index].lATMIN!>0.0),
                                                      checkInOutTime:
                                                      attReportList[0].sTIME==null?'-':
                                                      DateFormat('hh:mm a').format(DateTime.parse(attReportList[index].sTIME.toString())).toString()
                                                  ).paddingOnly(right: 10),
                                                ),
                                                Expanded(child:
                                                CheckInOutWidget(
                                                    isCheckIn: false,
                                                    isOnTime: !(attReportList[index].eRYOFF!>0.0),
                                                    checkInOutTime:
                                                    attReportList[0].eTIME==null?'-':
                                                    DateFormat('hh:mm a').format(DateTime.parse(attReportList[index].eTIME.toString())).toString()
                                                )),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                statusCard('LAT', attReportList[0].lATMINTIM.toString()),
                                                statusCard('UTE', attReportList[0].eRYOFFTIM.toString()),
                                                statusCard('OT ', attReportList[0].otHours.toString())
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  );
                                });
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            child: Container(
                              color: ColorResources.white,
                              constraints: BoxConstraints(
                                  maxHeight: 100
                              ),
                              child:Stack(
                                children: [
                                  if(attReportList[index].remarks!=null)
                                  Align(
                                    alignment: Alignment.topRight,
                                    child:
                                    SvgPicture.asset('assets/images/Remark.svg',width: 25,height: 25,
                                                color: ColorResources.primary500,).paddingOnly(right: 25),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          width: 20,
                                          height: 100,
                                          // height: context.height,
                                          decoration: BoxDecoration(
                                            color: !checkInLate&&!checkOutLate?ColorResources.green:ColorResources.red,
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                                          ),
                                          child:

                                          RotatedBox(
                                              quarterTurns: 3,
                                              child: new Text(!checkInLate&&!checkOutLate?'OnTime':'Late', textAlign: TextAlign.center,
                                                  style: latoRegular.copyWith(color: ColorResources.white))
                                          )

                                        // Expanded(child:
                                        // Text(!checkInLate&&!checkOutLate?'OnTime':'Late',
                                        // style: latoRegular.copyWith(color: ColorResources.white),)
                                        // ),
                                      ).paddingOnly(right: 20),
                                      SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // SizedBox(
                                            //   child: Stack(
                                            //     children: [
                                            //       Text(DateFormat('MMMM dd, yyyy').format(DateTime.parse(attReportList[index].dte.toString())).toString(),style: latoBold,),
                                            //       Align(
                                            //         alignment: Alignment.topRight,
                                            //         child:  SvgPicture.asset('assets/images/Remark.svg',width: 22,height: 22,
                                            //           color: ColorResources.black,),
                                            //       )
                                            //     ],
                                            //   ),
                                            // ),
                                            Text(DateFormat('MMMM dd, yyyy').format(DateTime.parse(attReportList[index].dte.toString())).toString(),style: latoBold,)
                                                .paddingOnly(bottom: 20),

                                            // Container(
                                            //   // color:Colors.green,
                                            //   width: context.width-100,
                                            //   child: Row(
                                            //     crossAxisAlignment: CrossAxisAlignment.start,
                                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            //     children: [
                                            //       Text(DateFormat('MMMM dd, yyyy').format(DateTime.parse(attReportList[index].dte.toString())).toString(),style: latoBold,)
                                            //       //
                                            //       ,
                                            //       SvgPicture.asset('assets/images/Remark.svg',width: 22,height: 22,
                                            //         color: ColorResources.black,),
                                            //     ],
                                            //   ).paddingOnly(bottom: 20),
                                            // ),
                                            Row(
                                              children: [
                                                SvgPicture.asset('assets/images/check-in.svg',width: 22,height: 22,
                                                  color: ColorResources.black,).paddingOnly(right: 10),
                                                // Icon(Icons.login, color: ColorResources.black,).paddingOnly(right: 10),
                                                Text(
                                                    attReportList[index].sTIME==null?'-':
                                                    DateFormat('hh:mm a').format(DateTime.parse(attReportList[index].sTIME.toString())).toString()).paddingOnly(right: 20),
                                                SvgPicture.asset('assets/images/check-out.svg',width: 22,height: 22,
                                                  color: ColorResources.black,).paddingOnly(right: 10),
                                                Text(
                                                    attReportList[index].eTIME==null?'-':
                                                    DateFormat('hh:mm a').format(DateTime.parse(attReportList[index].eTIME.toString())).toString()).paddingOnly(right: 20),

                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )
                            ),
                          ).paddingOnly(bottom: 10),
                        );
                      }
                  ),
                )
                    .paddingOnly(top: 20),
              ],
            ).paddingAll(19),
          )
              // .paddingOnly(left: 10, right: 10, top:15, bottom: 15),
        )
    );
  }
}
