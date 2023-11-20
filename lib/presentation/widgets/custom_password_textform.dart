import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../app/config/config.dart';

class CustomPasswordTextForm extends StatelessWidget {
  TextEditingController controller;
  bool hidePassword;
  VoidCallback onPress;
  String hintText;
  String validationText;
  final ValueChanged<String>? onChange;
  CustomPasswordTextForm({super.key, required this.controller, required this.hidePassword, required this.onPress,
  required this.hintText, required this.validationText, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 1,
      obscureText: hidePassword?true:false,
      onChanged: onChange,
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
                SvgPicture.asset('assets/images/lock.svg',width: 18,height: 18,
                  color: ColorResources.primary700,),
                //Icon(MdiIcon, color: ColorResources.primary700,size: 18,),
                SizedBox(width: 10,),
                Container(
                  color: Colors.black,
                  width: 0.5,
                  height: 30,
                )
              ],
            ),
          ),
          suffixIcon: controller.text.length>0?
          GestureDetector(
            onTap: onPress,
            child: Container(
              margin: EdgeInsets.only(top: 13,bottom: 13),
              child: SvgPicture.asset(hidePassword?'assets/images/eye close.svg':'assets/images/eye open.svg',
                color: ColorResources.primary700,),
            ),
          ):null,
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
