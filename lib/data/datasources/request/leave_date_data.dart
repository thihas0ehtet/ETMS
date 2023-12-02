class LeaveDateData {
  String? leaveStartDate;
  String? leaveEndDate;
  String? unitId;
  String? leaveTypeId;
  String? empSysId;

  LeaveDateData(
      {
        this.leaveStartDate,
        this.leaveEndDate,
        this.unitId,
        this.leaveTypeId,
        this.empSysId
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Leave_Start_Date'] = leaveStartDate;
    data['Leave_End_Date'] = leaveEndDate;
    data['unit_id'] = unitId;
    data['LeaveType_ID'] = leaveTypeId;
    data['Emp_Sys_ID'] = empSysId;
    return data;
  }
}
