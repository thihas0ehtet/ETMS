class AttendanceReportData {
  int? unitId;
  String? empSysId;
  String? active;
  String? sDate;
  String? eDate;
  int? uid;

  AttendanceReportData(
      {
        this.unitId,
        this.empSysId,
        this.active,
        this.sDate,
        this.eDate,
        this.uid
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['unit_id'] = unitId;
    data['Emp_Sys_id'] = empSysId;
    data['active'] = active;
    data['sdate'] = sDate;
    data['edate'] = eDate;
    data['uid'] = uid;
    return data;
  }
}
