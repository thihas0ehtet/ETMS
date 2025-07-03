import 'package:etms/app/app_binding.dart';
import 'package:etms/app/route/route_name.dart';
import 'package:etms/presentation/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'app/config/config.dart';
import 'app/route/route_path.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppBinding().dependencies();

  // await SentryFlutter.init(
  //       (options) {
  //     options.dsn = 'https://5b9181bed0430a106bcfa820f4826b41@o1396938.ingest.sentry.io/4506531399925760';
  //     // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
  //     // We recommend adjusting this value in production.
  //     options.tracesSampleRate = 1.0;
  //   },
  //   appRunner: () => runApp(MyApp()),
  // );

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
      ..textColor = ColorResources.text500;

    return GetMaterialApp(
      title: 'ETMS',
      debugShowCheckedModeBanner: false,
      initialRoute: RouteName.splash,
      getPages: AppPages.routes,
      theme: ThemeConfig.lightTheme,
      home: const RootScreen(),
      initialBinding: AppBinding(),
      builder: EasyLoading.init(),
    );
  }
}
