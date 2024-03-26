class LeaveProposalDetailResponse {
  double? leaveDuration;
  String? leaveEndDate;
  String? leaveStartDate;
  String? leaveProposeDate;
  String? empFirstName;
  String? empLastName;
  String? remark;
  String? leaveTypeName;
  String? leaveAMPM;
  String? leaveDate;

  LeaveProposalDetailResponse(
      {
        this.empFirstName,
        this.empLastName,
        this.leaveTypeName,
        this.leaveEndDate,
        this.leaveProposeDate,
        this.leaveStartDate,
        this.remark,
        this.leaveAMPM,
        this.leaveDate,
        this.leaveDuration,
        });

  LeaveProposalDetailResponse.fromJson(Map<String, dynamic> json) {
    empFirstName = json['Emp_First_Name'];
    empLastName = json['Emp_Last_Name'];
    leaveTypeName = json['LeaveType_Name'];
    leaveEndDate = json['Leave_End_Date'];
    leaveProposeDate = json['Leave_Propose_Date'];
    leaveStartDate = json['Leave_Start_Date'];
    remark = json['Remark'];
    leaveAMPM = json['Leave_AMPM'];
    leaveDate = json['Leave_Date'];
    leaveDuration = json['Leave_Duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Emp_First_Name'] = this.empFirstName;
    data['Emp_Last_Name'] = this.empLastName;
    data['LeaveType_Name'] = this.leaveTypeName;
    data['Leave_End_Date'] = this.leaveEndDate;
    data['Leave_Propose_Date'] = this.leaveProposeDate;
    data['Leave_Start_Date'] = this.leaveStartDate;
    data['Remark'] = this.remark;
    data['Leave_AMPM'] = this.leaveAMPM;
    data['Leave_Date'] = this.leaveDate;
    data['Leave_Duration'] = this.leaveDuration;
    return data;
  }
}