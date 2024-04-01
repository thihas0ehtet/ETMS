import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/config/config.dart';

class CustomButton extends StatelessWidget {
  VoidCallback onTap;
  String text;
  double? width;
  IconData? icon;
  double paddingTop;
  double paddingBottom;
  Color color;
  CustomButton({super.key, required this.onTap, required this.text, this.width, this.icon, this.paddingTop=12, this.paddingBottom=12, this.color=ColorResources.primary800});

  @override
  Widget build(BuildContext context) {
    return  InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(top: paddingTop, bottom: paddingBottom),
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: ColorResources.border)
          ),
          width: width??context.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(icon!=null)
              Icon(icon, size: 18, color: ColorResources.background,).paddingOnly(right: 10),
              Text(text, textAlign: TextAlign.center, style: latoRegular.copyWith(color: ColorResources.text50),),
            ],
          )

        )
    );
  }
}
