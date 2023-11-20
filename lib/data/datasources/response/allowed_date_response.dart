class AllowedDateResponse {
  int? leaveApplicationDetailID;
  int? leaveAppID;
  String? leaveDate;
  int? leaveAMPM;
  double? duration;
  String? days;
  String? halfType;

  AllowedDateResponse(
      {this.leaveApplicationDetailID,
        this.leaveAppID,
        this.leaveDate,
        this.leaveAMPM,
        this.duration,
        this.days,
        this.halfType});

  AllowedDateResponse.fromJson(Map<String, dynamic> json) {
    leaveApplicationDetailID = json['Leave_ApplicationDetail_ID'];
    leaveAppID = json['Leave_App_ID'];
    leaveDate = json['Leave_Date'];
    leaveAMPM = json['Leave_AMPM'];
    duration = json['Duration'];
    days = json['Days'];
    halfType = json['HalfType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Leave_ApplicationDetail_ID'] = this.leaveApplicationDetailID;
    data['Leave_App_ID'] = this.leaveAppID;
    data['Leave_Date'] = this.leaveDate;
    data['Leave_AMPM'] = this.leaveAMPM;
    data['Duration'] = this.duration;
    data['Days'] = this.days;
    data['HalfType'] = this.halfType;
    return data;
  }
}