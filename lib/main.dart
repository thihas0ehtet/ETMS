import 'package:etms/app/app_binding.dart';
import 'package:etms/app/route/route_name.dart';
import 'package:etms/presentation/screens/auth/login.dart';
import 'package:etms/presentation/screens/root_screen.dart';
import 'package:etms/presentation/screens/splash_screen.dart';
import 'package:etms/presentation/test/test_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'app/config/config.dart';
import 'app/route/route_path.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppBinding().dependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 60
      ..backgroundColor = Colors.transparent
      ..indicatorColor = ColorResources.primary800
      ..boxShadow = <BoxShadow>[]
      ..indicatorType = EasyLoadingIndicatorType.circle
      ..textColor=ColorResources.text500
    ;

    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      initialRoute: RouteName.splash,
      getPages: AppPages.routes,
      theme: ThemeConfig.lightTheme,
      home: const RootScreen(),
      // home: LoginScreen(),
      // home: TestView(),
      initialBinding: AppBinding(),
      builder: EasyLoading.init(),
    );
  }
}
