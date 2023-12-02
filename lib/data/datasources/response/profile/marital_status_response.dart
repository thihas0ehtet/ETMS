class MaritalStatusResponse {
  int? maritalStatusID;
  String? maritalStatusName;

  MaritalStatusResponse({this.maritalStatusID, this.maritalStatusName});

  MaritalStatusResponse.fromJson(Map<String, dynamic> json) {
    maritalStatusID = json['Marital_Status_ID'];
    maritalStatusName = json['Marital_Status_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Marital_Status_ID'] = this.maritalStatusID;
    data['Marital_Status_Name'] = this.maritalStatusName;
    return data;
  }
}
