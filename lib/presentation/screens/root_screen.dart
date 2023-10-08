import 'package:etms/app/route/route_name.dart';
import 'package:etms/presentation/controllers/auth_controller.dart';
import 'package:etms/presentation/screens/auth/login.dart';
import 'package:etms/presentation/screens/menu/menu.dart';
import 'package:etms/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/helpers/shared_preference_helper.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  void initState() {
    checkState();
    super.initState();
  }

  void checkState()async{
    await Future.delayed(const Duration(seconds: 5));
    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
    String companyCode= await _sharedPrefs.getCompanyCode;
    if(companyCode==''){
      AuthController authController = Get.find();
      if(authController.companyCode.toString()==''){
        Get.toNamed(RouteName.login);
      }
      else{
        _sharedPrefs.saveCompanyCode(authController.companyCode.toString());
        Get.toNamed(RouteName.dashboard,arguments: MenuScreen());
      }
    }
    else{
      Get.toNamed(RouteName.dashboard,arguments: MenuScreen());
    }
  }
  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
