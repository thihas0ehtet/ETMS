import 'dart:io';
import 'package:etms/app/route/route_name.dart';
import 'package:etms/presentation/profile/profile_view.dart';
import 'package:etms/presentation/menu/menu.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../app/config/config.dart';
import '../app/helpers/helper.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool selected = false;
  int tabIndex = 0;

  Future<bool> checkLocationPermissionAndService() async {
    // Check if location services are enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return false;
    }

    // Check permission status
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return false;
    }

    // Permissions granted and service enabled
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Are you sure exit application?',
                      style: latoSemibold,
                    ),
                  ],
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text(
                      'Cancel',
                      style:
                          latoMedium.copyWith(color: ColorResources.primary600),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('Yes',
                        style: latoMedium.copyWith(color: ColorResources.red)),
                    onPressed: () {
                      exit(0);
                    },
                  ),
                ],
              );
            });
      },
      child: SafeArea(
          child: Scaffold(
        backgroundColor: ColorResources.secondary500,
        body: Stack(
          children: [
            AnimatedOpacity(
              opacity: selected ? 0.1 : 1,
              duration: const Duration(milliseconds: 100),
              child: Container(
                child: tabIndex == 0
                    ? const MenuScreen()
                    : tabIndex == 1
                        ? const MenuScreen()
                        : const ProfileView(),
              ),
            ),
            Positioned(
              bottom: 60,
              child: Container(
                alignment: Alignment.center,
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: <Widget>[
                    AnimatedPositioned(
                        top: selected ? 10 : 150,
                        left: selected
                            ? MediaQuery.of(context).size.width / 4
                            : MediaQuery.of(context).size.width / 3,
                        right: selected
                            ? MediaQuery.of(context).size.width / 2
                            : MediaQuery.of(context).size.width / 3,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeOutBack,
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              selected = !selected;
                            });
                            if (Platform.isIOS) {
                              await Future.delayed(
                                  const Duration(milliseconds: 200), () {
                                Get.toNamed(RouteName.applyLeave);
                              });
                              return;
                            }

                            var status = await Permission.location.status;
                            if (!status.isGranted) {
                              Helper.checkLocationPermission(context);
                            } else {
                              await Future.delayed(
                                  const Duration(milliseconds: 200), () {
                                Get.toNamed(RouteName.applyLeave);
                              });
                            }
                          },
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                'assets/images/leave.svg',
                                width: 20,
                                height: 20,
                                color: ColorResources.primary500,
                              ),
                              Text(
                                "Leave",
                                style: latoRegular.copyWith(
                                    color: ColorResources.black, fontSize: 14),
                              )
                            ],
                          ),
                        )),
                    AnimatedPositioned(
                        top: selected ? 10 : 150,
                        left: selected
                            ? MediaQuery.of(context).size.width / 2
                            : MediaQuery.of(context).size.width / 3,
                        right: selected
                            ? MediaQuery.of(context).size.width / 4
                            : MediaQuery.of(context).size.width / 3,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeOutBack,
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              selected = !selected;
                            });
                            await Future.delayed(
                                const Duration(milliseconds: 200), () {
                              Get.toNamed(RouteName.claim);
                            });
                          },
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                'assets/images/claim.svg',
                                width: 20,
                                height: 20,
                                color: ColorResources.primary500,
                              ),
                              //Image.asset('assets/images/attendance.svg'),
                              Text(
                                "Claim",
                                style: latoRegular.copyWith(
                                    color: ColorResources.black, fontSize: 14),
                              )
                            ],
                          ),
                        )),
                    AnimatedPositioned(
                        top: selected ? 70 : 150,
                        left: selected
                            ? MediaQuery.of(context).size.width / 5
                            : MediaQuery.of(context).size.width / 3,
                        right: selected
                            ? null
                            : MediaQuery.of(context).size.width / 3,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeOutBack,
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              selected = !selected;
                            });
                            await Future.delayed(
                                const Duration(milliseconds: 200), () {
                              Get.toNamed(RouteName.payslip_period);
                            });
                          },
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                'assets/images/pay-slip.svg',
                                width: 20,
                                height: 20,
                                color: ColorResources.primary500,
                              ),
                              Text(
                                "Pay-Slip",
                                style: latoRegular.copyWith(
                                    color: ColorResources.black, fontSize: 14),
                              )
                            ],
                          ),
                        )),
                    AnimatedPositioned(
                        top: selected ? 70 : 150,
                        left: selected
                            ? null
                            : MediaQuery.of(context).size.width / 3,
                        right: selected
                            ? MediaQuery.of(context).size.width / 5
                            : MediaQuery.of(context).size.width / 3,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeOutBack,
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              selected = !selected;
                            });

                            if (Platform.isIOS) {
                              await Future.delayed(
                                  const Duration(milliseconds: 200), () {
                                Get.toNamed(RouteName.attendanceScreen);
                              });
                              return;
                            }

                            var status = await Permission.location.status;

                            if (!status.isGranted) {
                              await Helper.checkLocationPermission(context);
                              status = await Permission.location.status;
                              if (status.isGranted) {
                                await Future.delayed(
                                    const Duration(milliseconds: 200), () {
                                  Get.toNamed(RouteName.attendanceScreen);
                                });
                              }
                            } else {
                              await Future.delayed(
                                  const Duration(milliseconds: 200), () {
                                Get.toNamed(RouteName.attendanceScreen);
                              });
                            }
                          },
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                'assets/images/attendance.svg',
                                width: 20,
                                height: 20,
                                color: ColorResources.primary500,
                              ),
                              Text(
                                "Attendance",
                                style: latoRegular.copyWith(
                                    color: ColorResources.black, fontSize: 14),
                              )
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Stack(
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
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selected = false;
                            tabIndex = 0;
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.only(left: context.width / 7),
                            child: IntrinsicHeight(
                              child: Column(
                                children: [
                                  Icon(
                                    FeatherIcons.home,
                                    color: tabIndex == 0
                                        ? ColorResources.white
                                        : ColorResources.primary500,
                                    size: 24,
                                  ).paddingOnly(bottom: 4),
                                  Text(
                                    "Home",
                                    style: latoRegular.copyWith(
                                        color: ColorResources.white,
                                        fontSize: 12),
                                  ).paddingOnly(bottom: 7)
                                ],
                              ),
                            )
                            // Icon(FeatherIcons.grid,size: 30,)
                            ),
                      ),
                    ),
                    Positioned(
                      bottom: 27,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            // tabIndex=1;
                            selected = !selected;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 73,
                          width: context.width,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                ColorResources.secondary500
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.55, 0.45],
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(1),
                            decoration: const BoxDecoration(
                                color: ColorResources.primary800,
                                shape: BoxShape.circle),
                            child: Container(
                              margin: const EdgeInsets.all(15),
                              child: SvgPicture.asset(
                                'assets/images/menu.svg',
                                color: selected
                                    ? ColorResources.white
                                    : ColorResources.primary500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selected = false;
                            tabIndex = 2;
                          });
                        },
                        child: Container(
                            margin: EdgeInsets.only(right: context.width / 7),
                            child: IntrinsicHeight(
                              child: Column(
                                children: [
                                  Icon(
                                    FeatherIcons.user,
                                    color: tabIndex == 2
                                        ? ColorResources.white
                                        : ColorResources.primary500,
                                    size: 24,
                                  ).paddingOnly(bottom: 4),
                                  Text(
                                    "Profile",
                                    style: latoRegular.copyWith(
                                        color: ColorResources.white,
                                        fontSize: 12),
                                  ).paddingOnly(bottom: 7)
                                ],
                              ),
                            )),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      )),
    );
  }
}

class HalfCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red // Change this to the desired color
      ..style = PaintingStyle.fill;

    double radius = size.width / 2;
    Offset center = Offset(size.width / 2, size.height / 2);

    // Draw the lower half of the circle in red
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius), 0, 3.14, true, paint);

    // Draw the upper half of the circle in transparent color
    paint.color = Colors.transparent;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 3.14, 3.14,
        true, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
