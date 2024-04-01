class CompOffResponse {
  String? status;
  String? attDat;
  String? reason;
  double? duration;
  String? rejectReason;
  double? approvedDuration;
  String? requestedTime;
  String? approvedTime;

  CompOffResponse(
      {
        this.status,
        this.attDat,
        this.reason,
        this.duration,
        this.rejectReason,
        this.approvedDuration,
        this.requestedTime,
        this.approvedTime
      });

  CompOffResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    attDat = json['Att_Dat'];
    reason = json['Reason'];
    duration = json['Duration'];
    rejectReason = json['Reject_Reason'];
    approvedDuration = json['Approved_Duration'];
    requestedTime = json['Requested_Time'];
    approvedTime = json['Approved_Time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Att_Dat'] = this.attDat;
    data['Reason'] = this.reason;
    data['Duration'] = this.duration;
    data['Reject_Reason'] = this.rejectReason;
    data['Approved_Duration'] = this.approvedDuration;
    data['Requested_Time'] = this.requestedTime;
    data['Approved_Time'] = this.approvedTime;
    return data;
  }
}