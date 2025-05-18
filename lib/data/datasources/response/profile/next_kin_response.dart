class NextKinResponse {
  int? empSysID;
  String? nKFirstName;
  String? nKLastName;
  String? nKBirthDate;
  String? nKGender;
  String? nKContactNo;
  String? nKEmail;
  int? nKNationality;
  int? nKRelationID;
  String? nKAddress;

  NextKinResponse(
      {this.empSysID,
        this.nKFirstName,
        this.nKLastName,
        this.nKBirthDate,
        this.nKGender,
        this.nKContactNo,
        this.nKEmail,
        this.nKNationality,
        this.nKRelationID,
        this.nKAddress});

  NextKinResponse.fromJson(Map<String, dynamic> json) {
    empSysID = json['Emp_Sys_ID'];
    nKFirstName = json['NK_First_Name'];
    nKLastName = json['NK_Last_Name'];
    nKBirthDate = json['NK_Birth_Date'];
    nKGender = json['NK_Gender'];
    nKContactNo = json['NK_Contact_No'];
    nKEmail = json['NK_Email'];
    nKNationality = json['NK_Nationality'];
    nKRelationID = json['NK_Relation_ID'];
    nKAddress = json['NK_Address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Emp_Sys_ID'] = this.empSysID;
    data['NK_First_Name'] = this.nKFirstName;
    data['NK_Last_Name'] = this.nKLastName;
    data['NK_Birth_Date'] = this.nKBirthDate;
    data['NK_Gender'] = this.nKGender;
    data['NK_Contact_No'] = this.nKContactNo;
    data['NK_Email'] = this.nKEmail;
    data['NK_Nationality'] = this.nKNationality;
    data['NK_Relation_ID'] = this.nKRelationID;
    data['NK_Address'] = this.nKAddress;
    return data;
  }
}