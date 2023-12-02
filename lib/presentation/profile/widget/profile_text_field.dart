import 'package:flutter/material.dart';
import '../../../app/config/config.dart';

class ProfileTextField extends StatelessWidget {
  TextEditingController controller;
  String label;
  ProfileTextField({super.key, required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
        controller: controller,
        // maxLines: 1,
        style:  latoRegular.copyWith(color: ColorResources.text500, fontSize: 15),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 15.0, top: 12.0, bottom: 12.0),
            labelText: label,
            labelStyle:  latoRegular.copyWith(color: ColorResources.text400, fontSize: 15),
            // hintText: 'Name',
            // hintText: 'This is name',
            // hintStyle: latoLight.copyWith(color: ColorResources.text500),
            filled: true,
            fillColor: Colors.transparent,
            suffixIcon: Icon(Icons.edit, size: 20)
        )
    );
  }
}
