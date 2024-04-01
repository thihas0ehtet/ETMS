class ClaimHistoryResponse {
  String? claim;
  String? claimGroup;
  double? amount;
  String? receiptDate;
  String? status;

  ClaimHistoryResponse(
      {
        this.claim,
        this.claimGroup,
        this.amount,
        this.receiptDate,
        this.status,
        });

  ClaimHistoryResponse.fromJson(Map<String, dynamic> json) {
    claim = json['Claim'];
    claimGroup = json['Claim_Group'];
    amount = json['Amount'];
    receiptDate = json['Receipt_Date'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Claim'] = this.claim;
    data['Claim_Group'] = this.claimGroup;
    data['Amount'] = this.amount;
    data['Receipt_Date'] = this.receiptDate;
    data['Status'] = this.status;
    return data;
  }
}