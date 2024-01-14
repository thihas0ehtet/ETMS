class LeaveReportData {
  String? emp_sys_id;
  String? ltype;
  String? leaveyear;
  String? active;
  String? uid;
  String? unit_id;

  LeaveReportData(
      {
        this.emp_sys_id,
        this.ltype,
        this.leaveyear,
        this.active,
        this.uid,
        this.unit_id
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emp_sys_id'] = emp_sys_id;
    data['ltype'] = ltype;
    data['leaveyear'] = leaveyear;
    data['active'] = active;
    data['uid'] = uid;
    data['unit_id'] = unit_id;
    return data;
  }
}
