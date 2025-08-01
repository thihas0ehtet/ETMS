class LeaveTypeData {
  int? leaveTypeID;
  String? leaveTypeCode;
  String? leaveTypeName;
  bool? salaryPayable;
  bool? allowedUnderProbation;
  int? maximumPersonByDept;
  bool? calculateProrated;
  dynamic minimumDays;
  bool? availableOnline;
  bool? fileUploadable;

  LeaveTypeData(
      {this.leaveTypeID,
        this.leaveTypeCode,
        this.leaveTypeName,
        this.salaryPayable,
        this.allowedUnderProbation,
        this.maximumPersonByDept,
        this.calculateProrated,
        this.minimumDays,
        this.availableOnline,
        this.fileUploadable
      });

  LeaveTypeData.fromJson(Map<String, dynamic> json) {
    leaveTypeID = json['LeaveType_ID'];
    leaveTypeCode = json['LeaveType_Code'];
    leaveTypeName = json['LeaveType_Name'];
    salaryPayable = json['Salary_Payable'];
    allowedUnderProbation = json['Allowed_Under_Probation'];
    maximumPersonByDept = json['Maximum_Person_By_Dept'];
    calculateProrated = json['Calculate_Prorated'];
    minimumDays = json['Minimum_Days'];
    availableOnline = json['Available_Online'];
    fileUploadable = json['File_Uploadable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LeaveType_ID'] = this.leaveTypeID;
    data['LeaveType_Code'] = this.leaveTypeCode;
    data['LeaveType_Name'] = this.leaveTypeName;
    data['Salary_Payable'] = this.salaryPayable;
    data['Allowed_Under_Probation'] = this.allowedUnderProbation;
    data['Maximum_Person_By_Dept'] = this.maximumPersonByDept;
    data['Calculate_Prorated'] = this.calculateProrated;
    data['Minimum_Days'] = this.minimumDays;
    data['Available_Online'] = this.availableOnline;
    data['File_Uploadable'] = this.fileUploadable;
    return data;
  }
}