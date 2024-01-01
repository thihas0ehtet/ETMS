import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/config/config.dart';
import 'check_inout_status.dart';

class CheckInOutWidget extends StatelessWidget {
  bool isCheckIn;
  bool isOnTime;
  // DateTime? checkInOutTime;
  String checkInOutTime;
  CheckInOutWidget({super.key, required this.isCheckIn, required this.isOnTime, required this.checkInOutTime});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Container(
        width: 170,
        // height: 90,
        padding: EdgeInsets.only(top: 17,bottom: 17),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(3))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset('assets/images/${isCheckIn ? "check-in.svg":"check-out.svg"}',width: 22,height: 22,
                  color: ColorResources.black,).paddingOnly(right: 12),
                // Icon(Icons.login, color: ColorResources.primary700,).paddingOnly(right: 12),
                Flexible(child: Text(isCheckIn?'Check In':'Check Out', style: latoRegular.copyWith(color: ColorResources.text500, fontSize: 16),))
              ],
            ).paddingOnly(bottom: 15),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                Flexible(
                  child: Text(checkInOutTime,
                    style: latoRegular.copyWith(color: ColorResources.text500, fontSize: 14),),
                ),
                if(checkInOutTime!='' && checkInOutTime!='--')
                  Flexible(child: CheckInOutStatus(isOnTime: isOnTime).paddingOnly(left: 10))
              ],
            )
          ],
        ).paddingOnly(left: 15, right: 10),
      ),
    );
  }
}
