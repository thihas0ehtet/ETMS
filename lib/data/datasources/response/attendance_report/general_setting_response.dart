class GeneralSettingResponse {
  String? keyword;
  String? keyValue;

  GeneralSettingResponse({this.keyword, this.keyValue});

  GeneralSettingResponse.fromJson(Map<String, dynamic> json) {
    keyword = json['Keyword'];
    keyValue = json['KeyValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Keyword'] = this.keyword;
    data['KeyValue'] = this.keyValue;
    return data;
  }
}