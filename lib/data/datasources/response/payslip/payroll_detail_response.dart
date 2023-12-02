class PayrollDetailResponse {
  String? finNumber;
  String? payDate;
  String? periodStart;
  String? periodEnd;
  int? empSysId;
  String? jobName;
  String? unitPath;
  String? empCode;
  String? empName;
  double? totalDeduction;
  double? totalAllowance;
  double? netAmount;
  dynamic employerContribution;
  dynamic totalContribution;

  PayrollDetailResponse(
      {this.finNumber,
        this.payDate,
        this.periodStart,
        this.periodEnd,
        this.empSysId,
        this.jobName,
        this.unitPath,
        this.empCode,
        this.empName,
        this.totalDeduction,
        this.totalAllowance,
        this.netAmount,
        this.employerContribution,
        this.totalContribution});

  PayrollDetailResponse.fromJson(Map<String, dynamic> json) {
    finNumber = json['FINNUMBER'];
    payDate = json['PAYROLL_DATE'];
    periodStart = json['Period_Start_From'];
    periodEnd = json['Period_End'];
    empSysId = json['EMP_SYS_ID'];
    jobName = json['JOB_NAME'];
    unitPath = json['UNIT_PATH'];
    empCode = json['EMP_CODE'];
    empName = json['EMP_NAME'];
    totalDeduction = json['TOTAL_DEDUCTION'];
    totalAllowance = json['TOTAL_ALLOWANCE'];
    netAmount = json['NET_AMOUNT'];
    employerContribution = json['EMPLOYER_CONTRIBUTION'];
    totalContribution = json['TOTAL_CONTRIBUTION'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FINNUMBER'] = this.finNumber;
    data['PAYROLL_DATE'] = this.payDate;
    data['Period_Start_From'] = this.periodStart;
    data['Period_End'] = this.periodEnd;
    data['EMP_SYS_ID'] = this.empSysId;
    data['JOB_NAME'] = this.jobName;
    data['UNIT_PATH'] = this.unitPath;
    data['EMP_CODE'] = this.empCode;
    data['EMP_NAME'] = this.empName;
    data['TOTAL_DEDUCTION'] = this.totalDeduction;
    data['TOTAL_ALLOWANCE'] = this.totalAllowance;
    data['NET_AMOUNT'] = this.netAmount;
    data['EMPLOYER_CONTRIBUTION'] = this.employerContribution;
    data['TOTAL_CONTRIBUTION'] = this.totalContribution;
    return data;
  }
}