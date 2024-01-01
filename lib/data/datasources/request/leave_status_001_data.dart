class LeaveStatus001Data {
  String? empSysId;
  String? sdate;
  String? edate;

  LeaveStatus001Data(
      {
        this.empSysId,
        this.sdate,
        this.edate
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['EmpSysID'] = empSysId;
    data['sdate'] = sdate;
    data['edate'] = edate;
    return data;
  }
}
