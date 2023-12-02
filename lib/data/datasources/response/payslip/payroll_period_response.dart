class PayrollPeriodResponse {
  int? payrollPeriodID;
  String? payrollDate;
  String? payrollPeriodDescription;

  PayrollPeriodResponse(
      {this.payrollPeriodID,
        this.payrollDate,
        this.payrollPeriodDescription,
      });

  PayrollPeriodResponse.fromJson(Map<String, dynamic> json) {
    payrollPeriodID = json['Payroll_Period_ID'];
    payrollDate = json['Payroll_Date'];
    payrollPeriodDescription = json['Payroll_Period_Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Payroll_Period_ID'] = this.payrollPeriodID;
    data['Payroll_Date'] = this.payrollDate;
    data['Payroll_Period_Description'] = this.payrollPeriodDescription;
    return data;
  }
}