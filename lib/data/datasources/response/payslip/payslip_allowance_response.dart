class PayslipAllowanceResponse {
  double? allowanceAmount;
  String? allowanceName;

  PayslipAllowanceResponse(
      {
        this.allowanceAmount,
        this.allowanceName
      });

  PayslipAllowanceResponse.fromJson(Map<String, dynamic> json) {
    allowanceAmount = json['ALLOWANCE_AMOUNT'];
    allowanceName = json['ALLOWANCE_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ALLOWANCE_AMOUNT'] = this.allowanceAmount;
    data['ALLOWANCE_NAME'] = this.allowanceName;
    return data;
  }
}