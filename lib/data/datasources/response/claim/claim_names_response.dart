class ClaimNamesResponse {
  int? claimNameID;
  String? claimName;

  ClaimNamesResponse(
      {this.claimNameID,
        this.claimName
      });

  ClaimNamesResponse.fromJson(Map<String, dynamic> json) {
    claimNameID = json['ClaimName_ID'];
    claimName = json['Claim_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ClaimName_ID'] = this.claimNameID;
    data['Claim_Name'] = this.claimName;
    return data;
  }
}