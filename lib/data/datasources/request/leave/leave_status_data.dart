class LeaveStatusData {
  String? empSysId;
  String? selectDate;

  LeaveStatusData(
      {
        this.empSysId,
        this.selectDate
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['EmpSysID'] = empSysId;
    data['SelectDate'] = selectDate;
    return data;
  }
}
