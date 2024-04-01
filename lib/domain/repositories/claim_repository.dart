import 'package:etms/data/datasources/request/claim/compoff_request_data.dart';
import 'package:etms/data/datasources/request/claim/ot_request_data.dart';
import 'package:etms/data/datasources/response/claim/claim_groups_response.dart';
import 'package:etms/data/datasources/response/claim/claim_history_response.dart';
import 'package:etms/data/datasources/response/claim/claim_names_response.dart';
import 'package:etms/data/datasources/response/claim/comp_off_response.dart';
import 'package:etms/data/datasources/response/claim/ot_overall_response.dart';
import 'package:etms/data/repositories/claim_repo_impl.dart';
import 'package:get/get.dart';
import '../../data/datasources/request/claim/claim_request.dart';
import '../../data/datasources/response/claim/ot_approval_response.dart';

abstract class ClaimRepository{
  Future<List<OtApprovalResponse>> getOtApprovalList();
  Future<bool> requestOT({required OtRequestData data});
  Future<bool> requestCompOff({required CompOffRequestData data});
  Future<List<CompOffResponse>> getCompOffList({required int year});
  Future<List<OtOverallResponse>> getOtOverallList();
  Future<int> saveClaim({required ClaimRequest data});

  Future<List<ClaimGroupsResponse>> getClaimGroups();

  Future<List<ClaimNamesResponse>> getClaimNames({required groupId});

  Future<bool> saveClaimPhoto({required FormData data, required int claimDetailId});

  Future<List<ClaimHistoryResponse>> getClaimHistory({required String selectedDate});

  Future<bool> checkClaimVisible({required ClaimType type});
}