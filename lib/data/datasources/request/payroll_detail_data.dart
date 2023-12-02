class PayrollDetailData {
  String? empSysId;
  String? unitId;
  String? id;

  PayrollDetailData(
      {
        this.empSysId,
        this.unitId,
        this.id
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Emp_Sys_ID'] = empSysId;
    data['unit_id'] = unitId;
    data['Payroll_Period_ID'] = id;
    return data;
  }
}
