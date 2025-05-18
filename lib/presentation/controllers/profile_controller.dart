import 'dart:convert';
import 'dart:typed_data';
import 'package:etms/app/utils/custom_snackbar.dart';
import 'package:etms/data/datasources/request/profile/emp_master_data.dart';
import 'package:etms/data/datasources/request/profile/next_of_kin_data.dart';
import 'package:etms/data/datasources/response/profile/countries_response.dart';
import 'package:etms/data/datasources/response/profile/emp_master_response.dart';
import 'package:etms/data/datasources/response/profile/marital_status_response.dart';
import 'package:etms/data/datasources/response/profile/next_kin_response.dart';
import 'package:etms/data/datasources/response/profile/relation_type_response.dart';
import 'package:etms/domain/repositories/profile_repository.dart';
import 'package:etms/domain/usecases/profile_usecase.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../app/helpers/error_handling/InternetException.dart';
import '../../app/helpers/error_handling/unknown_error.dart';
import '../../data/datasources/shared_preference_helper.dart';

class ProfileController extends GetxController with StateMixin{
  final ProfileRepository repository;
  ProfileController({required this.repository});

  ProfileUsecase useCase = ProfileUsecase(Get.find());
  // var photo=''.obs;
  Rx<Uint8List> imageBytes = Uint8List.fromList([]).obs;
  RxList<RelationTypeResponse> reTypeList=  RxList<RelationTypeResponse>();
  RxList<CountriesResponse> countriesList=  RxList<CountriesResponse>();
  RxList<MaritalStatusResponse> mStatusList=  RxList<MaritalStatusResponse>();
  Rx<EmpMasterResponse> empMaster = EmpMasterResponse().obs;
  Rx<NextKinResponse> nextKin = NextKinResponse().obs;
  RxBool getPhotoLoading = false.obs;
  RxBool getNextOfKinLoading = true.obs;
  RxBool updateProfileSuccess = false.obs;
  RxBool updateNextKinSuccess = false.obs;

  Future<void> getMyPhoto()async{
    try{
      if(getPhotoLoading.value){
        await EasyLoading.show();
      }
      String response = await useCase.getMyPhoto();
      if(response.toString()!='null'){
        Uint8List bytes = base64.decode(response.split(',').last);
        imageBytes.value = bytes;
        imageBytes.refresh();
      }
      await EasyLoading.dismiss();
    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }on InternetException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<bool> getEmpMaster()async{
    try{
      await EasyLoading.show();
      EmpMasterResponse response = await useCase.getEmpMaster();
      empMaster.value=response;
      empMaster.refresh();
      refresh();

      SharedPreferenceHelper sharedData= Get.find<SharedPreferenceHelper>();
      sharedData.saveSupFlag(response.supFlag!);

      await EasyLoading.dismiss();
      refresh();
      return true;
    }on UnknownException catch(e){
      e.toString().error();
      refresh();
      await EasyLoading.dismiss();
      return false;
    }on InternetException catch(e){
      e.toString().error();
      refresh();
      await EasyLoading.dismiss();
      return false;
    }
  }

  Future<void> saveEmpMaster(EmpMasterData data, FormData? photoForm)async{
    try{
      await EasyLoading.show();
      updateProfileSuccess.value = false;
      updateProfileSuccess.refresh();
      bool success = await useCase.saveEmpMaster(data);
      if(success==true){
        await getEmpMaster();
        if(photoForm!=null){
          // await uploadPhoto(photoForm);
          // 'saved profile information'.success();
          bool photoSuccess = await useCase.uploadPhoto(photoForm);
          if(photoSuccess==true){
            await getMyPhoto();
            'saved profile information'.success();
            updateProfileSuccess.value = true;
            updateProfileSuccess.refresh();
          } else{
            'failed to save photo'.error();
          }
        } else{
          'saved profile information'.success();
          updateProfileSuccess.value = true;
          updateProfileSuccess.refresh();
        }
      } else{
        'failed to save profile information'.error();
      }
      await EasyLoading.dismiss();
    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }on InternetException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<void> getRelationType()async{
    try{
      await EasyLoading.show();
      List<RelationTypeResponse> response = await useCase.getRelationType();
      reTypeList.value=response;
      reTypeList.refresh();
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

  Future<void> getCountries()async{
    try{
      await EasyLoading.show();
      List<CountriesResponse> response = await useCase.getCountries();
      countriesList.value=response;
      countriesList.refresh();
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

  Future<void> getMaritalStatus()async{
    try{
      await EasyLoading.show();
      List<MaritalStatusResponse> response = await useCase.getMaritalStatus();
      mStatusList.value=response;
      mStatusList.refresh();
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

  Future<void> getNextKin()async{
    try{
      getNextOfKinLoading.value = true;
      refresh();
      await EasyLoading.show();
      NextKinResponse response = await useCase.getNextKin();
      nextKin.value=response;
      nextKin.refresh();
      refresh();
      await EasyLoading.dismiss();
      getNextOfKinLoading.value = false;
      refresh();
    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
      getNextOfKinLoading.value = false;
      refresh();
    }on InternetException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
      getNextOfKinLoading.value = false;
      refresh();
    }
  }

  Future<void> saveNextKin(NextOfKinData data)async{
    try{
      await EasyLoading.show();
      updateNextKinSuccess.value = false;
      updateNextKinSuccess.refresh();
      bool success = await useCase.saveNextKin(data);
      if(success==true){
        'saved Next of Kin data'.success();
        updateNextKinSuccess.value = true;
        updateNextKinSuccess.refresh();
        // await getNextKin();
      } else{
        'failed to save Next of Kin data'.error();
      }
      await EasyLoading.dismiss();
    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }on InternetException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<void> uploadPhoto(FormData data)async{
    try{
      await EasyLoading.show();
      bool success = await useCase.uploadPhoto(data);
      if(success==true){
        await getMyPhoto();
        // 'saved photo'.success();
        // await getNextKin();
      } else{
        'failed to save photo'.error();
      }
      await EasyLoading.dismiss();
    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }on InternetException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

}