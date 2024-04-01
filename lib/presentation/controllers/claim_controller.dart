import 'dart:io';
import 'dart:typed_data';
import 'package:etms/data/datasources/response/claim/claim_history_response.dart';
import 'package:etms/data/repositories/claim_repo_impl.dart';
import 'package:path/path.dart' as path;
import 'package:etms/app/utils/custom_snackbar.dart';
import 'package:etms/data/datasources/request/claim/claim_request.dart';
import 'package:etms/data/datasources/request/claim/compoff_request_data.dart';
import 'package:etms/data/datasources/request/claim/ot_request_data.dart';
import 'package:etms/data/datasources/response/claim/claim_groups_response.dart';
import 'package:etms/data/datasources/response/claim/claim_names_response.dart';
import 'package:etms/data/datasources/response/claim/comp_off_response.dart';
import 'package:etms/data/datasources/response/claim/ot_overall_response.dart';
import 'package:etms/domain/repositories/claim_repository.dart';
import 'package:etms/domain/usecases/claim_usecase.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import '../../app/helpers/error_handling/InternetException.dart';
import '../../app/helpers/error_handling/unknown_error.dart';
import '../../data/datasources/response/claim/ot_approval_response.dart';

class ClaimController extends GetxController with StateMixin{
  final ClaimRepository repository;
  ClaimController({required this.repository});
  ClaimUseCase useCase=ClaimUseCase(Get.find());

  RxList<OtApprovalResponse> otApprovalList=  RxList<OtApprovalResponse>();
  RxBool listLoading = true.obs;
  RxList<OtOverallResponse> otOverallList=  RxList<OtOverallResponse>();
  RxList<CompOffResponse> compOffList=  RxList<CompOffResponse>();
  RxBool compOffListLoading = true.obs;
  RxInt saveClaimId = 0.obs;
  RxBool saveClaimLoading = true.obs;
  RxList<ClaimGroupsResponse> claimGroups=  RxList<ClaimGroupsResponse>();
  RxList<ClaimNamesResponse> claimNames=  RxList<ClaimNamesResponse>();
  RxList<ClaimHistoryResponse> claimHistory=  RxList<ClaimHistoryResponse>();
  RxBool claimGroupsLoading = true.obs;
  RxBool claimNamesLoading = true.obs;
  // RxBool claimRequestSuccess = false.obs;
  RxBool claimHistoryLoading = true.obs;

  Future<void> getOtApprovalList() async{
    listLoading.value=true;
    refresh();
    try{
      await EasyLoading.show();
      List<OtApprovalResponse> response = await useCase.getOtApprovalList();
      otApprovalList.value = response;
      otApprovalList.refresh();
      listLoading.value=false;
      refresh();
      await EasyLoading.dismiss();
    }on UnknownException catch(e){
      e.toString().error();
      listLoading.value=false;
      refresh();
      await EasyLoading.dismiss();
    }on InternetException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<bool> requestOT ({required OtRequestData data}) async{
    try{
      await EasyLoading.show();
      bool result = await useCase.requestOT(data: data);
      if(result==true){
        'OT request is successfully submitted'.success();
      } else{
        'OT request failed'.error();
      }
      await EasyLoading.dismiss() ;
      return result;
    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
      return false;
    }on InternetException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
      return false;
    }
  }

  Future<bool> requestCompOff ({required CompOffRequestData data}) async{
    try{
      await EasyLoading.show();
      bool result = await useCase.requestCompOff(data: data);
      if(result==true){
        'Comp-Off request is successfully submitted'.success();
      } else{
        'Comp-Off request failed'.error();
      }
      await EasyLoading.dismiss() ;
      return result;
    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
      return false;
    }on InternetException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
      return false;
    }
  }

  Future<void> getOtOverallList() async{
    try{
      await EasyLoading.show();
      List<OtOverallResponse> response = await useCase.getOtOverallList();
      otOverallList.value = response;
      otOverallList.refresh();
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

  Future<void> getCompOffList({required int year}) async{
    try{
      await EasyLoading.show();
      compOffListLoading.value=true;
      List<CompOffResponse> response = await useCase.getCompOffList(year: year);
      compOffList.value = response;
      compOffList.refresh();
      compOffListLoading.value=false;
      refresh();
      await EasyLoading.dismiss();
    }on UnknownException catch(e){
      e.toString().error();
      compOffListLoading.value=false;
      await EasyLoading.dismiss();
    }on InternetException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<bool> saveClaim({required ClaimRequest data, File? image}) async{
    try{
      await EasyLoading.show();
      // claimRequestSuccess.value = false;
      // claimRequestSuccess.refresh();
      saveClaimLoading.value=true;
      int id = await useCase.saveClaim(data: data);
      saveClaimId.value = id;
      saveClaimId.refresh();

      if(image!=null){
        Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
            image.path,
            format: CompressFormat.jpeg
        );
        String fileType = path.basename(image.path).split('.')[1];
        String outputFile = image.path.replaceAll(fileType, 'jpeg');
        File file = await File(outputFile).writeAsBytes(compressedBytes!);
        FormData formData= FormData(
            {
              'file': MultipartFile(file.path, filename: file.path.split('/').last),
            }
        );

        bool success = await useCase.saveClaimPhoto(data: formData, claimDetailId: saveClaimId.value);
        if(success){
          'Claim request is successfully submitted'.success();
          // claimRequestSuccess.value = true;
          // claimRequestSuccess.refresh();
        }else{
          'Claim request failed'.error();
        }
        return success;
      }else{
        'Claim request is successfully submitted'.success();
      }
      saveClaimLoading.value=false;
      refresh();
      await EasyLoading.dismiss();
      return true;
    }on UnknownException catch(e){
      e.toString().error();
      saveClaimLoading.value=false;
      await EasyLoading.dismiss();
      return false;
    }on InternetException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
      return false;
    }
  }

  Future<void> getClaimGroups() async{
    try{
      await EasyLoading.show();
      claimGroupsLoading.value=true;
      List<ClaimGroupsResponse> response = await useCase.getClaimGroups();
      claimGroups.value = response;
      claimGroups.refresh();
      claimGroupsLoading.value=false;
      refresh();
      await EasyLoading.dismiss();
    }on UnknownException catch(e){
      e.toString().error();
      claimGroupsLoading.value=false;
      refresh();
      await EasyLoading.dismiss();
    }on InternetException catch(e){
      e.toString().error();
      claimGroupsLoading.value=false;
      refresh();
      await EasyLoading.dismiss();
    }
  }

  Future<void> getClaimNames({required groupId}) async{
    try{
      await EasyLoading.show();
      claimNamesLoading.value=true;
      List<ClaimNamesResponse> response = await useCase.getClaimNames(groupId: groupId);
      claimNames.value = response;
      claimNames.refresh();
      claimNamesLoading.value=false;
      refresh();
      await EasyLoading.dismiss();
    }on UnknownException catch(e){
      e.toString().error();
      claimNamesLoading.value=false;
      refresh();
      await EasyLoading.dismiss();
    }on InternetException catch(e){
      e.toString().error();
      claimNamesLoading.value=false;
      refresh();
      await EasyLoading.dismiss();
    }
  }

  Future<void> getClaimHistory({required String selectedDate}) async{
    try{
      await EasyLoading.show();
      claimHistoryLoading.value=true;
      List<ClaimHistoryResponse> response = await useCase.getClaimHistory(selectedDate: selectedDate);
      claimHistory.value = response;
      claimHistory.refresh();
      claimHistoryLoading.value=false;
      refresh();
      await EasyLoading.dismiss();
    }on UnknownException catch(e){
      e.toString().error();
      claimHistoryLoading.value=false;
      refresh();
      await EasyLoading.dismiss();
    }on InternetException catch(e){
      e.toString().error();
      claimHistoryLoading.value=false;
      refresh();
      await EasyLoading.dismiss();
    }
  }

  Future<bool> checkClaimVisible({required ClaimType type}) async{
    try{
      await EasyLoading.show();
      bool success = await useCase.checkClaimVisible(type: type);
      await EasyLoading.dismiss();
      return success;
    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
      return false;
    }on InternetException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
      return false;
    }
  }
}