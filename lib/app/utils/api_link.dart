import 'package:get/get.dart';
import '../../data/datasources/shared_preference_helper.dart';

extension ApiLink on String{
  Future<String> link() async {
    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
    String companyCode= await _sharedPrefs.getCompanyCode;
    String link= companyCode+'/api/'+this;
    return link;
  }
}