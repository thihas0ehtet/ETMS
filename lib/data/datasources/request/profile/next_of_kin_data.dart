class NextOfKinData {
  String? empSysId;
  String? firstName;
  String? lastName;
  String? birthDate;
  String? gender;
  String? contactNo;
  String? email;
  int? nationality;
  int? relationId;
  String? address;

  NextOfKinData(
      {
        this.empSysId,
        this.firstName,
        this.lastName,
        this.birthDate,
        this.gender,
        this.contactNo,
        this.email,
        this.nationality,
        this.relationId,
        this.address
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Emp_Sys_ID'] = empSysId;
    data['NK_First_Name'] = firstName;
    data['NK_Last_Name'] = lastName;
    data['NK_Birth_Date'] = birthDate;
    data['NK_Gender'] = gender;
    data['NK_Contact_No'] = contactNo;
    data['NK_Email'] = email;
    data['NK_Nationality'] = nationality;
    data['NK_Relation_ID'] = relationId;
    data['NK_Address'] = address;
    return data;
  }
}
