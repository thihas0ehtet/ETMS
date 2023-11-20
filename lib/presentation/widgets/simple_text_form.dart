import 'package:flutter/material.dart';
import '../../app/config/config.dart';

class SimpleTextFormField extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  String? validationText;
  int? maxLine;
  SimpleTextFormField({super.key,required this.controller, required this.hintText,this.validationText, this.maxLine=1});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLine,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 15.0, top: 12.0, bottom: 12.0),
        hintText: hintText,
        hintStyle: latoRegular,
        filled: true,
        fillColor: ColorResources.white,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: ColorResources.border)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: ColorResources.border)
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
