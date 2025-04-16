import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPageIndex = 0.obs;

  // --- REMOVE THESE KEYS ---
  // final formKey = GlobalKey<FormState>();             // REMOVED
  // final signUpFormKey = GlobalKey<FormState>();      // REMOVED
  // final passSetFormKey = GlobalKey<FormState>();     // REMOVED
  // ---

  ///feild_controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  final newPasswordController = TextEditingController();
  final rePasswordController = TextEditingController();

  final isRemembered = false.obs;
  final isPasswordVisible = false.obs;
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    newPasswordController.dispose();
    rePasswordController.dispose();
    super.dispose();
  }

  // You might add methods here later for actual sign-in/sign-up logic
  // e.g., Future<void> performSignIn() async { ... }
  // Future<void> performSignUp() async { ... }
  // Future<void> performSetPassword() async { ... }
}
