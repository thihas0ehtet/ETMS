class CompOffProposalRequest {
  String? reason;
  double? duration;
  int? status;

  CompOffProposalRequest(
      {
        this.reason,
        this.duration,
        this.status
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Reject_Reason'] = reason;
    data['Approved_Duration'] = duration;
    data['Request_Status'] = status;
    return data;
  }
}
