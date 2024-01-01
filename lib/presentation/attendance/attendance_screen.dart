import 'dart:async';
import 'package:dotted_border/dotted_border.dart';
import 'package:etms/app/route/route_name.dart';
import 'package:etms/app/utils/custom_snackbar.dart';
import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/presentation/attendance/widget/check_inout_map.dart';
import 'package:etms/presentation/attendance/widget/check_inout_view.dart';
import 'package:etms/presentation/attendance/widget/check_inout_widget.dart';
import 'package:etms/presentation/attendance/widget/scan_qr.dart';
import 'package:etms/presentation/controllers/attendance_controller.dart';
import 'package:etms/presentation/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app/config/config.dart';
import '../../app/helpers/shared_preference_helper.dart';
import '../../data/datasources/request/attendance_approval_data.dart';
import '../../data/datasources/request/attendance_report_data.dart';
import '../../data/datasources/response/attendance_report/att_report_response.dart';
import '../../data/datasources/response/attendance_report/qr_code_response.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  AttendanceController controller = Get.find();
  double iconPosition = 0;
  bool isSwiped = false;
  final mapController = MapController();
  TextEditingController _reasonController = TextEditingController();
  DateTime? checkInTime;
  DateTime? checkOutTime;
  double lat=0.0;
  double lon=0.0;
  bool allowLocation = false;
  bool allowQR = false;
  List<QRCodeResponse> qrCodeList = [];
  bool isLocationMatched = false;
  List<AttReportResponse> attReportList = [];
  AttReportResponse? currentReport;
  int tappedIndex = -1;
  bool showInOutOption = false;
  String locationName = '';
  bool isCheckIn=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGeneralSetting();
    // getQRCodeList();
    // getLocation();
  }

  getAttendanceReport() async {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday));
    String sDate = startOfWeek.dMY()!;
    String eDate = now.dMY()!;

    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
    String sysId= await _sharedPrefs.getEmpSysId;

    AttendanceReportData data = AttendanceReportData(
        unitId: 0,
        empSysId: sysId,
        active: 'All',
        sDate: sDate,
        eDate: eDate,
        uid: 1
    );
    await controller.getAttendanceReport(data: data);
    print("This is ${controller.attendanceReportList.length}");

    attReportList=controller.attendanceReportList;
    AttReportResponse report = attReportList.firstWhere((entry) {
      String entryDate= DateTime.parse(entry.dte.toString()).dMY()!;
      String currentDate = DateTime.now().dMY()!;
      print("Entry Date is $entryDate and $currentDate");
      return entryDate == currentDate;
    });
    currentReport = report;
    print("Current report is $currentReport and $attReportList}");
    print(currentReport!.sTIME!);
    print(currentReport!.eTIME);

    tappedIndex = -1;
    checkInTime = DateTime.parse(currentReport!.sTIME!);
    checkOutTime = DateTime.parse(currentReport!.eTIME!);

    isCheckIn=currentReport!.sTIME.toString()=='null';
    setState(() {
      // attReportList=controller.attendanceReportList;
      // currentReport =
    });
  }


  getGeneralSetting() async{
    await controller.getGeneralSetting();
    if(controller.availableState.value==AvailableState.both){
      allowLocation = true;
      allowQR = true;
      getQRCodeList();
      getLocationFirstTime();
      showInOutOption=true;
    } else if(controller.availableState.value== AvailableState.location){
      allowLocation=true;
      getLocationFirstTime();
      showInOutOption=true;
    }
    getAttendanceReport();
  }

  getQRCodeList() async{
    await controller.getQRCodeList();
    qrCodeList = controller.qrCodeList;
    // 16.8537713 and 96.1202632

    qrCodeList.add(QRCodeResponse(
        qRID: 1,
        qRCode: "MAHARSWE",
        createdDate: "2024-01-01T00:00:00",
        fromLat: 16.838,
        toLat: 16.839,
        fromLang: 96.129,
        toLang: 96.13
    ));
    qrCodeList.add(QRCodeResponse(
        qRID: 1,
        qRCode: "MAHARSWE",
        createdDate: "2024-01-01T00:00:00",
        fromLat: 16.852,
        toLat: 16.854,
        fromLang: 96.12,
        toLang: 96.121
    ));
    setState(() {});
  }

  getLocationFirstTime() async {
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        lat=position.latitude;
        lon=position.longitude;
      });
    }).catchError((e) {
      debugPrint(e);
    });
    isLocationMatched = checkLocation();
    setState(() {});
    getLocation();
  }

  getLocation() async {
    print("LAt and lon is $lat and $lon");
    Timer.periodic(Duration(seconds: 30), (Timer t) async {
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        lat=position.latitude;
        lon=position.longitude;
        // setState(() => _currentPosition = position);
        // _getAddressFromLatLng(_currentPosition!);
      }).catchError((e) {
        // debugPrint(e.toString());
      });
      isLocationMatched = checkLocation();
      if(mounted){
        setState(() {});
      }

      if (isLocationMatched) {
        print("Success! Current location is within one of the specified locations.");
      } else {
        print("Current location does not match any of the specified locations.");
      }
    });
  }

  bool checkLocation(){
    print("thi is list $qrCodeList");
    for(var location in qrCodeList){
      double fromLat = location.fromLat!;
      double toLat = location.toLat!;
      double fromLang = location.fromLang!;
      double toLang = location.toLang!;
      if (lat >= fromLat &&
          lat<= toLat &&
          lon >= fromLang &&
          lon <= toLang) {
        locationName = location.qRCode!;
        if(mounted){
          setState(() {});
        }
        return true; // Match found
      }
    }
    return false;
  }

  @override
  void dispose(){
    super.dispose();
    _reasonController.dispose();
  }

  List<DateTime> getWeekRange(DateTime date) {
    // Find the date of the first day of the week (Monday)
    DateTime startOfWeek = date.subtract(Duration(days: date.weekday));
    print('Start of week is $startOfWeek');
    print('end of the week is ${DateTime.now()}');

    // Create a list to store the dates of the week
    List<DateTime> weekDays = [];
    for (var i = 0; i < 7; i++) {
      weekDays.add(startOfWeek.add(Duration(days: i)));
    }
    return weekDays;
  }

  applyAttendance() async {
    print("GEt in this appley att");
    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
    String sysId= await _sharedPrefs.getEmpSysId;

    AttendanceApprovalData data = AttendanceApprovalData(
        inLocation: '$lat,$lon',
        empSysId: sysId,
        remarks: _reasonController.text
    );
    print("DATAE IS ${data.toJson()}");
    try{
      await controller.applyAttendance(data: data);
      getAttendanceReport();
    }catch(e){}

  }

  @override
  Widget build(BuildContext context) {
    final weekRange = getWeekRange(DateTime.now());
    // print('All data is ${currentReport!.sTIME!} and then ${currentReport!.eTIME!}');
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorResources.background,
          appBar: MyAppBar(title: 'Attendance',
          widget: GestureDetector(
            onTap: ()=> Get.toNamed(RouteName.attendanceReport),
            child: Text('Attendance Report', style: latoRegular.copyWith(decoration: TextDecoration.underline, decorationColor: ColorResources.white),),
          )),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              if(attReportList.isNotEmpty)
              SizedBox(
                height: 80,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: weekRange.length,
                    itemBuilder: (context,index){
                      return InkWell(
                        onTap: (){
                          if(DateFormat('d').format(DateTime.now())==DateFormat('d').format(weekRange[index])){
                            showInOutOption = true;
                          } else{
                            showInOutOption = false;
                          }
                          tappedIndex = index;
                          checkInTime = attReportList[index].sTIME.toString()=='null'?null:DateTime.parse(attReportList[index].sTIME!);
                          checkOutTime = attReportList[index].eTIME.toString()=='null'?null:DateTime.parse(attReportList[index].eTIME!);
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              border: DateFormat('d').format(DateTime.now())==DateFormat('d').format(weekRange[index])?
                              Border.all(color: ColorResources.border): tappedIndex==index?Border.all(color: ColorResources.border.withOpacity(0.3)):null
                              // Border.all(color: ColorResources.border.withOpacity(0.3))
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(DateFormat('E').format(weekRange[index])),
                              Container(
                                  padding: EdgeInsets.only(left: 22, right: 22),
                                  child: Text(DateFormat('d').format(weekRange[index])))
                            ],
                          ),
                        ).paddingOnly(right: 5),
                      );
                    }),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: CheckInOutWidget(
                        isCheckIn: true,
                        isOnTime: checkInTime!=null,
                        checkInOutTime:
                        checkInTime==null?'--':DateFormat('hh:mm a').format(checkInTime!).toString()
                    ),
                  ),
                  Flexible(
                    child: CheckInOutWidget(
                        isCheckIn: false,
                        isOnTime: checkOutTime!=null,
                        checkInOutTime:
                        checkOutTime==null?'--':DateFormat('hh:mm a').format(checkOutTime!).toString()),
                  ),
                ],
              ).paddingOnly(left: 20, right: 20),

              if(showInOutOption)
              Column(
                children: [

                  // if(checkInTime==null || checkOutTime==null)
                    Column(
                      children: [
                        CheckInOutMapView(lat: lat,lon: lon, isLocationMatch: isLocationMatched ,),
                        if(allowQR)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text('Check IN / OUT with Qr Scan'),
                              SizedBox(height: 20,),
                              GestureDetector(
                                onTap: () async {
                                  if(!isLocationMatched){
                                    'QR scanning is currently unavailable as you are not within the permitted area.'.error();
                                  } else{
                                    print("LOCAITON NAME IS$locationName");
                                    var result =await Get.toNamed(RouteName.qrScan,
                                        arguments: locationName);
                                    print("Result is $result");
                                    if(result==true){
                                      DateTime? currentTime = DateTime.now();
                                      showDialog<String>(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) => AlertDialog(
                                              backgroundColor: ColorResources.white,
                                              surfaceTintColor: ColorResources.white,
                                              content:
                                              CheckInOutView(
                                                currentTime: currentTime,
                                                controller: _reasonController,
                                                // isCheckIn: false,
                                                isCheckIn: isCheckIn,
                                                onConfirm: () {
                                                  debugPrint("Confirm here134");
                                                  applyAttendance();
                                                  Navigator.pop(context, 'Ok');
                                                  // if(isCheckIn){
                                                  //   checkInTime = currentTime;
                                                  // } else{
                                                  //   checkOutTime = currentTime;
                                                  // }
                                                  // setState(() {});
                                                },
                                                onCancel: (){
                                                  Navigator.pop(context, 'Cancel');
                                                  setState(() {
                                                    isSwiped=true;
                                                    iconPosition = context.width-80;
                                                  });
                                                },
                                              )
                                          )
                                      );
                                    }
                                    print('Result 134is $result');
                                  }
                                },
                                child: DottedBorder(
                                    dashPattern: [5],
                                    color: ColorResources.border,
                                    child: Container(
                                      padding: EdgeInsets.only(top: 20, bottom: 20),
                                      color: ColorResources.white,
                                      width: context.width,
                                      child: Column(
                                        children: [
                                          // Icon(Icons.qr_code).paddingOnly(bottom: 5),
                                          SvgPicture.asset('assets/images/read_qr.svg',width: 25,height: 25,
                                            color: ColorResources.primary800,).paddingOnly(bottom: 10),
                                          Text('Please scan QR'),
                                        ],
                                      ),
                                    )
                                ),
                              ),
                              SizedBox(height: 40,),
                            ],
                          ).paddingOnly(left: 20, right: 20),
                      ],
                    ),



                  // if((checkInTime==null || checkOutTime==null) && (lat!=0.0 || lon!=0.0))
                    Align(
                      alignment: Alignment.bottomRight,
                      child:  GestureDetector(
                        //for checkout
                        onHorizontalDragUpdate: (details) {
                          if(!isLocationMatched){
                            'Check in/out is currently unavailable as you are not within the permitted area.'.error();
                          } else{
                            //for checkin
                            if(!isSwiped){
                              if(details.delta.dx>0){
                                setState(() {
                                  iconPosition += details.delta.dx;
                                });
                                if (iconPosition > (context.width-80)/2) {
                                  setState(() {
                                    isSwiped = true;
                                    iconPosition = context.width-80;
                                  });
                                  DateTime? currentTime = DateTime.now();
                                  showDialog<String>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) => AlertDialog(
                                        backgroundColor: ColorResources.white,
                                        surfaceTintColor: ColorResources.white,
                                        content:
                                        CheckInOutView(
                                          currentTime: currentTime,
                                          isCheckIn: true,
                                          onConfirm: () {
                                            Navigator.pop(context, 'Ok');
                                            setState(() {
                                              checkInTime=currentTime;
                                            });
                                          },
                                          onCancel: (){
                                            Navigator.pop(context, 'Cancel');
                                            setState(() {
                                              isSwiped = false;
                                              iconPosition = 0;
                                            });
                                          },
                                          controller: _reasonController,
                                        )
                                    ),
                                  );
                                }
                              }
                            }

                            //for checkout
                            else {
                              if(details.delta.dx<0){
                                setState(() {
                                  iconPosition += details.delta.dx;
                                });
                                if (iconPosition < (context.width-80)/2) {
                                  setState(() {
                                    isSwiped = false;
                                    iconPosition = 0;
                                  });

                                  DateTime? currentTime = DateTime.now();
                                  showDialog<String>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) => AlertDialog(
                                        backgroundColor: ColorResources.white,
                                        surfaceTintColor: ColorResources.white,
                                        content:
                                        CheckInOutView(
                                          currentTime: currentTime,
                                          controller: _reasonController,
                                          isCheckIn: false,
                                          onConfirm: () {
                                            Navigator.pop(context, 'Ok');
                                            setState(() {
                                              checkOutTime=currentTime;
                                            });
                                          },
                                          onCancel: (){
                                            Navigator.pop(context, 'Cancel');
                                            setState(() {
                                              isSwiped=true;
                                              iconPosition = context.width-80;
                                            });
                                          },
                                        )
                                    ),
                                  );
                                }
                              }
                            }
                          }
                        },
                        onHorizontalDragEnd: (details) {
                          if (isSwiped && iconPosition > context.width/2-40) {
                            setState(() {
                              isSwiped = true;
                              iconPosition = context.width-80;
                            });
                          }
                          else if (!isSwiped && iconPosition < context.width/2-40) {
                            setState(() {
                              isSwiped = false;
                              iconPosition = 0;
                            });
                          }
                        },
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: isSwiped?ColorResources.primary800:ColorResources.primary700,
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  gradient: iconPosition>20 && iconPosition!=context.width-80?
                                  LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      isSwiped?ColorResources.primary800:ColorResources.primary100,
                                      isSwiped?ColorResources.primary100:ColorResources.primary800,
                                    ],
                                  ):null
                              ),
                              width: context.width,
                              child: Center(child: Text(isSwiped?'Swipe to check out':'Swipe to check in', textAlign: TextAlign.center,
                                  style: latoRegular.copyWith(color: ColorResources.text50, fontSize: 16))),
                            ).paddingOnly(left: 20,right: 20),
                            Positioned(
                              left: iconPosition,
                              child:Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: ColorResources.white,
                                      borderRadius: BorderRadius.all(Radius.circular(5))
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.only(top: 7, bottom: 7),
                                    child: SvgPicture.asset( isSwiped?'assets/images/swipe-out.svg':'assets/images/swipe-in.svg',
                                      // width: iconPosition>20 && iconPosition!=context.width-80?30:40,height: iconPosition>20 && iconPosition!=context.width-80?30:40,
                                      color: ColorResources.primary800,),
                                  )
                              ).paddingOnly(left: isSwiped?12:25,right: isSwiped?25:12),
                            ),
                          ],
                        ).paddingOnly(bottom: 40),
                      ),
                    )
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}
