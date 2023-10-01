import 'package:etms/app/app_binding.dart';
import 'package:etms/app/route/route_name.dart';
import 'package:etms/presentation/screens/auth/login.dart';
import 'package:etms/presentation/screens/dashboard.dart';
import 'package:etms/presentation/screens/splash_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static const initial = RouteName.splash;

  static final routes = [
    GetPage(
      name: RouteName.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
        name: RouteName.login,
        page: () => const LoginScreen()
    ),
    GetPage(
        name: RouteName.dashboard,
        page: () => const DashboardScreen()
    ),
  ];
}