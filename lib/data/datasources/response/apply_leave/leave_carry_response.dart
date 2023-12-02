class LeaveCarryResponse {
  double? leaveAdditional;
  double? leaveForfeit;
  double? leaveCarry;
  double? leaveTaken;
  double? entitled;
  double? pending;
  double? balance;
  int? empSysID;
  int? leaveTypeID;
  double? carryForward;
  dynamic leaveYear;
  dynamic remarks;
  int? id;
  int? leavetypeId;
  int? leaveAppID;
  String? unitl;

  LeaveCarryResponse(
      {this.leaveAdditional,
        this.leaveForfeit,
        this.leaveCarry,
        this.leaveTaken,
        this.entitled,
        this.pending,
        this.balance,
        this.empSysID,
        this.leaveTypeID,
        this.carryForward,
        this.leaveYear,
        this.remarks,
        this.id,
        this.leavetypeId,
        this.leaveAppID,
        this.unitl});

  LeaveCarryResponse.fromJson(Map<String, dynamic> json) {
    leaveAdditional = json['Leave_Additional'];
    leaveForfeit = json['Leave_Forfeit'];
    leaveCarry = json['Leave_Carry'];
    leaveTaken = json['Leave_Taken'];
    entitled = json['Entitled'];
    pending = json['Pending'];
    balance = json['Balance'];
    empSysID = json['Emp_Sys_ID'];
    leaveTypeID = json['LeaveType_ID'];
    carryForward = json['CarryForward'];
    leaveYear = json['LeaveYear'];
    remarks = json['Remarks'];
    id = json['id'];
    leavetypeId = json['leavetype_id'];
    leaveAppID = json['Leave_App_ID'];
    unitl = json['unitl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Leave_Additional'] = this.leaveAdditional;
    data['Leave_Forfeit'] = this.leaveForfeit;
    data['Leave_Carry'] = this.leaveCarry;
    data['Leave_Taken'] = this.leaveTaken;
    data['Entitled'] = this.entitled;
    data['Pending'] = this.pending;
    data['Balance'] = this.balance;
    data['Emp_Sys_ID'] = this.empSysID;
    data['LeaveType_ID'] = this.leaveTypeID;
    data['CarryForward'] = this.carryForward;
    data['LeaveYear'] = this.leaveYear;
    data['Remarks'] = this.remarks;
    data['id'] = this.id;
    data['leavetype_id'] = this.leavetypeId;
    data['Leave_App_ID'] = this.leaveAppID;
    data['unitl'] = this.unitl;
    return data;
  }
}