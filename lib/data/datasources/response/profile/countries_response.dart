class CountriesResponse {
  int? countryID;
  String? countryName;
  String? nationality;
  String? cOUNTRYCODE;

  CountriesResponse(
      {this.countryID, this.countryName, this.nationality, this.cOUNTRYCODE});

  CountriesResponse.fromJson(Map<String, dynamic> json) {
    countryID = json['Country_ID'];
    countryName = json['Country_Name'];
    nationality = json['Nationality'];
    cOUNTRYCODE = json['COUNTRY_CODE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Country_ID'] = this.countryID;
    data['Country_Name'] = this.countryName;
    data['Nationality'] = this.nationality;
    data['COUNTRY_CODE'] = this.cOUNTRYCODE;
    return data;
  }
}