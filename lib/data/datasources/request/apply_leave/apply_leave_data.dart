class ApplyLeaveData {
  int? leaveProposeID;
  String? empSysID;
  String? leaveStartDate;
  String? leaveEndDate;
  double? duration;
  int? notifiedTo;
  int? notifiedTo2;
  String? leaveProposeDate;
  String? remark;
  String? leaveTypeId;
  List<LeaveProposalDetail>? leaveProposalDetail;

  ApplyLeaveData(
      {this.leaveProposeID,
        this.empSysID,
        this.leaveStartDate,
        this.leaveEndDate,
        this.duration,
        this.notifiedTo,
        this.notifiedTo2,
        this.leaveProposeDate,
        this.remark,
        this.leaveTypeId,
        this.leaveProposalDetail});

  ApplyLeaveData.fromJson(Map<String, dynamic> json) {
    leaveProposeID = json['Leave_Propose_ID'];
    empSysID = json['Emp_Sys_ID'];
    leaveStartDate = json['Leave_Start_Date'];
    leaveEndDate = json['Leave_End_Date'];
    duration = json['Duration'];
    notifiedTo = json['Notified_To'];
    notifiedTo2 = json['Notified_To_2'];
    leaveProposeDate = json['Leave_Propose_Date'];
    remark = json['Remark'];
    leaveTypeId = json['LeaveTypeId'];
    if (json['LeaveProposalDetail'] != null) {
      leaveProposalDetail = <LeaveProposalDetail>[];
      json['LeaveProposalDetail'].forEach((v) {
        leaveProposalDetail!.add(new LeaveProposalDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Leave_Propose_ID'] = this.leaveProposeID;
    data['Emp_Sys_ID'] = this.empSysID;
    data['Leave_Start_Date'] = this.leaveStartDate;
    data['Leave_End_Date'] = this.leaveEndDate;
    data['Duration'] = this.duration;
    data['Notified_To'] = this.notifiedTo;
    data['Notified_To_2'] = this.notifiedTo2;
    data['Leave_Propose_Date'] = this.leaveProposeDate;
    data['Remark'] = this.remark;
    data['LeaveTypeId'] = this.leaveTypeId;
    if (this.leaveProposalDetail != null) {
      data['LeaveProposalDetail'] =
          this.leaveProposalDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeaveProposalDetail {
  int? leaveProposeDetailID;
  int? leaveProposeID;
  String? leaveTypeID;
  String? leaveDate;
  int? leaveAMPM;
  double? leaveDuration;
  int? leaveStatus;
  int? leaveStatus2;

  LeaveProposalDetail(
      {this.leaveProposeDetailID,
        this.leaveProposeID,
        this.leaveTypeID,
        this.leaveDate,
        this.leaveAMPM,
        this.leaveDuration,
        this.leaveStatus,
        this.leaveStatus2});

  LeaveProposalDetail.fromJson(Map<String, dynamic> json) {
    leaveProposeDetailID = json['Leave_Propose_DetailID'];
    leaveProposeID = json['Leave_Propose_ID'];
    leaveTypeID = json['LeaveType_ID'];
    leaveDate = json['Leave_Date'];
    leaveAMPM = json['Leave_AMPM'];
    leaveDuration = json['Leave_Duration'];
    leaveStatus = json['Leave_Status'];
    leaveStatus2 = json['Leave_Status_2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Leave_Propose_DetailID'] = this.leaveProposeDetailID;
    data['Leave_Propose_ID'] = this.leaveProposeID;
    data['LeaveType_ID'] = this.leaveTypeID;
    data['Leave_Date'] = this.leaveDate;
    data['Leave_AMPM'] = this.leaveAMPM;
    data['Leave_Duration'] = this.leaveDuration;
    data['Leave_Status'] = this.leaveStatus;
    data['Leave_Status_2'] = this.leaveStatus2;
    return data;
  }
}