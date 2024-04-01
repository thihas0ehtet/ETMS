import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app/config/color_resources.dart';
import '../../app/config/font_family.dart';


AppBar MyAppBar({required String title,Widget? widget}){
  return  AppBar(
    backgroundColor: ColorResources.primary800,
    foregroundColor: ColorResources.white,
    leading: IconButton(
      icon: SvgPicture.asset('assets/images/back.svg',width: 22,height: 22,
        color: ColorResources.white,),
      onPressed: () => Get.back(),
    ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: latoRegular.copyWith(fontSize: 16, color: ColorResources.white),),
        widget??Container()
      ],
    ),
  );
}
