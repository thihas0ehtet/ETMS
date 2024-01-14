class AttendanceApprovalData {
  String? inLocation;
  String? empSysId;
  String? remarks;

  AttendanceApprovalData(
      {
        this.inLocation,
        this.empSysId,
        this.remarks
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['In_Location'] = inLocation;
    data['emp_sys_id'] = empSysId;
    data['remarks'] = remarks;
    return data;
  }
}
