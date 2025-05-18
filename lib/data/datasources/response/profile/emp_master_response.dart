class EmpMasterResponse {
  int? empSysId;
  String? empCode;
  String? empSex;
  String? empFirstName;
  String? empLastName;
  String? empContactNo;
  String? empEmail;
  String? empCurrentAddr;
  String? empPermanentAddr;
  int? empMaritalStatusID;
  dynamic empPassportExpDate;
  bool? supFlag;

  EmpMasterResponse(
      {this.empSysId,
        this.empCode,
        this.empSex,
        this.empFirstName,
        this.empLastName,
        this.empContactNo,
        this.empEmail,
        this.empCurrentAddr,
        this.empPermanentAddr,
        this.empMaritalStatusID,
        this.empPassportExpDate,
        this.supFlag
      });

  EmpMasterResponse.fromJson(Map<String, dynamic> json) {
    empSysId = json['Emp_Sys_ID'];
    empCode = json['Emp_Code'];
    empSex = json['Emp_Sex'];
    empFirstName = json['Emp_First_Name'];
    empLastName = json['Emp_Last_Name'];
    empContactNo = json['Emp_Contact_No'];
    empEmail = json['Emp_Email'];
    empCurrentAddr = json['Emp_Current_Addr'];
    empPermanentAddr = json['Emp_Permanent_Addr'];
    empMaritalStatusID = json['Emp_Marital_Status_ID'];
    empPassportExpDate = json['Emp_Passport_Exp_Date'];
    supFlag = json['Sup_Flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Emp_Sys_ID'] = this.empSysId;
    data['Emp_Code'] = this.empCode;
    data['Emp_Sex'] = this.empSex;
    data['Emp_First_Name'] = this.empFirstName;
    data['Emp_Last_Name'] = this.empLastName;
    data['Emp_Contact_No'] = this.empContactNo;
    data['Emp_Email'] = this.empEmail;
    data['Emp_Current_Addr'] = this.empCurrentAddr;
    data['Emp_Permanent_Addr'] = this.empPermanentAddr;
    data['Emp_Marital_Status_ID'] = this.empMaritalStatusID;
    data['Emp_Passport_Exp_Date'] = this.empPassportExpDate;
    data['Sup_Flag'] = this.supFlag;
    return data;
  }
}