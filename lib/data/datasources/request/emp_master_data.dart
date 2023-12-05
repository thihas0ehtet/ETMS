class EmpMasterData {
  String? code;
  String? contactNo;
  String? email;
  int? maritalStatus;
  String? passportExp;
  String? permanentAddr;
  String? currentAddr;

  EmpMasterData(
      {
        this.code,
        this.contactNo,
        this.email,
        this.maritalStatus,
        this.passportExp,
        this.permanentAddr,
        this.currentAddr
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Emp_Code'] = code;
    data['Emp_Contact_No'] = contactNo;
    data['Emp_Email'] = email;
    data['Emp_Marital_Status_ID'] = maritalStatus;
    data['Emp_Passport_Exp_Date'] = passportExp;
    data['Emp_Permanent_Addr'] = permanentAddr;
    data['Emp_Current_Addr'] = currentAddr;
    return data;
  }
}
