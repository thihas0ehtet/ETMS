import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/config/config.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/simple_text_form.dart';

class CheckInOutView extends StatelessWidget {
  TextEditingController? controller;
  DateTime currentTime;
  bool? isOnTime;
  bool? isCheckIn;
  VoidCallback onConfirm;
  VoidCallback onCancel;
  CheckInOutView({super.key, required this.currentTime,this.controller, this.isOnTime=true,
  required this.isCheckIn,required this.onConfirm, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(DateFormat('E, dd MMMM, yyyy').format(currentTime),
                style: latoRegular),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(isCheckIn!?'CHECK IN TIME':'CHECK OUT TIME', style: latoMedium.copyWith(fontSize: 16),),
              Text(DateFormat('h:mm a').format(currentTime),
                style: latoBold.copyWith(fontSize: 16),)
            ],
          ).paddingOnly(top: 25, bottom: 25),
          Text('Remark'),
          SimpleTextFormField(
            controller: controller!,
            hintText: 'your remark...',
            maxLine: 5,).paddingOnly(top: 5),
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
