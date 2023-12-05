import 'dart:convert';

import 'package:etms/app/utils/api_link.dart';
import 'package:etms/data/datasources/request/emp_master_data.dart';
import 'package:etms/data/datasources/request/next_of_kin_data.dart';
import 'package:etms/data/datasources/response/profile/countries_response.dart';
import 'package:etms/data/datasources/response/profile/emp_master_response.dart';
import 'package:etms/data/datasources/response/profile/marital_status_response.dart';
import 'package:etms/data/datasources/response/profile/next_kin_response.dart';
import 'package:etms/data/datasources/response/profile/relation_type_response.dart';
import 'package:etms/domain/repositories/profile_repository.dart';
import 'package:get/get.dart';
import '../../app/api/base_provider.dart';
import '../../app/config/api_constants.dart';
import '../../app/helpers/error_handling/unknown_error.dart';
import '../../app/helpers/shared_preference_helper.dart';
import 'package:http/http.dart' as http;

class ProfileRepoImpl extends BaseProvider implements ProfileRepository{
  @override
  Future<String> getMyPhoto() async{
    try{
      String apiLink = await ApiConstants.getMyPhoto.link();
      SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
      String sysId= await _sharedPrefs.getEmpSysId;

      final Response response = await get('$apiLink/$sysId');
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      } else if(response.statusCode==200){
        return response.body;
      } else{
        throw UnknownException(response.body['Message']);
      }
    }
    catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<EmpMasterResponse> getEmpMaster() async {
    try{
      String apiLink = await ApiConstants.getEmpMaster.link();
      SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
      String sysId= await _sharedPrefs.getEmpSysId;
      final Response response = await get('$apiLink/$sysId');
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      } else if(response.statusCode==200){
        return EmpMasterResponse.fromJson(response.body);
      } else{
        throw UnknownException(response.body['Message']);
      }
    } catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<bool> saveEmpMaster(EmpMasterData data) async {
    try{
      String apiLink = await ApiConstants.getEmpMaster.link();
      SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
      String sysId= await _sharedPrefs.getEmpSysId;
      final Response response = await put('$apiLink/$sysId',data.toJson());
      print("JFLKDSJLKF JDATAER IS ${data.toJson()}");

      // final http.Response response1 = await http.post(
      //   Uri.parse('https://etms.com.sg:99/api/EmpMaster/2882'),
      //   headers: <String, String>{
      //     'Content-Type': 'application/json',
      //     // Add any other headers as needed
      //   },
      //   body: json.encode(data),
      // );

      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      } else if(response.statusCode==204){
        return true;
      } else{
        throw UnknownException(response.body['Message']);
      }
    } catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<RelationTypeResponse>> getRelationType() async {
   try{
     String apiLink = await ApiConstants.getRelationTypes.link();
     final Response response = await get(apiLink);
     if(response.statusCode==null){
       throw UnknownException('There is something wrong!');
     } else if(response.statusCode==200){
       List<RelationTypeResponse> list = [];
       for(var i=0;i<response.body.length;i++){
         list.add(RelationTypeResponse.fromJson(response.body[i]));
       }
       return list;
     } else{
       throw UnknownException(response.body['Message']);
     }

   } catch(e){
     throw UnknownException(e.toString());
   }
  }

  @override
  Future<List<CountriesResponse>> getCountries() async {
    try{
      String apiLink = await ApiConstants.getCountries.link();
      final Response response = await get(apiLink);
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      } else if(response.statusCode==200){
        List<CountriesResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(CountriesResponse.fromJson(response.body[i]));
        }
        return list;
      } else{
        throw UnknownException(response.body['Message']);
      }

    } catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<MaritalStatusResponse>> getMaritalStatus() async {
    try{
      String apiLink = await ApiConstants.getMaritalStatus.link();
      final Response response = await get(apiLink);
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      } else if(response.statusCode==200){
        List<MaritalStatusResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(MaritalStatusResponse.fromJson(response.body[i]));
        }
        return list;
      } else{
        throw UnknownException(response.body['Message']);
      }

    } catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<NextKinResponse> getNextKin() async {
    try{
      String apiLink = await ApiConstants.getNextKin.link();
      SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
      String sysId= await _sharedPrefs.getEmpSysId;
      final Response response = await get('$apiLink/$sysId');
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      } else if(response.statusCode==200){
        return NextKinResponse.fromJson(response.body);
      } else{
        throw UnknownException(response.body['Message']);
      }
    } catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<bool> saveNextKin(NextOfKinData data) async {
    try{
      String apiLink = await ApiConstants.getNextKin.link();
      SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
      String sysId= await _sharedPrefs.getEmpSysId;
      final Response response = await put('$apiLink/$sysId',data.toJson());
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      } else if(response.statusCode==204){
        return true;
      } else{
        throw UnknownException(response.body['Message']);
      }
    } catch(e){
      throw UnknownException(e.toString());
    }
  }

}