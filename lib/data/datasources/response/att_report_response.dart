// class AttReportResponse {
//   List<AttReportData>? data;
//
//   AttReportResponse({this.data});
//
//   AttReportResponse.fromJson(Map<String, dynamic> json) {
//     if (json['data'] != null) {
//       data = <AttReportData>[];
//       json['data'].forEach((v) {
//         data!.add(AttReportData.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
class AttReportResponse {
  int? unitId;
  int? empSysId;
  dynamic active;
  dynamic sdate;
  dynamic edate;
  int? uid;
  String? dte;
  String? sTIME;
  String? eTIME;
  String? aBSTYPCOD;
  String? rMK;
  dynamic otHours;
  dynamic oT20;
  double? lATMIN;
  double? lESMINS;
  double? eRYOFF;
  double? wRKHRS;
  double? rEQHRS;
  String? lATMINTIM;
  String? lESMINSTIM;
  String? eRYOFFTIM;
  String? wRKHRSTIM;
  String? rEQHRSTIM;
  dynamic remarks;

  AttReportResponse(
      {this.unitId,
        this.empSysId,
        this.active,
        this.sdate,
        this.edate,
        this.uid,
        this.dte,
        this.sTIME,
        this.eTIME,
        this.aBSTYPCOD,
        this.rMK,
        this.otHours,
        this.oT20,
        this.lATMIN,
        this.lESMINS,
        this.eRYOFF,
        this.wRKHRS,
        this.rEQHRS,
        this.lATMINTIM,
        this.lESMINSTIM,
        this.eRYOFFTIM,
        this.wRKHRSTIM,
        this.rEQHRSTIM,
        this.remarks});

  AttReportResponse.fromJson(Map<String, dynamic> json) {
    unitId = json['unit_id'];
    empSysId = json['emp_Sys_id'];
    active = json['active'];
    sdate = json['sdate'];
    edate = json['edate'];
    uid = json['uid'];
    dte = json['dte'];
    sTIME = json['S_TIME'];
    eTIME = json['E_TIME'];
    aBSTYPCOD = json['ABS_TYP_COD'];
    rMK = json['RMK'];
    otHours = json['OtHours'];
    oT20 = json['OT20'];
    lATMIN = json['LAT_MIN'];
    lESMINS = json['LES_MINS'];
    eRYOFF = json['ERY_OFF'];
    wRKHRS = json['WRK_HRS'];
    rEQHRS = json['REQ_HRS'];
    lATMINTIM = json['LAT_MIN_TIM'];
    lESMINSTIM = json['LES_MINS_TIM'];
    eRYOFFTIM = json['ERY_OFF_TIM'];
    wRKHRSTIM = json['WRK_HRS_TIM'];
    rEQHRSTIM = json['REQ_HRS_TIM'];
    remarks = json['Remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unit_id'] = this.unitId;
    data['emp_Sys_id'] = this.empSysId;
    data['active'] = this.active;
    data['sdate'] = this.sdate;
    data['edate'] = this.edate;
    data['uid'] = this.uid;
    data['dte'] = this.dte;
    data['S_TIME'] = this.sTIME;
    data['E_TIME'] = this.eTIME;
    data['ABS_TYP_COD'] = this.aBSTYPCOD;
    data['RMK'] = this.rMK;
    data['OtHours'] = this.otHours;
    data['OT20'] = this.oT20;
    data['LAT_MIN'] = this.lATMIN;
    data['LES_MINS'] = this.lESMINS;
    data['ERY_OFF'] = this.eRYOFF;
    data['WRK_HRS'] = this.wRKHRS;
    data['REQ_HRS'] = this.rEQHRS;
    data['LAT_MIN_TIM'] = this.lATMINTIM;
    data['LES_MINS_TIM'] = this.lESMINSTIM;
    data['ERY_OFF_TIM'] = this.eRYOFFTIM;
    data['WRK_HRS_TIM'] = this.wRKHRSTIM;
    data['REQ_HRS_TIM'] = this.rEQHRSTIM;
    data['Remarks'] = this.remarks;
    return data;
  }
}