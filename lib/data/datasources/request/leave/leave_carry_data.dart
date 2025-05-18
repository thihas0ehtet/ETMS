class LeaveCarryData {
  String? empSysId;
  String? leaveTypeId;
  String? unitl;
  String? leaveAppId;

  LeaveCarryData(
      {
        this.empSysId,
        this.leaveTypeId,
        this.unitl,
        this.leaveAppId
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Emp_Sys_ID'] = empSysId;
    data['LeaveType_ID'] = leaveTypeId;
    data['unitl'] = unitl;
    data['Leave_App_ID'] = leaveAppId;
    return data;
  }
}
