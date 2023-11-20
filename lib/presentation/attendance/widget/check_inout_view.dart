import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/config/config.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/simple_text_form.dart';
import 'check_inout_status.dart';

class CheckInOutView extends StatelessWidget {
  TextEditingController? controller;
  DateTime currentTime;
  bool? isOnTime;
  bool? isEarly;
  bool? isLate;
  bool? isCheckIn;
  VoidCallback onConfirm;
  VoidCallback onCancel;
  CheckInOutView({super.key, required this.currentTime,this.controller, this.isOnTime=true,
  required this.isCheckIn,required this.onConfirm, this.isEarly=false, this.isLate=false, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(DateFormat('E, dd MMMM, yyyy').format(currentTime),
                    style: latoRegular),
              ),
              CheckInOutStatus(
                isOnTime: isOnTime! && isEarly!,),
            ],
          ),
          Text(isCheckIn!?'CHECK IN TIME':'CHECK OUT TIME', style: latoMedium.copyWith(fontSize: 16),).paddingOnly(top: 35),
          Text(DateFormat('h:mm a').format(currentTime),
            style: latoBold.copyWith(fontSize: 16),).paddingOnly(top: 18),
          Align(
            alignment: Alignment.topLeft,
            child:
            isLate!?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('You are late',
                        style: latoSemibold),
                    Text('Your Office Time is 8:40 AM To 4:45 PM.',
                        style: latoSemibold)
                  ],
                ):
            Text('If you are too early, give reason',
                style: latoSemibold)
          ).paddingOnly(top: 35),
          // (isEarly! && isLate!)?SizedBox(width: 0, height: 0,):
          //     isEarly!||isLate!?
          SimpleTextFormField(
            controller: controller!,
            hintText:
                isLate!?'Why are you late?':'Why are you too early?',
            maxLine: 5,).paddingOnly(top: 5)
              // :SizedBox(width: 0, height: 0,)
          ,

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onCancel,
                child: Text('Cancel'),
              ),
              Expanded(
                child: CustomButton(
                  onTap: onConfirm,
                  text: 'Ok',
                ),
              )
            ],
          ).paddingOnly(top: 10)
        ],
      ),
    );
  }
}
