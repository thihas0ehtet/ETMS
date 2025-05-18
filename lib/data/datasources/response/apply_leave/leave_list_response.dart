class LeaveReportDataResponse {
  int? empSysId;
  int? lType;
  int? leaveyear;
  String? jobName;
  double? entitled;
  double? additional;
  double? forfeit;
  double? carry;
  double? taken;
  String? leaveDate;
  double? duration;
  double? available;
  double? balance;

  LeaveReportDataResponse(
      {this.empSysId,
        this.lType,
        this.leaveyear,
        this.jobName,
        this.entitled,
        this.additional,
        this.forfeit,
        this.carry,
        this.taken,
        this.leaveDate,
        this.duration,
        this.available,
        this.balance});

  LeaveReportDataResponse.fromJson(Map<String, dynamic> json) {
    empSysId = json['emp_sys_id'];
    lType = json['ltype'];
    leaveyear = json['leaveyear'];
    jobName = json['job_name'];
    entitled = json['entitled'];
    additional = json['Additional'];
    forfeit = json['Forfeit'];
    carry = json['Carry'];
    taken = json['Taken'];
    leaveDate = json['LEAVE_DATE'];
    duration = json['DURATION'];
    available = json['Available'];
    balance = json['Balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emp_sys_id'] = this.empSysId;
    data['ltype'] = this.lType;
    data['leaveyear'] = this.leaveyear;
    data['job_name'] = this.jobName;
    data['entitled'] = this.entitled;
    data['Additional'] = this.additional;
    data['Forfeit'] = this.forfeit;
    data['Carry'] = this.carry;
    data['Taken'] = this.taken;
    data['LEAVE_DATE'] = this.leaveDate;
    data['DURATION'] = this.duration;
    data['Available'] = this.available;
    data['Balance'] = this.balance;
    return data;
  }
}