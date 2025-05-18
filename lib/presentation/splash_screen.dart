import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool start=false;
  bool isLoadingStart=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1),(){
      setState(() {
        start=true;
      });
    });
    Future.delayed(Duration(seconds: 2),(){
      setState(() {
        isLoadingStart=true;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      height: start ? 70.0 : 0 ,
                      width: start ? 70 : 0,
                      curve: Curves.fastOutSlowIn,
                      duration: Duration(seconds: 2),
                      child: Image(image: AssetImage('assets/images/dm_logo.png')),
                    ),
                    isLoadingStart==true?
                      SizedBox(
                        width: 80,
                        height: 50,
                        child:  Image.asset('assets/images/splash_loading.gif'),
                      ):SizedBox(height: 50,),
                  ],
                ),
                AnimatedContainer(
                  width: start ? 170 : 0,
                  curve: Curves.fastOutSlowIn,
                  duration: Duration(seconds: 2),
                  child:Image(image: AssetImage('assets/images/datamine.png'))
                ).paddingOnly(bottom: 50),
              ],
            )
          )
        )
    );
  }
}
