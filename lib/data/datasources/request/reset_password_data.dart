class ForgotPasswordData {
  String? empSysId;
  String? password;
  String? newPassword;
  int? confirmPassword;

  ForgotPasswordData(
      {
        this.empSysId,
        this.password,
        this.newPassword,
        this.confirmPassword
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Emp_Sys_ID'] = empSysId;
    data['Password'] = password;
    data['NewPassword'] = newPassword;
    data['ConfirmPassword'] = confirmPassword;
    return data;
  }
}
