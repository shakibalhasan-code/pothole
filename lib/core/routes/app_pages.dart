import 'package:get/get.dart';
import 'package:jourapothole/features/auth/binding/auth_binding.dart';
import 'package:jourapothole/features/auth/view/splash_screen.dart';
import 'package:jourapothole/features/home/bindings/home_binding.dart';
import 'package:jourapothole/features/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    // Auth Features
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
      binding: AuthBinding(),
    ),
    // Home Features
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
