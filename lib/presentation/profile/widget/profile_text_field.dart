import 'package:flutter/material.dart';
import '../../../app/config/config.dart';

class ProfileTextField extends StatelessWidget {
  TextEditingController controller;
  String label;
  bool isReadOnly;
  bool isNumber;
  ProfileTextField({super.key, required this.controller, required this.label, this.isReadOnly=false, this.isNumber=false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        readOnly: isReadOnly,
        keyboardType: isNumber?TextInputType.number:TextInputType.text,
        style:  latoRegular.copyWith(color: ColorResources.text500, fontSize: 15),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 15.0, top: 12.0, bottom: 12.0),
            labelText: label,
            labelStyle:  latoRegular.copyWith(color: ColorResources.text400, fontSize: 15),
            filled: true,
            fillColor: Colors.transparent,
            suffixIcon: isReadOnly?null:Icon(Icons.edit, size: 20)
        )
    );
  }
}
