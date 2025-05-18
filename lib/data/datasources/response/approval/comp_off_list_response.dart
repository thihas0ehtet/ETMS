class CompOffListResponse {
  int? requestID;
  int? empSysID;
  String? attDat;
  String? reason;
  double? duration;
  int? approverID;
  int? requestStatus;
  dynamic rejectReason;
  dynamic approvedDuration;
  String? requestedTime;
  dynamic approvedTime;
  String? empCode;
  String? empName;

  CompOffListResponse(
      {this.requestID,
        this.empSysID,
        this.attDat,
        this.reason,
        this.duration,
        this.approverID,
        this.requestStatus,
        this.rejectReason,
        this.approvedDuration,
        this.requestedTime,
        this.approvedTime,
        this.empCode,
        this.empName});

  CompOffListResponse.fromJson(Map<String, dynamic> json) {
    requestID = json['Request_ID'];
    empSysID = json['Emp_Sys_ID'];
    attDat = json['Att_Dat'];
    reason = json['Reason'];
    duration = json['Duration'];
    approverID = json['Approver_ID'];
    requestStatus = json['Request_Status'];
    rejectReason = json['Reject_Reason'];
    approvedDuration = json['Approved_Duration'];
    requestedTime = json['Requested_Time'];
    approvedTime = json['Approved_Time'];
    empCode = json['emp_code'];
    empName = json['Emp_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Request_ID'] = this.requestID;
    data['Emp_Sys_ID'] = this.empSysID;
    data['Att_Dat'] = this.attDat;
    data['Reason'] = this.reason;
    data['Duration'] = this.duration;
    data['Approver_ID'] = this.approverID;
    data['Request_Status'] = this.requestStatus;
    data['Reject_Reason'] = this.rejectReason;
    data['Approved_Duration'] = this.approvedDuration;
    data['Requested_Time'] = this.requestedTime;
    data['Approved_Time'] = this.approvedTime;
    data['emp_code'] = this.empCode;
    data['Emp_Name'] = this.empName;
    return data;
  }
}