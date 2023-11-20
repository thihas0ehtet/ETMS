import 'package:etms/app/route/route_name.dart';
import 'package:etms/presentation/attendance/widget/check_inout_map.dart';
import 'package:etms/presentation/attendance/widget/check_inout_status.dart';
import 'package:etms/presentation/attendance/widget/check_inout_view.dart';
import 'package:etms/presentation/attendance/widget/check_inout_widget.dart';
import 'package:etms/presentation/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app/config/config.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  double iconPosition = 0;
  bool isSwiped = false;
  final mapController = MapController();
  TextEditingController _reasonController = TextEditingController();
  DateTime? checkInTime;
  DateTime? checkOutTime;
  double lat=0.0;
  double lon=0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  getLocation() async {
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
          setState(() {
            lat=position.latitude;
            lon=position.longitude;
          });
      // setState(() => _currentPosition = position);
      // _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  void dispose(){
    super.dispose();
    _reasonController.dispose();
  }

  List<DateTime> getWeekRange(DateTime date) {
    // Find the date of the first day of the week (Monday)
    DateTime startOfWeek = date.subtract(Duration(days: date.weekday - 1));

    // Create a list to store the dates of the week
    List<DateTime> weekDays = [];
    for (var i = 0; i < 7; i++) {
      weekDays.add(startOfWeek.add(Duration(days: i)));
    }
    return weekDays;
  }

  @override
  Widget build(BuildContext context) {
    final weekRange = getWeekRange(DateTime.now());
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorResources.background,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomAppBar(
                    title: 'Attendance',
                    widget:  GestureDetector(
                        onTap: (){
                          Get.toNamed(RouteName.attendanceReport);
                        },
                        child:  Text('Attendance Reports',style: latoRegular.copyWith(color: ColorResources.white,
                            decoration: TextDecoration.underline),)
                    ),
                  ),
                  SizedBox(height: 20,),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: weekRange.length,
                        itemBuilder: (context,index){
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                border: DateFormat('d').format(DateTime.now())==DateFormat('d').format(weekRange[index])?
                                Border.all(color: ColorResources.border):null
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
                          ).paddingOnly(right: 5);
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
                      ).paddingOnly(right: 10),
                      Flexible(
                        child: CheckInOutWidget(
                            isCheckIn: false,
                            isOnTime: checkOutTime!=null,
                            checkInOutTime:
                            checkOutTime==null?'--':DateFormat('hh:mm a').format(checkOutTime!).toString()),
                        // Container(
                        //   width: 170,
                        //   // height: 90,
                        //   padding: EdgeInsets.only(top: 17,bottom: 17),
                        //   decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       borderRadius: BorderRadius.all(Radius.circular(3))
                        //   ),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Row(
                        //         children: [
                        //           SvgPicture.asset('assets/images/check-out.svg',width: 22,height: 22,
                        //             color: ColorResources.black,).paddingOnly(right: 12),
                        //           // Icon(Icons.login, color: ColorResources.primary700,).paddingOnly(right: 12),
                        //           Flexible(child: Text('Check Out', style: latoRegular.copyWith(color: ColorResources.text500, fontSize: 16),))
                        //         ],
                        //       ).paddingOnly(bottom: 15),
                        //       Row(
                        //         children: [
                        //           Text(checkOutTime==null?'--':DateFormat('hh:mm a').format(checkOutTime!),
                        //             style: latoRegular.copyWith(color: ColorResources.text500, fontSize: 16),),
                        //           if(checkOutTime!=null)
                        //             Flexible(child: CheckInOutStatus(isOnTime: true).paddingOnly(left: 10))
                        //         ],
                        //       )
                        //     ],
                        //   ).paddingOnly(left: 15, right: 10),
                        // ),
                      )
                    ],
                  ).paddingOnly(left: 20, right: 20),

                  if(checkInTime==null || checkOutTime==null)
                    CheckInOutMapView(lat: lat,lon: lon,)
                ],
              ),
            ),
            if((checkInTime==null || checkOutTime==null) && (lat!=0.0 || lon!=0.0))
            Align(
              alignment: Alignment.bottomRight,
              child:  GestureDetector(
                //for checkout
                onHorizontalDragUpdate: (details) {
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
                              content:
                              CheckInOutView(
                                currentTime: currentTime,
                                isLate: true,
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
                              content:
                              CheckInOutView(
                                currentTime: currentTime,
                                isEarly: true,
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
                          color: ColorResources.primary800,
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
                      child:SvgPicture.asset( isSwiped?'assets/images/swipe-out.svg':'assets/images/swipe-in.svg',
                          width: iconPosition>20 && iconPosition!=context.width-80?30:40,height: iconPosition>20 && iconPosition!=context.width-80?30:40,
                      color: Colors.white,)
                      // Icon(
                      //   isSwiped?Icons.arrow_back:Icons.arrow_forward,
                      //   size: iconPosition>20 && iconPosition!=context.width-80?30:40,
                      //   color: Colors.white,
                      // )
                          .paddingOnly(left: 20,right: 20),
                    )
                  ],
                ).paddingOnly(bottom: 40),
              ),
            )
          ],
        )
      ),
    );
  }
}
