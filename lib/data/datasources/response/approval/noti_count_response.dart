class NotiCountResponse {
  String? type;
  int? count;

  NotiCountResponse({this.type, this.count});

  NotiCountResponse.fromJson(Map<String, dynamic> json) {
    type = json['TYPE'];
    count = json['COUNT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TYPE'] = this.type;
    data['COUNT'] = this.count;
    return data;
  }
}