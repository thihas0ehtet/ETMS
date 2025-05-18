import 'package:etms/app/config/font_family.dart';
import 'package:etms/data/datasources/shared_preference_helper.dart';
import 'package:etms/presentation/controllers/profile_controller.dart';
import 'package:etms/presentation/widgets/custom_button.dart';
import 'package:etms/presentation/widgets/custom_password_textform.dart';
import 'package:etms/presentation/widgets/custom_textform.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/config/color_resources.dart';
import '../../app/route/route_name.dart';
import '../../data/datasources/request/auth/login_data.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController authController = Get.find();
  ProfileController profileController = Get.find();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _companyCodeController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool hidePassword=true;
  bool showBioMetric = false;

  @override
  void initState() {
    // TODO: implement initState
    checkData();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _userNameController.dispose();
    _passwordController.dispose();
    _companyCodeController.dispose();
    super.dispose();
  }


  checkData() async{
    // await Future.delayed(const Duration(seconds: 3));
    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
    String companyCode= await _sharedPrefs.getCompanyCode;
    String sysId= await _sharedPrefs.getEmpSysId;
    bool enableFingerprint = await _sharedPrefs.getFingerprint;
    if(companyCode!='' && enableFingerprint){
      setState(() {
        showBioMetric=true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: ColorResources.white,
          body: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                )
            ),
            child:
            Stack(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 65,
                          height: 65,
                          child: Image(image: AssetImage('assets/images/dm_logo.png')),
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
                        SizedBox(height: 20,),

                        Form(
                            key: _key,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomTextForm(
                                  controller: _userNameController,
                                  hintText: 'User Name',
                                  validationText: 'enter user name',
                                  icon: FeatherIcons.user,
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
                                    validationText: 'enter password',
                                  onChange: (value){
                                      setState(() {
                                        _passwordController.text=value;
                                      });
                                  },
                                ),
                                SizedBox(height: 22,),
                                CustomTextForm(
                                  controller: _companyCodeController,
                                  hintText: 'Company Code',
                                  validationText: 'enter company code',
                                  svgIcon: 'assets/images/company.svg',
                                  isNumber: true,
                                ),
                                SizedBox(height: 25,),
                              ],
                            )
                        ),
                        CustomButton(
                          onTap: () async{
                            if(_key.currentState!.validate()){
                              // Get.offAllNamed(RouteName.dashboard);
                              LogInData loginData=LogInData(
                                  loginName: _userNameController.text,
                                  loginDevice: 'ML',
                                  password: _passwordController.text
                              );
                              String companyCode = _companyCodeController.text.toString();
                              bool loginSuccess = await authController.logIn(data: loginData, code: companyCode);
                              if(loginSuccess){
                                bool empMasterSuccess = await profileController.getEmpMaster();
                                if(empMasterSuccess){
                                  Get.offNamed(RouteName.dashboard);
                                }
                              }
                            }
                          },
                            text: 'Login',
                          icon: Icons.lock,
                        ),
                        showBioMetric ?
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child:  Container(
                                        width: context.width/2-40,
                                        height: 1,
                                        color: ColorResources.secondary900,
                                      )),
                                    Text('OR', style: latoMedium.copyWith(fontSize: 17),).paddingOnly(top: 25, bottom: 25, left: 10, right: 10),
                                    Expanded(
                                      child: Container(
                                        width: context.width/2-40,
                                        height: 1,
                                        color: ColorResources.secondary900,
                                      ),
                                    ),
                                  ],
                                ),

                                Container(
                                  // alignment: Alignment.center,
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle
                                    ),
                                    child: IconButton(
                                        onPressed: () async {
                                          await authController.biometricAuth();
                                        },
                                        icon: Icon(Icons.fingerprint, size: 30, color: ColorResources.primary500,)
                                    )
                                ),
                                Text('Login with Fingerprint / Face ID', style: latoMedium.copyWith(fontSize: 15),).paddingOnly(top: 10),
                              ],
                            )
                        :Container()

                      ],
                    ).paddingOnly(left: 26, right: 26),
                  ),
                ).paddingOnly(bottom: 35),
                Align(
                  alignment: Alignment.bottomCenter,
                  // alignment: Alignment.bottomCenter,
                  child: Text("Version 1.0.0"),
                ).paddingOnly(bottom: 10),
              ],
            ),
          ),
        ));
  }
}
