class OtOverallResponse {
  String? attDat;
  double? rate;
  double? oTHrs;
  dynamic remark;
  String? sTime;
  String? eTime;
  String? status;

  OtOverallResponse(
      {
        this.attDat,
        this.rate,
        this.oTHrs,
        this.remark,
        this.sTime,
        this.eTime,
        this.status
      });

  OtOverallResponse.fromJson(Map<String, dynamic> json) {
    attDat = json['Att_Dat'];
    rate = json['OT_Rat_Cas'];
    oTHrs = json['OT_Hrs'];
    remark = json['OT_APR_RMK'];
    sTime = json['OT_S_Time'];
    eTime = json['OT_E_Time'];
    status = json['Stauts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Att_Dat'] = this.attDat;
    data['OT_Rat_Cas'] = this.rate;
    data['OT_Hrs'] = this.oTHrs;
    data['OT_APR_RMK'] = this.remark;
    data['OT_S_Time'] = this.sTime;
    data['OT_E_Time'] = this.eTime;
    data['Stauts'] = this.status;
    return data;
  }
}