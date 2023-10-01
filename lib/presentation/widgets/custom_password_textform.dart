import 'package:flutter/material.dart';
import '../../app/config/config.dart';

class CustomPasswordTextForm extends StatelessWidget {
  TextEditingController controller;
  bool hidePassword;
  VoidCallback onPress;
  String hintText;
  String validationText;
  CustomPasswordTextForm({super.key, required this.controller, required this.hidePassword, required this.onPress,
  required this.hintText, required this.validationText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 1,
      obscureText: hidePassword?true:false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 15.0, top: 12.0, bottom: 12.0),
          hintText: 'Password',
          hintStyle: latoLight.copyWith(color: ColorResources.text500),
          filled: true,
          fillColor: Colors.transparent,
          prefixIcon: Container(
            width: 50,
            // color: Colors.amber,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, color: ColorResources.primary700,size: 18,),
                SizedBox(width: 10,),
                Container(
                  color: Colors.black,
                  width: 0.5,
                  height: 30,
                )
              ],
            ),
          ),
          suffixIcon: IconButton(
            onPressed: onPress,
            icon: Icon(hidePassword?Icons.close:Icons.remove_red_eye),
          )
      ),
      validator: (value) {
        if(value!.isEmpty ) {
          return 'enter password';
        }
        return null;
      },
    );
  }
}
