class LeaveStatusResponse {
  String? days;
  String? leaveDate;
  String? leaveTypeName;
  String? leaveTypeCode;
  int? leaveAMPM;
  double? duration;
  String? halfType;
  String? status;
  String? eMPCODE;
  String? eMPNAME;

  LeaveStatusResponse(
      {this.days,
        this.leaveDate,
        this.leaveTypeName,
        this.leaveTypeCode,
        this.leaveAMPM,
        this.duration,
        this.halfType,
        this.status,
        this.eMPCODE,
        this.eMPNAME});

  LeaveStatusResponse.fromJson(Map<String, dynamic> json) {
    days = json['Days'];
    leaveDate = json['Leave_Date'];
    leaveTypeName = json['LeaveType_Name'];
    leaveTypeCode = json['LeaveType_Code'];
    leaveAMPM = json['Leave_AMPM'];
    duration = json['Duration'];
    halfType = json['HalfType'];
    status = json['Status'];
    eMPCODE = json['EMP_CODE'];
    eMPNAME = json['EMP_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Days'] = this.days;
    data['Leave_Date'] = this.leaveDate;
    data['LeaveType_Name'] = this.leaveTypeName;
    data['LeaveType_Code'] = this.leaveTypeCode;
    data['Leave_AMPM'] = this.leaveAMPM;
    data['Duration'] = this.duration;
    data['HalfType'] = this.halfType;
    data['Status'] = this.status;
    data['EMP_CODE'] = this.eMPCODE;
    data['EMP_NAME'] = this.eMPNAME;
    return data;
  }
}