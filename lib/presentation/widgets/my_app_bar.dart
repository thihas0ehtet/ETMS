import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app/config/color_resources.dart';
import '../../app/config/font_family.dart';

PreferredSizeWidget MyAppBar({
  required String title,
  Widget? widget
}){
  return PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: Container(
        padding: EdgeInsets.only(top: 20,bottom: 20),
        color: ColorResources.primary800,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: ()=>Get.back(),
                  child: SvgPicture.asset('assets/images/back.svg',width: 22,height: 22,
                    color: ColorResources.white,).paddingOnly(right: 10),
                ),
                Text(title, style: latoSemibold.copyWith(fontWeight: FontWeight.w500,
                    fontSize: 16, color: ColorResources.white),)
              ],
            ),
            widget??Container()
          ],
        ).paddingOnly(left: 10,right: 10),
      )
  );
}
class CustomAppBar extends StatelessWidget {
  String title;
  Widget? widget;
  CustomAppBar({super.key, required this.title, this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20,bottom: 20),
      color: ColorResources.primary800,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: ()=>Get.back(),
                child: SvgPicture.asset('assets/images/back.svg',width: 22,height: 22,
                  color: ColorResources.white,).paddingOnly(right: 10),
              ),
              Text(title, style: latoSemibold.copyWith(fontWeight: FontWeight.w500,
                  fontSize: 16, color: ColorResources.white),)
            ],
          ),
          widget??Container()
        ],
      ).paddingOnly(left: 10,right: 10),
    );
  }
}
