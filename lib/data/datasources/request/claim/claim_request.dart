class ClaimRequest {
  int? claimNameId;
  int? groupId;
  double? amount;
  int? sysId;
  String? receiptDate;
  int? notifyTo;
  int? claimStatus;
  bool? payStatus;
  String? dateCreated;
  bool? fileUpload;
  String? remark;

  ClaimRequest(
      {
        this.claimNameId,
        this.groupId,
        this.amount,
        this.sysId,
        this.receiptDate,
        this.notifyTo,
        this.claimStatus,
        this.payStatus,
        this.dateCreated,
        this.fileUpload,
        this.remark
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ClaimName_ID'] = claimNameId;
    data['ClaimGroup_ID'] = groupId;
    data['ClaimAmount'] = amount;
    data['Emp_Sys_ID'] = sysId;
    data['Receipt_Date'] = receiptDate;
    data['Notified_To'] = notifyTo;
    data['Claim_Status'] = claimStatus;
    data['Pay_Status'] = payStatus;
    data['CreatedDate'] = dateCreated;
    data['UploadFile'] = fileUpload;
    data['Remark'] = remark;
    return data;
  }
}
