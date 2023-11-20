import 'package:etms/app/config/color_resources.dart';
import 'package:etms/app/config/config.dart';
import 'package:etms/app/route/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../app/helpers/shared_preference_helper.dart';
import '../../controllers/auth_controller.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height,
      child: Stack(
        alignment: Alignment.center,
        //textDirection: TextDirection.ltr,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 200,
              color: ColorResources.primary800,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle
                        ),
                      ).paddingOnly(right: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Ami Myo",style: latoBold.copyWith(fontSize: 18,color: ColorResources.text50),),
                          Text("Content Writer",style: latoRegular.copyWith(fontSize: 14,color: ColorResources.text50),),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                      // AuthController authController = Get.find();
                      // SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
                      // authController.companyCode.value="";
                      // _sharedPrefs.saveCompanyCode("");
                      Get.toNamed(RouteName.login);
                    },
                    child: SvgPicture.asset('assets/images/bell.svg',color: ColorResources.text50,width: 22,),
                  )

                ],
              ).paddingOnly(top: 40,left: 20,right: 20),
            ),
          ),
          Positioned(
            top: 100,
            child: SizedBox(
              width: context.width,
              child: Card(
                  elevation: 2,
                  child: Container(
                    height: 170,
                    decoration: BoxDecoration(
                        color: ColorResources.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Hello, Morning",style: latoRegular,),
                            Text("11:49 PM",style: latoBold.copyWith(color: ColorResources.primary700),)
                          ],
                        ),
                        Text("Saturday 23 September 2023", style: latoRegular.copyWith(fontSize: 16),).paddingOnly(top: 22,bottom: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text("23"),
                                Text("Attendance")
                              ],
                            ),
                            Column(
                              children: [
                                Text("5"),
                                Text("Late")
                              ],
                            ),
                            Column(
                              children: [
                                Text("4"),
                                Text("OT")
                              ],
                            )
                          ],
                        )
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
    );
  }
}
