class LeaveProposalDetailResponse {
  int? leaveProposeDetailID;
  int? leaveProposeID;
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
  int? leaveTypeID;
  int? empSysId;
  dynamic notifiedTo;
  dynamic notifiedTo2;
  int? leaveStatus;
  dynamic leaveStatus2;

  LeaveProposalDetailResponse(
      {
        this.leaveProposeDetailID,
        this.leaveProposeID,
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
        this.leaveTypeID,
        this.empSysId,
        this.notifiedTo,
        this.notifiedTo2,
        this.leaveStatus,
        this.leaveStatus2
        });

  LeaveProposalDetailResponse.fromJson(Map<String, dynamic> json) {
    leaveProposeDetailID = json['Leave_Propose_DetailID'];
    leaveProposeID = json['Leave_Propose_ID'];
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
    leaveTypeID = json['LeaveType_ID'];
    empSysId = json['Emp_Sys_ID'];
    notifiedTo = json['Notified_To'];
    notifiedTo2 = json['Notified_To_2'];
    leaveStatus = json['Leave_Status'];
    leaveStatus2 = json['Leave_Status_2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Leave_Propose_DetailID'] = this.leaveProposeDetailID;
    data['Leave_Propose_ID'] = this.leaveProposeID;
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
    data['LeaveType_ID'] = this.leaveTypeID;
    data['Emp_Sys_ID'] = this.empSysId;
    data['Notified_To'] = this.notifiedTo;
    data['Notified_To_2'] = this.notifiedTo2;
    data['Leave_Status'] = this.leaveStatus;
    data['Leave_Status_2'] = this.leaveStatus2;
    return data;
  }
}