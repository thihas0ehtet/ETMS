import 'package:etms/app/config/font_family.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/config.dart';

extension CustomSnackBars on String{
  SnackbarController? error() {
    return
      Get.snackbar(
        '',
        '',
        duration: const Duration(seconds: 3),
        backgroundColor: ColorResources.errorSnackBar,
        titleText: Text(
          'Failed !',
          style: latoRegular.copyWith(color: ColorResources.error, fontSize: 15),
        ),
        messageText: Text(
          this,
          style: latoRegular.copyWith(color: ColorResources.primary50),
        ),
      );
  }
  SnackbarController? success() {
    return
      Get.snackbar(
        '',
        '',
        duration: const Duration(seconds: 3),
        backgroundColor: ColorResources.green.withOpacity(0.25),
        titleText: Text(
          'Success !',
          style: latoRegular.copyWith(color: ColorResources.primary50, fontSize: 15),
        ),
        messageText: Text(
          this,
          style: latoRegular.copyWith(color: ColorResources.primary50),
        ),
      );
  }
  SnackbarController? alert() {
    return
      Get.snackbar(
        '',
        '',
        duration: const Duration(seconds: 3),
        backgroundColor: ColorResources.errorSnackBar,
        titleText: Text(
          'Alert',
          style: latoRegular.copyWith(color: ColorResources.primary50, fontSize: 16),
        ),
        messageText: Text(
          this,
          style: latoRegular.copyWith(color: ColorResources.primary50),
        ),
      );
  }
}