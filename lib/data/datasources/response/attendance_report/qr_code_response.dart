class QRCodeResponse {
  int? qRID;
  String? qRCode;
  String? createdDate;
  double? fromLat;
  double? toLat;
  double? fromLang;
  double? toLang;

  QRCodeResponse(
      {this.qRID,
        this.qRCode,
        this.createdDate,
        this.fromLat,
        this.toLat,
        this.fromLang,
        this.toLang});

  QRCodeResponse.fromJson(Map<String, dynamic> json) {
    qRID = json['QR_ID'];
    qRCode = json['QR_Code'];
    createdDate = json['Created_Date'];
    fromLat = json['From_lat'];
    toLat = json['to_lat'];
    fromLang = json['from_lang'];
    toLang = json['to_lang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['QR_ID'] = this.qRID;
    data['QR_Code'] = this.qRCode;
    data['Created_Date'] = this.createdDate;
    data['From_lat'] = this.fromLat;
    data['to_lat'] = this.toLat;
    data['from_lang'] = this.fromLang;
    data['to_lang'] = this.toLang;
    return data;
  }
}