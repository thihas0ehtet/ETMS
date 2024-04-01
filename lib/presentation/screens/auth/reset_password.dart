import 'package:etms/data/datasources/request/auth/reset_password_data.dart';
import 'package:etms/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../app/config/config.dart';
import '../../../app/helpers/shared_preference_helper.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/my_app_bar.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  AuthController controller = Get.find();
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool hideOldPassword=true;
  bool hideNewPassword=true;
  bool hideConfirmPassword=true;

  Widget textFormWidget({required TextEditingController controller, required String label, required bool hidePassword, required VoidCallback onTap,
  required String validationText}){
    return  TextFormField(
      controller: controller,
      style:  latoRegular.copyWith(color: ColorResources.text500, fontSize: 15),
      obscureText: hidePassword?true:false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 15.0, top: 12.0, bottom: 12.0),
          labelText: label,
          labelStyle:  latoRegular.copyWith(color: ColorResources.text400, fontSize: 15),
          filled: true,
          fillColor: Colors.transparent,
          suffixIcon:
          controller.text.isNotEmpty?
          GestureDetector(
            onTap: ()=> onTap(),
            child: Container(
              margin: EdgeInsets.only(top: 13,bottom: 13),
              child: SvgPicture.asset(hidePassword?'assets/images/eye_close.svg':'assets/images/eye_open.svg',
                color: ColorResources.primary700,),
            ),
          ):null
      ),
      onChanged: (value){
        setState(() {
          controller.text=value;
        });
      },
      validator: (value) {
        if(value!.isEmpty ) {
          return validationText;
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: MyAppBar(title: 'Reset Password'),
          body: Form(
            key: _key,
            child: Column(
              children: [
                textFormWidget(controller: _oldPasswordController, label: 'Old Password', hidePassword: hideOldPassword,
                onTap: (){
                  hideOldPassword=!hideOldPassword;
                  setState(() {});
                }, validationText: 'enter old password'),
                SizedBox(height: 10,),
                textFormWidget(controller: _newPasswordController, label: 'New Password', hidePassword: hideNewPassword,
                    onTap: (){
                      hideNewPassword=!hideNewPassword;
                      setState(() {});
                    }, validationText: 'enter new password'),
                SizedBox(height: 10,),
                textFormWidget(controller: _confirmPasswordController, label: 'Confirm Password', hidePassword: hideConfirmPassword,
                    onTap: (){
                      hideConfirmPassword=!hideConfirmPassword;
                      setState(() {});
                    }, validationText: 'enter confirm password'),
                SizedBox(height: 30,),
                CustomButton(onTap: () async {
                  if(_key.currentState!.validate()){
                    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
                    String sysId= await _sharedPrefs.getEmpSysId;

                    ResetPasswordData data = ResetPasswordData(
                      empSysId: sysId,
                      password: _oldPasswordController.text,
                      newPassword: _newPasswordController.text,
                      confirmPassword: _confirmPasswordController.text
                    );
                    await controller.resetPassword(data);
                  }
                }, text: 'Reset Password',)
              ],
            ).paddingOnly(left: 20, right: 20),
          ),
        ));
  }
}
