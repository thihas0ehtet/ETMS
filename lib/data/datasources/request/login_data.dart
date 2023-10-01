class LogInData {
  String? loginName;
  String? loginDevice;
  String? password;

  LogInData(
      {
        this.loginName,
        this.loginDevice,
        this.password
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['LoginName'] = loginName;
    data['Logindevice'] = loginDevice;
    data['Password'] = password;
    return data;
  }
}
