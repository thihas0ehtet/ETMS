import 'package:flutter/material.dart';
import '../../app/config/config.dart';

class CustomTextForm extends StatelessWidget {
  TextEditingController controller;
  IconData icon;
  String hintText;
  String validationText;
  bool isNumber;
  CustomTextForm({super.key,required this.controller, required this.hintText, required this.validationText, required this.icon,
  this.isNumber=false});

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
              Icon(icon, color: ColorResources.primary700,size: 18,),
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
