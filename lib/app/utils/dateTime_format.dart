import 'package:etms/app/config/font_family.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../config/config.dart';

extension DateTimeFormat on DateTime{
  String? dMY() {
    return
      DateFormat('dd-MMM-yyyy').format(this).toString();
  }

  String? dMYE() {
    return
      DateFormat('dd MMM yyyy, EEEE').format(this).toString();
  }
}