import 'package:etms/app/config/font_family.dart';
import 'package:etms/app/helpers/shared_preference_helper.dart';
import 'package:etms/data/datasources/request/login_data.dart';
import 'package:etms/presentation/widgets/custom_password_textform.dart';
import 'package:etms/presentation/widgets/custom_textform.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/config/api_constants.dart';
import '../../../app/config/color_resources.dart';
import '../../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController authController = Get.find();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _companyCodeController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool hidePassword=true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _userNameController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                )
            ),
            child: Stack(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 65,
                            height: 65,
                            child: Image(image: AssetImage('assets/images/logo.png')),
                          ),
                          Text("Welcome Back",style: latoSemibold
                              .copyWith(color: ColorResources.primary700, fontSize: 34),),
                          Row(
                            children: [
                              Text("to",style: latoSemibold
                                  .copyWith(color: ColorResources.primary700, fontSize: 34),).paddingOnly(right: 10),
                              SizedBox(
                                width: 145,
                                child: Image(image: AssetImage('assets/images/datamine.png')),
                              )
                            ],
                          ),
                          SizedBox(height: 40,),

                          Form(
                              key: _key,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomTextForm(
                                    controller: _userNameController,
                                    hintText: 'User Name',
                                    validationText: 'enter user name',
                                    icon: Icons.person,
                                  ),
                                  SizedBox(height: 22,),
                                  CustomPasswordTextForm(
                                      controller: _passwordController,
                                      hidePassword: hidePassword,
                                      onPress: (){
                                        setState(() {
                                          hidePassword=!hidePassword;
                                        });
                                      },
                                      hintText: 'Password',
                                      validationText: 'enter password'),
                                  SizedBox(height: 22,),
                                  CustomTextForm(
                                    controller: _companyCodeController,
                                    hintText: 'Company Code',
                                    validationText: 'enter company code',
                                    icon: Icons.home,
                                    isNumber: true,
                                  ),
                                  SizedBox(height: 25,),
                                ],
                              )
                          ),
                          InkWell(
                            onTap: (){
                              if(_key.currentState!.validate()){
                                LogInData loginData=LogInData(
                                    loginName: _userNameController.text,
                                    loginDevice: 'ML',
                                    password: _passwordController.text
                                );
                                String companyCode = _companyCodeController.text.toString();
                                SharedPreferenceHelper sharedData= Get.find<SharedPreferenceHelper>();
                                sharedData.saveCompanyCode(companyCode.toString());
                                Future.delayed(Duration(seconds: 1),(){
                                  authController.companyCode.value=companyCode;
                                  authController.companyCode.refresh();
                                  authController.logIn(data: loginData);
                                });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: ColorResources.primary500,
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                              ),
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              width: context.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.lock, size: 18, color: ColorResources.background,).paddingOnly(right: 10),
                                  Text("Login",style: latoRegular.copyWith(color: ColorResources.background),)
                                ],
                              ),
                            ),
                          )
                        ],
                      ).paddingOnly(left: 26, right: 26),
                    ),
                  ),
                ).paddingOnly(bottom: 35),
                Align(
                  alignment: Alignment.bottomCenter,
                  // alignment: Alignment.bottomCenter,
                  child: Text("Version 1.0"),
                ).paddingOnly(bottom: 10),
              ],
            ),
          ),
        ));
  }
}
