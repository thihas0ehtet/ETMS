import 'package:etms/app/route/route_name.dart';
import 'package:etms/app/utils/app_utils.dart';
import 'package:etms/presentation/profile/profile_view.dart';
import 'package:etms/presentation/screens/menu/menu.dart';
import 'package:etms/presentation/test/basic_examle.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../app/config/config.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool selected = false;
  int tabIndex=0;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          // backgroundColor: Color(0xff161616).withOpacity(0.7),
          // backgroundColor: selected?Color(0xff161616).withOpacity(0.7):ColorResources.white,
          backgroundColor: ColorResources.secondary500,
          // backgroundColor: ColorResources.background,
          body: Stack(
            children: [
              // Expanded(child: Login),
              AnimatedOpacity(
                opacity: selected ? 0.1 : 1,
                duration: Duration(milliseconds: 300),
                child: Container(
                  child: tabIndex==0?MenuScreen():
                  tabIndex==1?MenuScreen():
                  ProfileView(),
                ),),
              Positioned(
                bottom: 60,
                child: Container(
                  // color: Colors.amber,
                  alignment: Alignment.center,
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: <Widget>[
                      AnimatedPositioned(
                        // width: selected ? 100.0 : 0.0,
                        //   height: selected ? 200.0 : 0.0,
                        //   // top: selected ? 200.0 : 0.0,
                        //   top: selected? 120:0,
                          top:selected?10:150,
                          // bottom: 150,
                          left:  MediaQuery.of(context).size.width/3,
                          right: MediaQuery.of(context).size.width/3,
                          // left: selected?120:130,

                          // bottom: 20,
                          // left: 100,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOutBack,
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                selected=!selected;
                              });

                              // final hasPermission = await _handleLocationPermission();
                              // if (!hasPermission) return;
                              // await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
                              //     .then((Position position) {
                              //   print("THIS IS POsitiosn and $position");
                              //   // setState(() => _currentPosition = position);
                              //   // _getAddressFromLatLng(_currentPosition!);
                              //   Get.toNamed(RouteName.attendanceScreen);
                              // }).catchError((e) {
                              //   debugPrint(e);
                              // });



                              var status = await Permission.location.status;
                              print("Status is $status");
                              if (!status.isGranted) {
                                AppUtils.checkLocationPermission(context);
                              }
                              else{
                                await Future.delayed(Duration(milliseconds: 200),(){
                                  Get.toNamed(RouteName.attendanceScreen);
                                });
                                // await Geolocator.getCurrentPosition(
                                //     desiredAccuracy: LocationAccuracy.high)
                                //     .then((Position position) {
                                //   Get.toNamed(RouteName.attendanceScreen);
                                //   // setState(() => _currentPosition = position);
                                //   // _getAddressFromLatLng(_currentPosition!);
                                // }).catchError((e) {
                                //   debugPrint(e);
                                // });
                              }


                              // await Geolocator.getCurrentPosition(
                              //     desiredAccuracy: LocationAccuracy.high)
                              //     .then((Position position) {
                              //       print("THIS IS POsitiosn and $position");
                              //   // setState(() => _currentPosition = position);
                              //   // _getAddressFromLatLng(_currentPosition!);
                              // }).catchError((e) {
                              //   debugPrint(e);
                              // });
                            },
                            child: Column(
                              children: [
                                SvgPicture.asset('assets/images/attendance.svg',width: 20,height: 20,
                                  color: ColorResources.primary500,),
                                //Image.asset('assets/images/attendance.svg'),
                                Text("Attendance",style: latoRegular.copyWith(color: ColorResources.black,fontSize: 14),)
                              ],
                            ),
                          )
                      ),
                      AnimatedPositioned(
                          top:selected?70:150,
                          left: selected?MediaQuery.of(context).size.width/5:MediaQuery.of(context).size.width/3,
                          right: selected?null:MediaQuery.of(context).size.width/3,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOutBack,
                          child:  GestureDetector(
                            onTap: () async {
                              setState(() {
                                selected=!selected;
                              });
                              await Future.delayed(Duration(milliseconds: 200),(){
                                Get.toNamed(RouteName.applyLeave);
                              });
                            },
                            child: Column(
                              children: [
                                SvgPicture.asset('assets/images/leave.svg',width: 20,height: 20,
                                  color: ColorResources.primary500,),
                                Text("Leave",style: latoRegular.copyWith(color: ColorResources.black,fontSize: 14),)
                              ],
                            ),
                          )
                      ),
                      AnimatedPositioned(
                        // height: selected ? 200.0 : 0.0,
                        // top: selected? 150:0,
                          top:selected?70:150,
                          // bottom: selected? 90:null,
                          left: selected?null:MediaQuery.of(context).size.width/3,
                          right: selected?MediaQuery.of(context).size.width/5:MediaQuery.of(context).size.width/3,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOutBack,
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                selected=!selected;
                              });
                              await Future.delayed(Duration(milliseconds: 200),(){
                                Get.toNamed(RouteName.payslip_period);
                              });
                            },
                            child: Column(
                              children: [
                                SvgPicture.asset('assets/images/pay-slip.svg',width: 20,height: 20,
                                  color: ColorResources.primary500,),
                                //Image.asset('assets/images/attendance.svg'),
                                Text("Pay-Slip",style: latoRegular.copyWith(color: ColorResources.black,fontSize: 14),)
                              ],
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              ),

              Align(
                  alignment: Alignment.bottomCenter,
                  child:
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 60,
                          width: context.width,
                          decoration: BoxDecoration(
                            color: ColorResources.primary800,
                            shape: BoxShape.rectangle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              selected=false;
                              tabIndex=0;
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.only(left: context.width/7),
                              child: IntrinsicHeight(
                                child: Column(
                                  children: [
                                    Icon(FeatherIcons.home, color: tabIndex==0?ColorResources.white:ColorResources.primary500,size: 24,).paddingOnly(bottom: 4),
                                    Text("Home",style: latoRegular.copyWith(color: ColorResources.white, fontSize: 12),).paddingOnly(bottom: 7)
                                  ],
                                ),
                              )
                            // Icon(FeatherIcons.grid,size: 30,)
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              tabIndex=1;
                              selected=!selected;
                            });
                          },
                          child: Container(
                              alignment: Alignment.center,
                              height: 80,
                              width: context.width,
                              decoration: BoxDecoration(
                                // backgroundBlendMode: BlendMode.colorDodge,
                                color: ColorResources.secondary500,
                                // color: selected? Color(0xff161616).withOpacity(0.7):ColorResources.white,
                                // // color: ColorResources.white,
                                shape: BoxShape.circle,
                              ),
                              child:
                              Container(
                                height: 60,
                                width: 60,
                                // width: context.width,
                                decoration: BoxDecoration(
                                  // color: Colors.white,
                                  color: selected?ColorResources.primary500:Colors.transparent,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child:
                                Container(
                                    margin: EdgeInsets.all(1),
                                    // height: selected?26:24,
                                    // width: selected?26:24,

                                    decoration: BoxDecoration(
                                        color: ColorResources.primary800,
                                        shape: BoxShape.circle
                                    ),
                                    child:
                                    Container(
                                      margin: EdgeInsets.all(15),
                                      // height: 10,
                                      // width: 10,
                                      child: SvgPicture.asset('assets/images/menu.svg',
                                        color: ColorResources.primary500,),
                                    ),
                                    // Icon(FeatherIcons.grid,size: selected?26:24, color: ColorResources.primary500,)
                                ),
                              )
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              selected=false;
                              tabIndex=2;
                            });
                          },
                          child: Container(
                              margin: EdgeInsets.only(right: context.width/7),
                              // padding: EdgeInsets.only(right: 20),
                              // margin: EdgeInsets.all(1),
                              child: IntrinsicHeight(
                                child: Column(
                                  children: [
                                    Icon(FeatherIcons.user,color: tabIndex==2?ColorResources.white:ColorResources.primary500, size: 24,).paddingOnly(bottom: 4),
                                    Text("Profile",style: latoRegular.copyWith(color: ColorResources.white, fontSize: 12),).paddingOnly(bottom: 7)
                                  ],
                                ),
                              )
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child:
              //   BottomBarInspiredOutside(
              //     items: items,
              //     titleStyle: latoRegular,
              //     backgroundColor: Colors.white,
              //     color: ColorResources.primary700,
              //     colorSelected: ColorResources.primary700,
              //     indexSelected: visit,
              //     boxShadow: [BoxShadow(color: Colors.red),BoxShadow(color: Colors.orange)],
              //     // elevation: 3,
              //     onTap: (int index) => setState(() {
              //       visit = index;
              //       // if(index==0){
              //       //   selected=false;
              //       //   // Get.toNamed(RouteName.menu);
              //       // }
              //       // else if(index==1){
              //       //   selected=!selected;
              //       // }
              //       // else{
              //       //   selected=false;
              //       // }
              //       switch(index){
              //         case 0: selected=false;
              //         case 1: selected=!selected;
              //         case 2: selected=false;
              //       }
              //
              //       // switch (index){
              //       //   case 1:  ref.read(tabIndex.notifier).state = 1;
              //       //   context.goNamed(RouteNames.addBlog); break;
              //       //   case 2: ref.read(tabIndex.notifier).state = 2;
              //       //   context.goNamed(RouteNames.account);break;
              //       //   default: ref.read(tabIndex.notifier).state = 0;
              //       //   context.goNamed(RouteNames.viewBlog); break;
              //       // }
              //     }),
              //     chipStyle: ChipStyle(convexBridge: false,
              //         color: Colors.red,
              //         background:ColorResources.white,notchSmoothness: NotchSmoothness.sharpEdge),
              //     itemStyle: ItemStyle.circle,
              //     animated: true,
              //   ),
              // ),
            ],
          ),
        ));
  }
}

List<TabItem> items = const [
  TabItem(
      icon: FeatherIcons.home,
      title: 'Home'
  ),
  TabItem(
      icon: FeatherIcons.grid,
      title: 'All'
  ),
  TabItem(
      icon: FeatherIcons.user,
      title: 'Profile'
  ),
];
