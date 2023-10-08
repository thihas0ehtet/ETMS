import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:etms/app/route/route_name.dart';
import 'package:etms/presentation/screens/menu/menu.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../app/config/config.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int visit = 0;
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: ColorResources.background,
          body: Stack(
            children: [
              // Expanded(child: Login),
              AnimatedOpacity(
                opacity: selected ? 0.1 : 0.7,
                duration: Duration(milliseconds: 300),
                child: Container(
                  child: visit==1?MenuScreen():
                  Get.arguments,
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
                            onTap: (){
                              setState(() {
                                selected=!selected;
                              });
                              Get.toNamed(RouteName.attendanceReport);
                            },
                            child: Column(
                              children: [
                                SvgPicture.asset('assets/images/attendance.svg',width: 20,height: 20,
                                  color: ColorResources.primary700,),
                                //Image.asset('assets/images/attendance.svg'),
                                Text("Attendance",style: latoRegular.copyWith(color: ColorResources.primary700,fontSize: 14),)
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
                          child:  Column(
                            children: [
                              SvgPicture.asset('assets/images/leave.svg',width: 20,height: 20,
                                color: ColorResources.primary700,),
                              //Image.asset('assets/images/attendance.svg'),
                              Text("Leave",style: latoRegular.copyWith(color: ColorResources.primary700,fontSize: 14),)
                            ],
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
                          child: Column(
                            children: [
                              SvgPicture.asset('assets/images/pay-slip.svg',width: 20,height: 20,
                                color: ColorResources.primary700,),
                              //Image.asset('assets/images/attendance.svg'),
                              Text("Pay-Slip",style: latoRegular.copyWith(color: ColorResources.primary700,fontSize: 14),)
                            ],
                          )
                      ),
                    ],
                  ),
                ),
              ),

              Align(
                // bottom: 10,
              alignment: Alignment.bottomCenter,
                child:
                    // Container(
                    //   width: 100,
                    //   height: 100,
                    //   decoration: BoxDecoration(
                    //       color: Colors.green,
                    //       shape: BoxShape.circle
                    //   ),
                    // ),
               Stack(
                 children: [
                   Align(
                     alignment: Alignment.bottomCenter,
                     child:  Container(
                       height: 70,
                       width: context.width,
                       decoration: BoxDecoration(
                           color: Colors.green,
                           shape: BoxShape.rectangle
                       ),
                     ),
                   ),
                   Positioned(
                     bottom: 20,
                     child: Container(
                       alignment: Alignment.center,
                       height: 100,
                       width: context.width,
                       decoration: BoxDecoration(
                           color: Colors.red,
                           shape: BoxShape.circle
                       ),
                       child: Container(
                         height: 70,
                         width: 70,
                         decoration: BoxDecoration(
                             color: Colors.orange,
                             shape: BoxShape.circle
                         ),
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
