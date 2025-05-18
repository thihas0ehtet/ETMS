import 'package:etms/data/datasources/request/approval/compoff_proposal_request.dart';
import 'package:etms/data/datasources/request/approval/ot_proposal_request.dart';
import 'package:etms/data/datasources/response/approval/comp_approval_data_response.dart';
import 'package:etms/data/datasources/response/approval/ot_approval_list_response.dart';
import '../../data/datasources/request/approval/leave_propose_request.dart';
import '../../data/datasources/response/approval/leave_proposal_detail.dart';
import '../../data/datasources/response/approval/leave_proposal_response.dart';
import '../../data/datasources/response/approval/noti_count_response.dart';
import '../../data/datasources/response/claim/other_approval_response.dart';

abstract class ApprovalRepository{
  Future<List<LeaveProposalResponse>> getLeaveProposalList();
  Future<List<LeaveProposalDetailResponse>> getLeaveProposalDetail({required String notifierId, required String proposalId});

  Future<List<OTApprovalLevel2Response>> getOtApprovalList({required String empId, required String selectedDate});

  Future<List<CompApprovalDataResponse>> getCompApprovalList();

  Future<bool> saveLeaveProposal({required LeaveProposeRequest data});

  Future<bool> saveCompOffProposal({required CompOffProposalRequest data, required String requestId});

  Future<bool> saveOTProposal({required OTProposalRequest data});

  Future<List<OtherApprovalResponse>> getClaimApprovalList();

  Future<bool> approveClaim({required int id});

  Future<bool> rejectClaim({required int id});

  Future<List<NotiCountResponse>> getNotiCount();

}