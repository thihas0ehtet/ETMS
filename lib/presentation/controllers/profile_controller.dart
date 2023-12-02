import 'package:etms/app/utils/custom_snackbar.dart';
import 'package:etms/data/datasources/response/profile/countries_response.dart';
import 'package:etms/data/datasources/response/profile/emp_master_response.dart';
import 'package:etms/data/datasources/response/profile/marital_status_response.dart';
import 'package:etms/data/datasources/response/profile/next_kin_response.dart';
import 'package:etms/data/datasources/response/profile/relation_type_response.dart';
import 'package:etms/domain/repositories/profile_repository.dart';
import 'package:etms/domain/usecases/profile_usecase.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../app/helpers/error_handling/unknown_error.dart';

class ProfileController extends GetxController with StateMixin{
  final ProfileRepository repository;
  ProfileController({required this.repository});

  ProfileUsecase useCase = ProfileUsecase(Get.find());
  var photo=''.obs;
  RxList<RelationTypeResponse> reTypeList=  RxList<RelationTypeResponse>();
  RxList<CountriesResponse> countriesList=  RxList<CountriesResponse>();
  RxList<MaritalStatusResponse> mStatusList=  RxList<MaritalStatusResponse>();
  Rx<EmpMasterResponse> empMaster = EmpMasterResponse().obs;
  Rx<NextKinResponse> nextKin = NextKinResponse().obs;

  Future<void> getMyPhoto()async{
    print("HELLO TIS IS getMyPhoto");
    try{
      await EasyLoading.show();
      String response = await useCase.getMyPhoto();
      photo.value=response;
      photo.refresh();
      await EasyLoading.dismiss();
    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<void> getEmpMaster()async{
    try{
      await EasyLoading.show();
      EmpMasterResponse response = await useCase.getEmpMaster();
      empMaster.value=response;
      empMaster.refresh();
      await EasyLoading.dismiss();
    }on UnknownException catch(e){
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
      await EasyLoading.dismiss();
    }on UnknownException catch(e){
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
      await EasyLoading.dismiss();
    }on UnknownException catch(e){
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
      await EasyLoading.dismiss();
    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }

  Future<void> getNextKin()async{
    try{
      await EasyLoading.show();
      NextKinResponse response = await useCase.getNextKin();
      nextKin.value=response;
      nextKin.refresh();
      await EasyLoading.dismiss();
    }on UnknownException catch(e){
      e.toString().error();
      await EasyLoading.dismiss();
    }
  }
}