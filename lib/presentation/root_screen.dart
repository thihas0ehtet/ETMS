import 'package:etms/app/route/route_name.dart';
import 'package:etms/presentation/auth/login.dart';
import 'package:etms/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/datasources/shared_preference_helper.dart';
import 'controllers/profile_controller.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  ProfileController profileController = Get.find();
  @override
  void initState() {
    checkState();
    super.initState();
  }

  void checkState()async{
    SharedPreferenceHelper _sharedPrefs=  Get.find<SharedPreferenceHelper>();
    String companyCode= await _sharedPrefs.getCompanyCode;
    if(companyCode!='' && companyCode!='null'){
      if(profileController.imageBytes.value.isEmpty){
        await profileController.getMyPhoto();
      }
    } else{
      await Future.delayed(const Duration(seconds: 3));
    }
    Get.offAllNamed(RouteName.login);
  }
  @override
  Widget build(BuildContext context) {
    // return const SplashScreen();
    return const LoginScreen();
  }
}
