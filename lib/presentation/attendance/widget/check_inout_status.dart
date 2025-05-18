import 'package:flutter/material.dart';
import '../../../app/config/color_resources.dart';
import '../../../app/config/font_family.dart';

class CheckInOutStatus extends StatelessWidget {
  bool isOnTime;
  CheckInOutStatus({super.key,required this.isOnTime});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.fromLTRB(isOnTime?7:17, 3, isOnTime?7:17, 3),
      decoration: BoxDecoration(
          color: isOnTime?ColorResources.green:ColorResources.red,
          borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: Text(isOnTime?'On Time':'Late',style: latoRegular.copyWith(color: ColorResources.text50),),
    );
  }
}
