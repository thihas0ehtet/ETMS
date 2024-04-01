import 'package:etms/app/utils/api_link.dart';
import 'package:etms/app/utils/response_code.dart';
import 'package:etms/data/datasources/request/claim/claim_request.dart';
import 'package:etms/data/datasources/request/claim/compoff_request_data.dart';
import 'package:etms/data/datasources/request/claim/ot_request_data.dart';
import 'package:etms/data/datasources/response/claim/claim_groups_response.dart';
import 'package:etms/data/datasources/response/claim/claim_history_response.dart';
import 'package:etms/data/datasources/response/claim/claim_names_response.dart';
import 'package:etms/data/datasources/response/claim/comp_off_response.dart';
import 'package:etms/data/datasources/response/claim/ot_approval_response.dart';
import 'package:etms/data/datasources/response/claim/ot_overall_response.dart';
import 'package:etms/domain/repositories/claim_repository.dart';
import 'package:get/get.dart';
import '../../app/api/base_provider.dart';
import '../../app/config/api_constants.dart';
import '../../app/helpers/error_handling/unknown_error.dart';
import '../../app/helpers/helper.dart';
import '../../app/helpers/shared_preference_helper.dart';

enum ClaimType {ot, leave, other}

class ClaimRepoImpl extends BaseProvider implements ClaimRepository{
  Helper helper = Helper();
  @override
  Future<List<OtApprovalResponse>> getOtApprovalList() async{
    try{
      await helper.checkInternetConnection();
      SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
      String sysId= await _sharedPrefs.getEmpSysId;

      String apiLink = await ApiConstants.getOtApproval.link()+'?Emp_Sys_ID=$sysId';
      final Response response  = await get(apiLink);

      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        List<OtApprovalResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(OtApprovalResponse.fromJson(response.body[i]));
        }
        return list;
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<bool> requestOT({required OtRequestData data}) async{
    try{
      await helper.checkInternetConnection();
      String apiLink = await ApiConstants.otRequest.link();

      final Response response  = await put(apiLink, data.toJson());
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        return true;
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }
    catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<bool> requestCompOff({required CompOffRequestData data}) async{
    try{
      await helper.checkInternetConnection();
      String apiLink = await ApiConstants.compOffRequest.link();

      final Response response  = await post(apiLink, data.toJson());
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        return true;
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }
    catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<CompOffResponse>> getCompOffList({required int year}) async{
    try{
      await helper.checkInternetConnection();
      SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
      String sysId= await _sharedPrefs.getEmpSysId;

      String apiLink = await ApiConstants.compOffList.link()+'?Emp_Sys_ID=$sysId&Year=$year';
      final Response response  = await get(apiLink);

      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        List<CompOffResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(CompOffResponse.fromJson(response.body[i]));
        }
        return list;
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<OtOverallResponse>> getOtOverallList() async{
    try{
      await helper.checkInternetConnection();
      SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
      String sysId= await _sharedPrefs.getEmpSysId;

      String apiLink = await ApiConstants.otOverallList.link()+'?Emp_Sys_ID=$sysId';
      final Response response  = await get(apiLink);

      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        List<OtOverallResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(OtOverallResponse.fromJson(response.body[i]));
        }
        return list;
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }catch(e){
      throw UnknownException(e.toString());
    }
  }

  Future<int> saveClaim({required ClaimRequest data}) async{
    try{
      await helper.checkInternetConnection();
      String apiLink = await ApiConstants.saveClaim.link();
      final Response response  = await post(apiLink, data.toJson());

      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        return response.body['ClaimDetail_ID'];
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<ClaimGroupsResponse>> getClaimGroups() async{
    try{
      await helper.checkInternetConnection();
      String apiLink = await ApiConstants.getClaimGroups.link();
      final Response response  = await get(apiLink);
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        List<ClaimGroupsResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(ClaimGroupsResponse.fromJson(response.body[i]));
        }
        return list;
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<ClaimNamesResponse>> getClaimNames({required groupId}) async{
    try{
      await helper.checkInternetConnection();
      String apiLink = await ApiConstants.getClaimNames.link();
      final Response response  = await get('$apiLink/$groupId');
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        List<ClaimNamesResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(ClaimNamesResponse.fromJson(response.body[i]));
        }
        return list;
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }catch(e){
      throw UnknownException(e.toString());
    }
  }


  @override
  Future<bool> saveClaimPhoto({required FormData data, required int claimDetailId}) async {
    try{
      await helper.checkInternetConnection();
      String apiLink = await ApiConstants.saveClaimPicture.link();
      final Response response = await post('$apiLink/$claimDetailId', data);
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      } else if(response.statusCode!.codeSuccess){
        return true;
      } else{
        throw UnknownException(response.body['Message']);
      }
    } catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<ClaimHistoryResponse>> getClaimHistory({required String selectedDate}) async {
    try{
      await helper.checkInternetConnection();
      SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
      String sysId= await _sharedPrefs.getEmpSysId;

      String apiLink = await ApiConstants.getClaimHistory.link();
      final Response response  = await get('$apiLink?EmpSysID=$sysId&SelectDate=$selectedDate');
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        List<ClaimHistoryResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(ClaimHistoryResponse.fromJson(response.body[i]));
        }
        return list;
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<bool> checkClaimVisible({required ClaimType type}) async {
    try{
      await helper.checkInternetConnection();

      String apiLink = await ApiConstants.checkClaimVisible.link();
      final Response response  = await get('$apiLink?KeyWord=${type==ClaimType.ot?'OT_Approval'
          :type==ClaimType.leave?'Leave_Approval':'Other_Claim_Approval'}');
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        bool success = bool.parse(response.body[0]['KeyValue']);
        return success;
      }
      else{
        throw UnknownException(response.body['Message']);
      }
    }catch(e){
      throw UnknownException(e.toString());
    }
  }


}