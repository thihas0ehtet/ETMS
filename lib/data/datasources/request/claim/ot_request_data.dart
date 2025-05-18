class OtRequestData {
  String? empSysId;
  String? attDate;
  String? remark;
  String? sTime;

  OtRequestData(
      {
        this.empSysId,
        this.attDate,
        this.remark,
        this.sTime
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Emp_Sys_ID'] = empSysId;
    data['Att_Dat'] = attDate;
    data['OT_APR_RMK'] = remark;
    data['OT_S_Time'] = sTime;
    return data;
  }
}
