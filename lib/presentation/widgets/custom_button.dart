import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/config/config.dart';

class CustomButton extends StatelessWidget {
  VoidCallback onTap;
  String text;
  double? width;
  CustomButton({super.key, required this.onTap, required this.text, this.width});

  @override
  Widget build(BuildContext context) {
    return  InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(top: 12, bottom: 12),
          decoration: BoxDecoration(
              color: ColorResources.primary800,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: ColorResources.border)
          ),
          width: width??context.width,
          child: Text(text, textAlign: TextAlign.center, style: latoRegular.copyWith(color: ColorResources.text50),),
        )
    );
  }
}
