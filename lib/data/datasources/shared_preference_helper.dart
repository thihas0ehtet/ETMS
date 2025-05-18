import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static SharedPreferenceHelper? _instance;
  static SharedPreferences? _sharedPreferences;

  String companyCode = 'companyCode';
  String empSysId = 'empSysId';
  String fingerprint = 'fingerprint';
  String supFlag = 'supFlag';

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
    _sharedPreferences = await SharedPreferences.getInstance();
    String? result =  _sharedPreferences!.getString(companyCode);
    return result.toString();
  }

  void saveSysId(String id) async{
    _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences!.setString(empSysId, id);
  }

  Future<String> get getEmpSysId async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String? result =  _sharedPreferences!.getString(empSysId);
    return result.toString();
  }

  void saveEnableFingerprint(bool enable) async{
    _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences!.setBool(fingerprint, enable);
  }

  Future<bool> get getFingerprint async{
    _sharedPreferences = await SharedPreferences.getInstance();
    bool? result = _sharedPreferences!.getBool(fingerprint);
    if(result==null){
      return false;
    }
    return result;
  }

  void saveSupFlag(bool flag) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences!.setBool(supFlag, flag);
  }

  Future<bool> get getSupFlag async {
    _sharedPreferences = await SharedPreferences.getInstance();
    bool? result =  _sharedPreferences!.getBool(supFlag);
    return result!;
  }
}