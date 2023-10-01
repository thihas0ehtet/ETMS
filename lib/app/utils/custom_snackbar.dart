import 'package:etms/app/config/font_family.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/config.dart';

extension CustomSnackBars on String{
  SnackbarController? error() {
    return
      // connectivityController.isConnected.value?
      Get.snackbar(
        '',
        '',
        duration: const Duration(seconds: 3),
        backgroundColor: ColorResources.errorSnackBar,
        titleText: Text(
          'Failed !',
          style: latoRegular
        ),
        messageText: Text(
          this,
          style: latoRegular.copyWith(color: ColorResources.primary50),
        ),
      );
  }
}