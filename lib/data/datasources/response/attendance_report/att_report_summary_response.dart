class AttReportSummaryResponse {
  String? empFirstName;
  String? empLastName;
  String? jobName;
  double? workedDays;
  double? absDays;
  double? pDays;
  double? nDays;

  AttReportSummaryResponse(
      {
        this.empFirstName,
        this.empLastName,
        this.jobName,
        this.workedDays,
        this.absDays,
        this.pDays,
        this.nDays});

  AttReportSummaryResponse.fromJson(Map<String, dynamic> json) {
    empFirstName = json['Emp_First_Name'];
    empLastName = json['Emp_Last_Name'];
    jobName = json['job_name'];
    workedDays = json['WORKED_DAYS'];
    absDays = json['ABS_DAYS'];
    pDays = json['P_DAYS'];
    nDays = json['NP_DAYS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Emp_First_Name'] = this.empFirstName;
    data['Emp_Last_Name'] = this.empLastName;
    data['job_name'] = this.jobName;
    data['WORKED_DAYS'] = this.workedDays;
    data['ABS_DAYS'] = this.absDays;
    data['P_DAYS'] = this.pDays;
    data['NP_DAYS'] = this.nDays;
    return data;
  }
}