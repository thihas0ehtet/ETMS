import 'package:etms/data/datasources/request/claim/compoff_request_data.dart';
import 'package:etms/data/datasources/response/claim/claim_groups_response.dart';
import 'package:etms/data/datasources/response/claim/claim_history_response.dart';
import 'package:etms/data/datasources/response/claim/claim_names_response.dart';
import 'package:etms/data/datasources/response/claim/comp_off_response.dart';
import 'package:etms/data/datasources/response/claim/ot_overall_response.dart';
import 'package:etms/data/repositories/claim_repo_impl.dart';
import 'package:etms/domain/repositories/claim_repository.dart';
import 'package:get/get.dart';
import '../../data/datasources/request/claim/claim_request.dart';
import '../../data/datasources/request/claim/ot_request_data.dart';
import '../../data/datasources/response/claim/ot_approval_response.dart';

class ClaimUseCase{
  final ClaimRepository respository;
  ClaimUseCase(this.respository);

  Future<List<OtApprovalResponse>> getOtApprovalList() async{
    return respository.getOtApprovalList();
  }

  Future<bool> requestOT({required OtRequestData data}) async{
    return respository.requestOT(data: data);
  }

  Future<bool> requestCompOff({required CompOffRequestData data}) async{
    return respository.requestCompOff(data: data);
  }

  Future<List<CompOffResponse>> getCompOffList({required int year}) async{
    return respository.getCompOffList(year: year);
  }

  Future<List<OtOverallResponse>> getOtOverallList() async{
    return respository.getOtOverallList();
  }

  Future<int> saveClaim({required ClaimRequest data}) async{
    return respository.saveClaim(data: data);
  }

  Future<List<ClaimGroupsResponse>> getClaimGroups() async{
    return respository.getClaimGroups();
  }

  Future<List<ClaimNamesResponse>> getClaimNames({required groupId}) async{
    return respository.getClaimNames(groupId: groupId);
  }

  Future<bool> saveClaimPhoto({required FormData data, required int claimDetailId}) async{
    return respository.saveClaimPhoto(data: data, claimDetailId: claimDetailId);
  }

  Future<List<ClaimHistoryResponse>> getClaimHistory({required String selectedDate}) async{
    return respository.getClaimHistory(selectedDate: selectedDate);
  }

  Future<bool> checkClaimVisible({required ClaimType type}) async{
    return respository.checkClaimVisible(type: type);
  }

}