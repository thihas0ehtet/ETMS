class OtApprovalResponse {
  int? empSysID;
  String? attDat;
  double? rate;
  double? hours;
  String? sTime;
  String? eTime;

  OtApprovalResponse(
      {this.empSysID,
        this.attDat,
        this.rate,
        this.hours,
        this.sTime,
        this.eTime
      });

  OtApprovalResponse.fromJson(Map<String, dynamic> json) {
    empSysID = json['Emp_Sys_ID'];
    attDat = json['Att_Dat'];
    rate = json['OT_Rat_Cas'];
    hours = json['OT_Hrs'];
    sTime = json['OT_S_Time'];
    eTime = json['OT_E_Time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Emp_Sys_ID'] = this.empSysID;
    data['Att_Dat'] = this.attDat;
    data['OT_Rat_Cas'] = this.rate;
    data['OT_Hrs'] = this.hours;
    data['OT_S_Time'] = this.sTime;
    data['OT_E_Time'] = this.eTime;
    return data;
  }
}