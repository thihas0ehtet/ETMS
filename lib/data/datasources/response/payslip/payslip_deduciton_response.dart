class PayslipDeductionResponse {
  double? deductionAmount;
  String? deductionName;

  PayslipDeductionResponse(
      {
        this.deductionAmount,
        this.deductionName
      });

  PayslipDeductionResponse.fromJson(Map<String, dynamic> json) {
    deductionAmount = json['DEDUCTION_AMOUNT'];
    deductionName = json['DEDUCTION_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DEDUCTION_AMOUNT'] = this.deductionAmount;
    data['DEDUCTION_NAME'] = this.deductionName;
    return data;
  }
}