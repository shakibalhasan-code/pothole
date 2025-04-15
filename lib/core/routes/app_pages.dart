import 'package:get/get.dart';
import 'package:jourapothole/features/auth/binding/auth_binding.dart';
import 'package:jourapothole/features/auth/view/forget_password_screen.dart';
import 'package:jourapothole/features/auth/view/new_password_screen.dart';
import 'package:jourapothole/features/boarding/views/on_boarding_screen.dart';
import 'package:jourapothole/features/auth/view/otp_screen.dart';
import 'package:jourapothole/features/auth/view/sign_in_screen.dart';
import 'package:jourapothole/features/auth/view/sign_up_screen.dart';
import 'package:jourapothole/features/boarding/views/splash_screen.dart';
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
    GetPage(
      name: Routes.onBoarding,
      page: () => OnBoardingScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.signIn,
      page: () => SignInScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.signUp,
      page: () => SignUpScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.forgetPassword,
      page: () => ForgetPasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.newPassword,
      page: () => PassSetScreen(),
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
