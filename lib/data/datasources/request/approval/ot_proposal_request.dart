class OTProposalRequest {
  String? sysId;
  String? attDate;
  double? otHours;
  String? remark;
  String? sTime;

  OTProposalRequest(
      {
        this.sysId,
        this.attDate,
        this.otHours,
        this.remark,
        this.sTime
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Emp_Sys_ID'] = sysId;
    data['Att_Dat'] = attDate;
    data['OT_APR_HRS'] = otHours;
    data['OT_APR_RMK'] = remark;
    data['OT_S_Time'] = sTime;
    return data;
  }
}
