import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static SharedPreferenceHelper? _instance;
  static SharedPreferences? _sharedPreferences;

  static Future<SharedPreferenceHelper?> getInstance() async {
    _instance ??= SharedPreferenceHelper();
    _sharedPreferences ??= await SharedPreferences.getInstance();
    return _instance;
  }

  String companyCode = 'companyCode';

  void saveCompanyCode(String code) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences!.setString(companyCode, code);
  }

  Future<String> get getCompanyCode async {
    print("THIS IS GET CODE");
    _sharedPreferences = await SharedPreferences.getInstance();
    String? companyCode =  _sharedPreferences!.getString('companyCode');
    print("COMPANJFJ CODE IS $companyCode");
    return companyCode.toString();
  }
}