import 'package:etms/data/datasources/request/emp_master_data.dart';
import 'package:etms/data/datasources/request/next_of_kin_data.dart';
import 'package:etms/data/datasources/request/request.dart';
import 'package:etms/data/datasources/response/profile/countries_response.dart';
import 'package:etms/data/datasources/response/profile/emp_master_response.dart';
import 'package:etms/data/datasources/response/profile/marital_status_response.dart';
import 'package:etms/data/datasources/response/profile/next_kin_response.dart';
import 'package:etms/data/datasources/response/profile/relation_type_response.dart';
import 'package:etms/domain/repositories/payslip_respository.dart';
import 'package:etms/domain/repositories/profile_repository.dart';
import 'package:get/get.dart';
import '../../data/datasources/request/payroll_detail_data.dart';
import '../../data/datasources/response/payslip/payslip_response.dart';

class ProfileUsecase{
  final ProfileRepository respository;
  ProfileUsecase(this.respository);

  Future<String> getMyPhoto() async{
    return respository.getMyPhoto();
  }

  Future<EmpMasterResponse> getEmpMaster() async{
    return respository.getEmpMaster();
  }

  Future<bool> saveEmpMaster(EmpMasterData data) async{
    return respository.saveEmpMaster(data);
  }

  Future<List<RelationTypeResponse>> getRelationType() async{
    return respository.getRelationType();
  }

  Future<List<CountriesResponse>> getCountries() async{
    return respository.getCountries();
  }

  Future<List<MaritalStatusResponse>> getMaritalStatus() async{
    return respository.getMaritalStatus();
  }

  Future<NextKinResponse> getNextKin() async{
    return respository.getNextKin();
  }

  Future<bool> saveNextKin(NextOfKinData data) async{
    return respository.saveNextKin(data);
  }

  Future<bool> uploadPhoto(FormData data) async{
    return respository.uploadPhoto(data);
  }
}