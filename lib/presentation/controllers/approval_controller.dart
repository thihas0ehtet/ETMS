import 'dart:core';
import 'package:etms/app/utils/custom_snackbar.dart';
import 'package:etms/data/datasources/request/approval/compoff_proposal_request.dart';
import 'package:etms/data/datasources/request/approval/ot_proposal_request.dart';
import 'package:etms/data/datasources/response/approval/leave_proposal_detail.dart';
import 'package:etms/data/datasources/response/approval/leave_proposal_response.dart';
import 'package:etms/data/datasources/response/approval/ot_approval_list_response.dart';
import 'package:etms/domain/repositories/approval_repository.dart';
import 'package:etms/domain/usecases/approval_usecase.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../app/helpers/error_handling/InternetException.dart';
import '../../app/helpers/error_handling/unknown_error.dart';
import '../../data/datasources/request/approval/leave_propose_request.dart';
import '../../data/datasources/response/approval/comp_approval_data_response.dart';
import '../../data/datasources/response/approval/noti_count_response.dart';
import '../../data/datasources/response/claim/other_approval_response.dart';

class ApprovalController extends GetxController with StateMixin{
  final ApprovalRepository repository;
  ApprovalController({required this.repository});
  RxList<LeaveProposalResponse> leaveProposalList=  RxList<LeaveProposalResponse>();
  RxList<LeaveProposalDetailResponse> leaveProposalDetailList=  RxList<LeaveProposalDetailResponse>();
  RxList<OTApprovalLevel2Response> otApprovalList=  RxList<OTApprovalLevel2Response>();
  RxList<CompApprovalDataResponse> compOffApprovalList=  RxList<CompApprovalDataResponse>();
  RxList<OtherApprovalResponse> claimApprovalList=  RxList<OtherApprovalResponse>();
  RxList<NotiCountResponse> notiCount=  RxList<NotiCountResponse>();
  ApprovalUseCase useCase = ApprovalUseCase(Get.find());
  RxBool otApprovalListLoading = true.obs;
  RxBool compOffRequestListLoading = true.obs;
  RxBool claimApprovalLoading = true.obs;

  Future<void> getLeaveProposalList() async{
    try{
      await EasyLoading.show();
      List<LeaveProposalResponse> response = await useCase.getLeaveProposalList();
      leaveProposalList.value=response;
      leaveProposalList.refresh();
      refresh();
      await EasyLoading.dismiss();

    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }on InternetException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<void> getLeaveProposalDetailList({required String notifyId, required String proposalId}) async{
    try{
      await EasyLoading.show();
      List<LeaveProposalDetailResponse> response = await useCase.getLeaveProposalDetailList(notifyId: notifyId, proposalId: proposalId);
      leaveProposalDetailList.value=response;
      leaveProposalDetailList.refresh();
      refresh();
      await EasyLoading.dismiss();

    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }on InternetException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<void> getOtApprovalList({required String selectedDate}) async{
    try{
      await EasyLoading.show();
      otApprovalListLoading.value = true;
      otApprovalListLoading.refresh();
      List<OTApprovalLevel2Response> response = await useCase.getOtApprovalList(empId: '0', selectedDate: selectedDate);
      otApprovalList.value=response;
      otApprovalList.refresh();
      refresh();
      await EasyLoading.dismiss();
      otApprovalListLoading.value = false;
      otApprovalListLoading.refresh();

    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
      otApprovalListLoading.value = false;
      otApprovalListLoading.refresh();
    }on InternetException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
      otApprovalListLoading.value = false;
      otApprovalListLoading.refresh();
    }
  }

  Future<void> getCompOffApprovalList() async{
    try{
      await EasyLoading.show();
      compOffRequestListLoading.value=true;
      compOffRequestListLoading.refresh();
      List<CompApprovalDataResponse> response = await useCase.getCompApprovalList();
      compOffApprovalList.value=response;
      compOffApprovalList.refresh();
      refresh();
      await EasyLoading.dismiss();
      compOffRequestListLoading.value=false;
      compOffRequestListLoading.refresh();

    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
      compOffRequestListLoading.value=false;
      compOffRequestListLoading.refresh();
    }on InternetException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
      compOffRequestListLoading.value=false;
      compOffRequestListLoading.refresh();
    }
  }

  Future<void> saveLeaveProposal(LeaveProposeRequest data)async{
    try{
      await EasyLoading.show();
      bool success = await useCase.saveLeaveProposal(data: data);
      if(success==false){
        'failed to update leave proposal'.error();
        await EasyLoading.dismiss();
      } else{
        await EasyLoading.dismiss();
        'Leave proposal has been updated.'.success();
        await getLeaveProposalList();
        await getNotiCount();
        // await getLeaveProposalDetailList();
      }

    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }on InternetException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<void> saveCompOffProposal({required CompOffProposalRequest data, required String requestId})async{
    try{
      await EasyLoading.show();
      bool success = await useCase.saveCompOffProposal(data: data, requestId:  requestId);
      if(success==false){
        'failed to update comp off proposal'.error();
        await EasyLoading.dismiss();
      } else{
        await EasyLoading.dismiss();
        'CompOff proposal has been updated.'.success();
        await getCompOffApprovalList();
        await getNotiCount();
      }

    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }on InternetException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<void> saveOTProposal({required OTProposalRequest data, required String selectedDate})async{
    try{
      await EasyLoading.show();
      bool success = await useCase.saveOTProposal(data: data);
      if(success==false){
        'failed to update OT proposal'.error();
        await EasyLoading.dismiss();
      } else{
        await EasyLoading.dismiss();
        'OT proposal has been updated.'.success();
        await getOtApprovalList(selectedDate: selectedDate);
        await getNotiCount();
      }

    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }on InternetException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<void> getClaimApprovalList() async{
    try{
      await EasyLoading.show();
      claimApprovalLoading.value=true;
      claimApprovalLoading.refresh();
      List<OtherApprovalResponse> response = await useCase.getClaimApprovalList();
      claimApprovalList.value = response;
      claimApprovalList.refresh();
      claimApprovalLoading.value=false;
      claimApprovalLoading.refresh();
      await EasyLoading.dismiss();
    }on UnknownException catch(e){
      e.toString().error();
      claimApprovalLoading.value=false;
      claimApprovalLoading.refresh();
      await EasyLoading.dismiss();
    }on InternetException catch(e){
      e.toString().error();
      claimApprovalLoading.value=false;
      claimApprovalLoading.refresh();
      await EasyLoading.dismiss();
    }
  }

  Future<void> approveClaim({required int id})async{
    try{
      await EasyLoading.show();
      bool success = await useCase.approveClaim(id: id);
      if(success==false){
        'failed to approve claim proposal'.error();
        await EasyLoading.dismiss();
      } else{
        await EasyLoading.dismiss();
        'claim proposal has been approved.'.success();
        await getClaimApprovalList();
        await getNotiCount();
      }

    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }on InternetException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<void> rejectClaim({required int id})async{
    try{
      await EasyLoading.show();
      bool success = await useCase.rejectClaim(id: id);
      if(success==false){
        'failed to reject claim proposal.'.error();
        await EasyLoading.dismiss();
      } else{
        await EasyLoading.dismiss();
        'claim proposal has been rejected.'.success();
        await getClaimApprovalList();
        await getNotiCount();
      }

    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }on InternetException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<void> getNotiCount() async{
    try{
      List<NotiCountResponse> response = await useCase.getNotiCount();
      notiCount.value = response;
      notiCount.refresh();
    }on UnknownException catch(e){
      e.toString().error();
    }on InternetException catch(e){
      e.toString().error();
    }
  }

}