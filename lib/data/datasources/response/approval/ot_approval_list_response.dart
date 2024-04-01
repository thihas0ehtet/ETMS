class OTApprovalLevel2Response {
  int? sysId;
  String? eMPNAME;
  String? attDat;
  String? oTSTime;
  String? oTETime;
  double? oTRatCas;
  double? oTHrs;
  dynamic remark;
  double? apprHour;

  OTApprovalLevel2Response(
      {
        this.sysId,
        this.attDat,
        this.oTRatCas,
        this.oTHrs,
        this.oTSTime,
        this.oTETime,
        this.eMPNAME,
        this.remark,
        this.apprHour
      });

  OTApprovalLevel2Response.fromJson(Map<String, dynamic> json) {
    sysId = json['Emp_Sys_ID'];
    attDat = json['Att_Dat'];
    oTRatCas = json['OT_Rat_Cas'];
    oTHrs = json['OT_Hrs'];
    oTSTime = json['OT_S_Time'];
    oTETime = json['OT_E_Time'];
    eMPNAME = json['EMP_NAME'];
    remark = json['OT_APR_RMK'];
    apprHour = json['OT_APR_HRS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Emp_Sys_ID'] = this.sysId;
    data['Att_Dat'] = this.attDat;
    data['OT_Rat_Cas'] = this.oTRatCas;
    data['OT_Hrs'] = this.oTHrs;
    data['OT_S_Time'] = this.oTSTime;
    data['OT_E_Time'] = this.oTETime;
    data['EMP_NAME'] = this.eMPNAME;
    data['OT_APR_RMK'] = this.remark;
    data['OT_APR_HRS'] = this.apprHour;
    return data;
  }
}