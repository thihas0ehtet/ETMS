class RelationTypeResponse {
  int? relationID;
  String? relationName;

  RelationTypeResponse({this.relationID, this.relationName});

  RelationTypeResponse.fromJson(Map<String, dynamic> json) {
    relationID = json['Relation_ID'];
    relationName = json['Relation_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Relation_ID'] = this.relationID;
    data['Relation_Name'] = this.relationName;
    return data;
  }
}