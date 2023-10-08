import 'package:etms/app/config/color_resources.dart';
import 'package:etms/app/config/config.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReportScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: ColorResources.background,
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: ()=>Get.back(),
                        child: SvgPicture.asset('assets/images/back.svg',width: 20,height: 20,
                          color: ColorResources.black,).paddingOnly(right: 10),
                      ),
                      // IconButton(
                      //     onPressed: ()=> Get.back(),
                      //     icon:  Icon(Icons.arrow_back_ios, color: ColorResources.black,size: 17,)),
                      Text("Attendance Report", style: latoSemibold.copyWith(fontWeight: FontWeight.w500),)
                    ],
                  ),
                  Icon(FeatherIcons.sliders, color: ColorResources.black,)
                ],
              ).paddingOnly(bottom: 20),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  itemCount: 10,
                    itemBuilder: (context,index){
                      return ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: Container(
                          color: ColorResources.white,
                          constraints: BoxConstraints(
                              maxHeight: 100
                          ),
                          // decoration: BoxDecoration(
                          //     color: ColorResources.white,
                          //     borderRadius: BorderRadius.all(Radius.circular(8))
                          // ),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                // height: context.height,
                                color: ColorResources.primary700,
                              ).paddingOnly(right: 20),
                              SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("September 16, 2023",style: latoBold,).paddingOnly(bottom: 20),
                                    Row(
                                      children: [
                                        Icon(Icons.login, color: ColorResources.black,).paddingOnly(right: 10),
                                        Text("9:00 AM").paddingOnly(right: 20),
                                        Icon(Icons.logout, color: ColorResources.black,).paddingOnly(right: 10),
                                        Text("5:30 PM")
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ).paddingOnly(bottom: 10);
                    }
                ),
              ),
            ],
          ).paddingOnly(left: 10, right: 10, top:15, bottom: 15),
        )
    );
  }
}
