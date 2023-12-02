import 'package:etms/domain/entities/login_model.dart';

class LoginResponse implements LoginModel{
  int? userID;
  String? userName;
  String? loginName;
  String? password;
  int? status;
  bool? adminFlag;
  int? createdBy;
  String? createdDate;
  int? empSysID;
  int? userGroupID;
  String? logindevice;
  String? loginTime;
  String? logoutTime;

  LoginResponse(
      {this.userID,
        this.userName,
        this.loginName,
        this.password,
        this.status,
        this.adminFlag,
        this.createdBy,
        this.createdDate,
        this.empSysID,
        this.userGroupID,
        this.logindevice,
        this.loginTime,
        this.logoutTime});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    userID = json['User_ID'];
    userName = json['User_Name'];
    loginName = json['LoginName'];
    password = json['Password'];
    status = json['Status'];
    adminFlag = json['AdminFlag'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    empSysID = json['Emp_Sys_ID'];
    userGroupID = json['User_Group_ID'];
    logindevice = json['Logindevice'];
    loginTime = json['Login_Time'];
    logoutTime = json['Logout_Time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['User_ID'] = this.userID;
    data['User_Name'] = this.userName;
    data['LoginName'] = this.loginName;
    data['Password'] = this.password;
    data['Status'] = this.status;
    data['AdminFlag'] = this.adminFlag;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['Emp_Sys_ID'] = this.empSysID;
    data['User_Group_ID'] = this.userGroupID;
    data['Logindevice'] = this.logindevice;
    data['Login_Time'] = this.loginTime;
    data['Logout_Time'] = this.logoutTime;
    return data;
  }
}