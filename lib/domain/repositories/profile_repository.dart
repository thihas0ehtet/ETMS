import 'package:etms/data/datasources/request/emp_master_data.dart';
import 'package:etms/data/datasources/request/next_of_kin_data.dart';
import 'package:etms/data/datasources/request/upload_photo_data.dart';
import 'package:etms/data/datasources/response/profile/countries_response.dart';
import 'package:etms/data/datasources/response/profile/emp_master_response.dart';
import 'package:etms/data/datasources/response/profile/marital_status_response.dart';
import 'package:etms/data/datasources/response/profile/next_kin_response.dart';
import 'package:etms/data/datasources/response/profile/relation_type_response.dart';
import 'package:get/get.dart';

abstract class ProfileRepository {
  Future<String> getMyPhoto();
  Future<EmpMasterResponse> getEmpMaster();
  Future<List<RelationTypeResponse>> getRelationType();
  Future<List<MaritalStatusResponse>> getMaritalStatus();
  Future<List<CountriesResponse>> getCountries();
  Future<NextKinResponse> getNextKin();
  Future<bool> saveEmpMaster(EmpMasterData data);
  Future<bool> saveNextKin(NextOfKinData data);
  Future<bool> uploadPhoto(FormData data);
}