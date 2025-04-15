import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPageIndex = 0.obs;

  final formKey = GlobalKey<FormState>();
  final signUpFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isRemembered = false.obs;
  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}
