import 'package:etms/data/datasources/request/approval/compoff_proposal_request.dart';
import 'package:etms/data/datasources/request/approval/ot_proposal_request.dart';
import 'package:etms/data/datasources/response/approval/comp_approval_data_response.dart';
import 'package:etms/data/datasources/response/approval/leave_proposal_detail.dart';
import 'package:etms/data/datasources/response/approval/leave_proposal_response.dart';
import 'package:etms/data/datasources/response/approval/ot_approval_list_response.dart';
import 'package:etms/domain/repositories/approval_repository.dart';
import '../../data/datasources/request/approval/leave_propose_request.dart';
import '../../data/datasources/response/approval/noti_count_response.dart';
import '../../data/datasources/response/claim/other_approval_response.dart';

class ApprovalUseCase{
  final ApprovalRepository respository;
  ApprovalUseCase(this.respository);

  Future<List<LeaveProposalResponse>> getLeaveProposalList() async{
    return respository.getLeaveProposalList();
  }

  Future<List<LeaveProposalDetailResponse>> getLeaveProposalDetailList({required String notifyId, required String proposalId}) async{
    return respository.getLeaveProposalDetail(notifierId: notifyId, proposalId: proposalId);
  }

  Future<List<OTApprovalLevel2Response>> getOtApprovalList({required String empId, required String selectedDate}) async{
    return respository.getOtApprovalList(empId: empId, selectedDate: selectedDate);
  }

  Future<List<CompApprovalDataResponse>> getCompApprovalList() async{
    return respository.getCompApprovalList();
  }

  Future<bool> saveLeaveProposal({required LeaveProposeRequest data}) async{
    return respository.saveLeaveProposal(data: data);
  }

  Future<bool> saveCompOffProposal({required CompOffProposalRequest data, required String requestId}) async{
    return respository.saveCompOffProposal(data: data, requestId: requestId);
  }

  Future<bool> saveOTProposal({required OTProposalRequest data}) async{
    return respository.saveOTProposal(data: data);
  }
  Future<List<OtherApprovalResponse>> getClaimApprovalList() async{
    return respository.getClaimApprovalList();
  }

  Future<bool> approveClaim({required int id}) async{
    return respository.approveClaim(id: id);
  }

  Future<bool> rejectClaim({required int id}) async{
    return respository.rejectClaim(id: id);
  }

  Future<List<NotiCountResponse>> getNotiCount() async{
    return respository.getNotiCount();
  }
}