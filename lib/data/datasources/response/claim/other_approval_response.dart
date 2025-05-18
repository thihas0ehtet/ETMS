class OtherApprovalResponse {
  int? id;
  String? name;
  String? groupName;
  String? receiptDate;
  String? claimName;
  double? amount;
  dynamic receiptImg;
  String? status;

  OtherApprovalResponse(
      {
        this.id,
        this.claimName,
        this.groupName,
        this.receiptDate,
        this.name,
        this.amount,
        this.receiptImg,
        this.status
      });

  OtherApprovalResponse.fromJson(Map<String, dynamic> json) {
    id = json['ClaimDetail_ID'];
    claimName = json['Claim_Name'];
    receiptDate = json['Receipt_Date'];
    receiptImg = json['Receipt_Img'];
    groupName = json['ClaimGroup_Name'];
    name = json['EMP_NAME'];
    amount = json['ClaimAmount'];
    status = json['ClaimStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ClaimDetail_ID'] = this.id;
    data['Claim_Name'] = this.claimName;
    data['Receipt_Date'] = this.receiptDate;
    data['ClaimGroup_Name'] = this.groupName;
    data['EMP_NAME'] = this.name;
    data['ClaimAmount'] = this.amount;
    data['Receipt_Img'] = this.receiptImg;
    data['ClaimStatus'] = this.status;
    return data;
  }
}