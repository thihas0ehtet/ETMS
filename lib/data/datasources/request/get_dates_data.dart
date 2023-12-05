class GetDatesData {
  String? StartAMPM;
  String? EndAMPM;

  GetDatesData(
      {
        this.StartAMPM,
        this.EndAMPM
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StartAMPM'] = StartAMPM;
    data['EndAMPM'] = EndAMPM;
    return data;
  }
}
