import 'package:etms/app/config/api_constants.dart';
import 'package:etms/app/utils/api_link.dart';
import 'package:etms/app/utils/response_code.dart';
import 'package:etms/data/datasources/request/approval/compoff_proposal_request.dart';
import 'package:etms/data/datasources/request/approval/ot_proposal_request.dart';
import 'package:etms/data/datasources/response/approval/comp_approval_data_response.dart';
import 'package:etms/data/datasources/response/approval/leave_proposal_detail.dart';
import 'package:etms/data/datasources/response/approval/leave_proposal_response.dart';
import 'package:get/get.dart';
import '../../app/api/base_provider.dart';
import '../../app/helpers/error_handling/unknown_error.dart';
import '../../app/helpers/helper.dart';
import '../datasources/shared_preference_helper.dart';
import '../../domain/repositories/approval_repository.dart';
import '../datasources/request/approval/leave_propose_request.dart';
import '../datasources/response/approval/noti_count_response.dart';
import '../datasources/response/approval/ot_approval_list_response.dart';
import '../datasources/response/claim/other_approval_response.dart';

class ApprovalRepoImpl extends BaseProvider implements ApprovalRepository{
  Helper helper = Helper();

  Future<List<LeaveProposalResponse>> getLeaveProposalList() async{
    try{
      await helper.checkInternetConnection();
      String apiLink = await ApiConstants.getLeaveProposal.link();
      SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
      String sysId= await _sharedPrefs.getEmpSysId;

      // change it later
      final Response response  = await get(apiLink+'/$sysId');
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){

        List<LeaveProposalResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(LeaveProposalResponse.fromJson(response.body[i]));
        }
        return list;
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
  Future<List<LeaveProposalDetailResponse>> getLeaveProposalDetail({required String notifierId, required String proposalId}) async {
    try{
      String apiLink = await ApiConstants.getLeaveProposalDetail.link();
      final Response response  = await get(apiLink+'?Notifier_ID=$notifierId&ProprosalID=$proposalId');
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        List<LeaveProposalDetailResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(LeaveProposalDetailResponse.fromJson(response.body[i]));
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
  Future<List<OTApprovalLevel2Response>> getOtApprovalList({required String empId, required String selectedDate}) async {
    try{
      await helper.checkInternetConnection();
      String apiLink = await ApiConstants.getOtApprovalLevel2.link();
      SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
      String sysId= await _sharedPrefs.getEmpSysId;

      // change it later
      final Response response  = await get(apiLink+'?Emp_Sys_ID=$sysId&SelectEmpId=$empId&SelectDate=$selectedDate');
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){

        List<OTApprovalLevel2Response> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(OTApprovalLevel2Response.fromJson(response.body[i]));
        }
        return list;
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
  Future<List<CompApprovalDataResponse>> getCompApprovalList() async {
    try{
      await helper.checkInternetConnection();
      String apiLink = await ApiConstants.getCompApprovalList.link();
      SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
      String sysId= await _sharedPrefs.getEmpSysId;

      final Response response  = await get(apiLink+'?Approver_ID=$sysId');
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){

        List<CompApprovalDataResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(CompApprovalDataResponse.fromJson(response.body[i]));
        }
        return list;
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
  Future<bool> saveLeaveProposal({required LeaveProposeRequest data}) async {
    try{
      await helper.checkInternetConnection();
      SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
      String sysId= await _sharedPrefs.getEmpSysId;
      String apiLink = await ApiConstants.saveLeaveProposal.link();
      final Response response = await put('$apiLink/$sysId', data.toJson());
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      } else if(response.statusCode!.codeSuccess){
        return true;
      } else{
        throw UnknownException(response.body);
      }
    } catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<bool> saveCompOffProposal({required CompOffProposalRequest data, required String requestId}) async {
    try{
      await helper.checkInternetConnection();
      String apiLink = await ApiConstants.compOffRequest.link();
      final Response response = await put('$apiLink/$requestId', data.toJson());
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      } else if(response.statusCode!.codeSuccess){
        return true;
      } else{
        throw UnknownException(response.body);
      }
    } catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<bool> saveOTProposal({required OTProposalRequest data}) async {
    try{
      await helper.checkInternetConnection();
      String apiLink = await ApiConstants.saveOTProposal.link();
      final Response response = await put('$apiLink/${data.sysId}', data.toJson());
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      } else if(response.statusCode!.codeSuccess){
        return true;
      } else{
        throw UnknownException(response.body);
      }
    } catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<OtherApprovalResponse>> getClaimApprovalList() async {
    try{
      await helper.checkInternetConnection();
      SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
      String sysId= await _sharedPrefs.getEmpSysId;

      String apiLink = await ApiConstants.getClaimApproval.link();

      final Response response  = await get('$apiLink?Emp_Sys_ID=$sysId');

      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        List<OtherApprovalResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(OtherApprovalResponse.fromJson(response.body[i]));
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
  Future<bool> approveClaim({required int id}) async {
    try{
      await helper.checkInternetConnection();
      String apiLink = await ApiConstants.claimApprove.link();
      final Response response = await put('$apiLink/$id', null);
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      } else if(response.statusCode!.codeSuccess){
        return true;
      } else{
        throw UnknownException(response.body);
      }
    } catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<bool> rejectClaim({required int id}) async {
    try{
      await helper.checkInternetConnection();
      String apiLink = await ApiConstants.claimReject.link();
      final Response response = await put('$apiLink/$id', null);
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      } else if(response.statusCode!.codeSuccess){
        return true;
      } else{
        throw UnknownException(response.body);
      }
    } catch(e){
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<NotiCountResponse>> getNotiCount() async {
    try{
      await helper.checkInternetConnection();
      SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
      String sysId= await _sharedPrefs.getEmpSysId;

      String apiLink = await ApiConstants.getNotiCount.link();
      final Response response  = await get('$apiLink?Sup_ID=$sysId&Parameter=ALL');
      if(response.statusCode==null){
        throw UnknownException('There is something wrong!');
      }
      else if(response.statusCode!.codeSuccess){
        List<NotiCountResponse> list = [];
        for(var i=0;i<response.body.length;i++){
          list.add(NotiCountResponse.fromJson(response.body[i]));
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
}