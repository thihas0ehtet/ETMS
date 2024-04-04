import 'package:dotted_border/dotted_border.dart';
import 'package:etms/app/route/route_name.dart';
import 'package:etms/app/utils/custom_snackbar.dart';
import 'package:etms/app/utils/dateTime_format.dart';
import 'package:etms/presentation/attendance/widget/check_inout_map.dart';
import 'package:etms/presentation/attendance/widget/check_inout_view.dart';
import 'package:etms/presentation/attendance/widget/check_inout_widget.dart';
import 'package:etms/presentation/controllers/attendance_controller.dart';
import 'package:etms/presentation/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app/config/config.dart';
import '../../app/helpers/shared_preference_helper.dart';
import '../../data/datasources/request/attendance/attendance_approval_data.dart';
import '../../data/datasources/request/attendance/attendance_report_data.dart';
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
  bool showError = false;
  bool finishLoading = false;
  bool isCheckInOnTime = false;
  bool isCheckOutOnTime = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGeneralSetting();
  }

  getAttendanceReport() async {
    setState(() {});
    DateTime now = DateTime.now();

    DateTime startDate = now.subtract(Duration(days: 6));
    // print('starttt daayyy is ${startDate.dMY()}');

    // DateTime startOfWeek = now.subtract(Duration(days: now.weekday));
    String sDate = startDate.dMY()!;
    // String sDate = startOfWeek.dMY()!;
    String eDate = now.dMY()!;

    print("Sdateeee is $sDate and eDate is $eDate");
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
    await controller.getWeeklyAttendanceReport(data: data);
    attReportList=controller.weeklyAttendanceList;
    print("Look hereeeee $attReportList and $sDate and $eDate");
    AttReportResponse report = attReportList.firstWhere((entry) {
      String entryDate= DateTime.parse(entry.dte.toString()).dMY()!;
      String currentDate = DateTime.now().dMY()!;
      return entryDate == currentDate;
    });
    currentReport = report;

    tappedIndex = -1;
    if(currentReport!.sTIME!=null){
      checkInTime = DateTime.parse(currentReport!.sTIME!);
    }
    if(currentReport!.eTIME!=null){
      checkOutTime = DateTime.parse(currentReport!.eTIME!);
    }

    isCheckIn=currentReport!.sTIME.toString()=='null';
    isSwiped=!isCheckIn;
    if(!isCheckIn){
      iconPosition = context.width-80;
    }
    setOnTimeValue(-1);
    finishLoading=true;
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
      await getQRCodeList();
      await getLocationFirstTime();
      showInOutOption=true;
    }else if(controller.availableState.value== AvailableState.location){
      allowLocation=true;
      await getQRCodeList();
      await getLocationFirstTime();
      showInOutOption=true;
    }else if(controller.availableState.value== AvailableState.qr){
      allowQR = true;
      await getQRCodeList();
      showInOutOption=true;
    }
    await getAttendanceReport();
  }

  getQRCodeList() async{
    await controller.getQRCodeList();
    qrCodeList = controller.qrCodeList;
    setState(() {});
  }

  getLocationFirstTime() async {
    await EasyLoading.show();
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
    EasyLoading.dismiss();
    setState(() {});
    getLocation();
  }

  getLocation() async {
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        lat=position.latitude;
        lon=position.longitude;
      }).catchError((e) {
      });
      isLocationMatched = checkLocation();
      if(mounted){
        setState(() {});
      }
  }

  bool checkLocation(){
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
    DateTime startDate = DateTime.now().subtract(Duration(days: 6));
    // DateTime startOfWeek = date.subtract(Duration(days: date.weekday));
    // Create a list to store the dates of the week
    List<DateTime> weekDays = [];
    for (var i = 0; i < 7; i++) {
      weekDays.add(startDate.add(Duration(days: i)));
    }
    return weekDays;
  }

  applyAttendance() async {
    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
    String sysId= await _sharedPrefs.getEmpSysId;

    AttendanceApprovalData data = AttendanceApprovalData(
        inLocation: '$lat,$lon',
        empSysId: sysId,
        remarks: _reasonController.text
    );
    try{
      await controller.applyAttendance(data: data);
      getAttendanceReport();
      _reasonController.clear();
    }catch(e){}
  }

  setOnTimeValue(int index){
    if(index==-1){
      isCheckInOnTime=currentReport==null?false:currentReport!.lATMIN==null?false:!( currentReport!.lATMIN!>0.0);
      isCheckOutOnTime=currentReport==null?false:currentReport!.eRYOFF==null?false:!(currentReport!.eRYOFF!>0.0);
    } else{
      isCheckInOnTime = attReportList[index].lATMIN==null?false:!(attReportList[index].lATMIN!>0.0);
      isCheckOutOnTime = attReportList[index].eRYOFF==null?false:!(attReportList[index].eRYOFF!>0.0);
    }
    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    final weekRange = getWeekRange(DateTime.now());
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorResources.background,
          appBar: MyAppBar(title: 'Attendance',
          widget: GestureDetector(
            onTap: ()=> Get.toNamed(RouteName.attendanceReport),
            child:
            Row(
              children: [
                Text('Attendance Report', style: latoRegular.copyWith(decoration: TextDecoration.underline, decorationColor: ColorResources.white, color: ColorResources.white ),
                ).paddingOnly(right: 10),
                SvgPicture.asset('assets/images/report.svg',width: 16,height: 16,
                  color: ColorResources.white,)
              ],
            ),
          )
          ),
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
                            tappedIndex = -1;
                          } else{
                            showInOutOption = false;
                            tappedIndex = index;
                          }
                          checkInTime = attReportList[index].sTIME.toString()=='null'?null:DateTime.parse(attReportList[index].sTIME!);
                          checkOutTime = attReportList[index].eTIME.toString()=='null'?null:DateTime.parse(attReportList[index].eTIME!);
                          setOnTimeValue(tappedIndex);
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
                        isOnTime: isCheckInOnTime,
                        checkInOutTime:
                        checkInTime==null?'--':DateFormat('hh:mm a').format(checkInTime!).toString()
                    ),
                  ),
                  SizedBox(width: 7,),
                  Flexible(
                    child: CheckInOutWidget(
                        isCheckIn: false,
                        isOnTime: isCheckOutOnTime,
                        checkInOutTime:
                        checkOutTime==null?'--':DateFormat('hh:mm a').format(checkOutTime!).toString()),
                  ),
                ],
              ).paddingOnly(left: 20, right: 20),

              if(showInOutOption)
              Column(
                children: [

                  if((checkInTime==null || checkOutTime==null) && finishLoading)
                    Column(
                      children: [
                        if(allowLocation)
                        CheckInOutMapView(lat: lat,lon: lon, isLocationMatch: isLocationMatched ,),
                        if(allowQR)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20,),
                              GestureDetector(
                                onTap: () async {
                                  if(!isLocationMatched && allowLocation){
                                    'QR scanning is currently unavailable as you are not within the permitted area.'.error();
                                  } else{
                                    var result =await Get.toNamed(RouteName.qrScan,
                                        arguments: locationName);
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
                                                  applyAttendance();
                                                  Navigator.pop(context, 'Ok');
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
                                          SvgPicture.asset('assets/images/read_qr.svg',width: 25,height: 25,
                                            color: ColorResources.primary800,).paddingOnly(bottom: 10),
                                          Text('Please scan QR'),
                                        ],
                                      ),
                                    )
                                ),
                              ),
                              // SizedBox(height: 40,),
                            ],
                          ).paddingOnly(left: 20, right: 20),
                      ],
                    ),

                  if((checkInTime==null || checkOutTime==null) && (lat!=0.0 || lon!=0.0) && finishLoading)
                    // if(finishLoading)
                    Align(
                      alignment: Alignment.bottomRight,
                      child:  GestureDetector(
                        //for checkout
                        onHorizontalDragStart: (details){
                          if(!isLocationMatched){
                            setState(() {
                              showError=true;
                            });
                            'Check in/out is currently unavailable as you are not within the permitted area.'.error();
                          }
                        },
                        onHorizontalDragUpdate: (details) {
                          if(isLocationMatched){
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
                                            applyAttendance();
                                            Navigator.pop(context, 'Ok');
                                            // setState(() {
                                            //   checkInTime=currentTime;
                                            // });
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
                                            applyAttendance();
                                            // setState(() {
                                            //   checkOutTime=currentTime;
                                            // });
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
                                  color: finishLoading==false?ColorResources.primary700.withOpacity(0.4):isSwiped?ColorResources.primary800:ColorResources.primary700,
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
                                      color: ColorResources.primary800,),
                                  )
                              ).paddingOnly(left: isSwiped?12:25,right: isSwiped?25:12),
                            ),
                          ],
                        ).paddingOnly(bottom: 40, top: 20),
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
