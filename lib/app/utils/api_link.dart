import 'package:etms/app/config/font_family.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/config.dart';
import '../helpers/shared_preference_helper.dart';

extension ApiLink on String{
  Future<String> link() async {
    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
    String companyCode= await _sharedPrefs.getCompanyCode;
    String link= companyCode+'/api/'+this;
    print("LIK IS $link");
    return link;
  }
}