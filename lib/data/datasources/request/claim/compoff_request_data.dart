class CompOffRequestData {
  String? empSysId;
  String? attDate;
  String? remark;
  double? duration;

  CompOffRequestData(
      {
        this.empSysId,
        this.attDate,
        this.remark,
        this.duration
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Emp_Sys_ID'] = empSysId;
    data['Att_Dat'] = attDate;
    data['Reason'] = remark;
    data['Duration'] = duration;
    return data;
  }
}
