import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static SharedPreferenceHelper? _instance;
  static SharedPreferences? _sharedPreferences;

  String companyCode = 'companyCode';
  String empSysId = 'empSysId';

  static Future<SharedPreferenceHelper?> getInstance() async {
    _instance ??= SharedPreferenceHelper();
    _sharedPreferences ??= await SharedPreferences.getInstance();
    return _instance;
  }

  void saveCompanyCode(String code) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences!.setString(companyCode, code);
  }

  Future<String> get getCompanyCode async {
    print("THIS IS GET CODE");
    _sharedPreferences = await SharedPreferences.getInstance();
    String? result =  _sharedPreferences!.getString(companyCode);
    print("COMPANJFJ CODE IS $companyCode");
    return result.toString();
  }

  void saveSysId(String id) async{
    _sharedPreferences = await SharedPreferences.getInstance();
    print("SAVE ID $id");
    await _sharedPreferences!.setString(empSysId, id);
  }

  Future<String> get getEmpSysId async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String? result =  _sharedPreferences!.getString(empSysId);
    return result.toString();
  }
}