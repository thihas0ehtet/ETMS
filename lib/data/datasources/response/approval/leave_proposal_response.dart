class LeaveProposalResponse {
  int? leaveProposeID;
  String? empFirstName;
  String? empLastName;
  String? empCode;
  String? leaveProposeDate;
  int? empSysID;
  double? duration;
  String? leaveStartDate;
  String? leaveEndDate;
  dynamic remark;
  int? jobID;
  String? jobDescription;
  String? jobName;

  LeaveProposalResponse(
      {this.leaveProposeID,
        this.empFirstName,
        this.empLastName,
        this.empCode,
        this.leaveProposeDate,
        this.empSysID,
        this.duration,
        this.leaveStartDate,
        this.leaveEndDate,
        this.remark,
        this.jobID,
        this.jobDescription,
        this.jobName});

  LeaveProposalResponse.fromJson(Map<String, dynamic> json) {
    leaveProposeID = json['Leave_Propose_ID'];
    empFirstName = json['Emp_First_Name'];
    empLastName = json['Emp_Last_Name'];
    empCode = json['Emp_Code'];
    leaveProposeDate = json['Leave_Propose_Date'];
    empSysID = json['Emp_Sys_ID'];
    duration = json['Duration'];
    leaveStartDate = json['Leave_Start_Date'];
    leaveEndDate = json['Leave_End_Date'];
    remark = json['Remark'];
    jobID = json['Job_ID'];
    jobDescription = json['Job_Description'];
    jobName = json['Job_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Leave_Propose_ID'] = this.leaveProposeID;
    data['Emp_First_Name'] = this.empFirstName;
    data['Emp_Last_Name'] = this.empLastName;
    data['Emp_Code'] = this.empCode;
    data['Leave_Propose_Date'] = this.leaveProposeDate;
    data['Emp_Sys_ID'] = this.empSysID;
    data['Duration'] = this.duration;
    data['Leave_Start_Date'] = this.leaveStartDate;
    data['Leave_End_Date'] = this.leaveEndDate;
    data['Remark'] = this.remark;
    data['Job_ID'] = this.jobID;
    data['Job_Description'] = this.jobDescription;
    data['Job_Name'] = this.jobName;
    return data;
  }
}