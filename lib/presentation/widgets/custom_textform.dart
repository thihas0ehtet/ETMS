import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../app/config/config.dart';

class CustomTextForm extends StatelessWidget {
  TextEditingController controller;
  IconData? icon;
  String? svgIcon;
  String hintText;
  String validationText;
  bool isNumber;
  CustomTextForm({super.key,required this.controller, required this.hintText, required this.validationText,this.icon,
    this.svgIcon, this.isNumber=false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 1,
      keyboardType: isNumber?TextInputType.number:TextInputType.text,
      // textInputAction: TextInputAction.go,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 15.0, top: 12.0, bottom: 12.0),
        hintText: hintText,
        hintStyle: latoLight.copyWith(color: ColorResources.text500),
        filled: true,
        fillColor: Colors.transparent,
        prefixIcon: Container(
          width: 50,
          // color: Colors.amber,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(icon!=null)
              Icon(icon, color: ColorResources.primary700,size: 18,),
              if(svgIcon!=null)
                SvgPicture.asset(svgIcon!,width: 18,height: 18,
                  color: ColorResources.primary700,),
              SizedBox(width: 10,),
              Container(
                color: Colors.black,
                width: 0.5,
                height: 30,
              )
            ],
          ),
        ),
      ),
      validator: (value) {
        if(value!.isEmpty ) {
          return validationText;
        }
        return null;
      },
    );
  }
}
