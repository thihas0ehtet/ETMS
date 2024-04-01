class ClaimGroupsResponse {
  int? claimGroupID;
  String? claimGroupName;

  ClaimGroupsResponse(
      {this.claimGroupID,
        this.claimGroupName
      });

  ClaimGroupsResponse.fromJson(Map<String, dynamic> json) {
    claimGroupID = json['ClaimGroup_ID'];
    claimGroupName = json['ClaimGroup_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ClaimGroup_ID'] = this.claimGroupID;
    data['ClaimGroup_Name'] = this.claimGroupName;
    return data;
  }
}
