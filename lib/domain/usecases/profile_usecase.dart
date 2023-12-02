import 'package:etms/data/datasources/response/profile/countries_response.dart';
import 'package:etms/data/datasources/response/profile/emp_master_response.dart';
import 'package:etms/data/datasources/response/profile/marital_status_response.dart';
import 'package:etms/data/datasources/response/profile/next_kin_response.dart';
import 'package:etms/data/datasources/response/profile/relation_type_response.dart';
import 'package:etms/domain/repositories/payslip_respository.dart';
import 'package:etms/domain/repositories/profile_repository.dart';
import '../../data/datasources/request/payroll_detail_data.dart';
import '../../data/datasources/response/payslip/payslip_response.dart';

class ProfileUsecase{
  final ProfileRepository respository;
  ProfileUsecase(this.respository);

  Future<String> getMyPhoto() async{
    print("JFDLKSJF KCOME HERE");
    return respository.getMyPhoto();
  }

  Future<EmpMasterResponse> getEmpMaster() async{
    return respository.getEmpMaster();
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
}