import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jourapothole/core/config/api_endpoints.dart';
import 'package:jourapothole/core/helpers/pref_helper.dart'; // This will now use the corrected file
import 'package:jourapothole/core/helpers/widget_helper.dart';
import 'package:jourapothole/core/models/profile_model.dart'; // Unused in provided methods, but kept
import 'package:jourapothole/core/services/api_services.dart'; // Assuming this is correctly implemented
import 'package:jourapothole/core/utils/constants/app_icons.dart';
import 'package:jourapothole/core/utils/utils.dart'; // Assuming this defines Utils.token
import 'package:jourapothole/features/auth/view/new_password_screen.dart';
import 'package:jourapothole/features/auth/view/otp_screen.dart';
import 'package:jourapothole/features/auth/view/sign_in_screen.dart';
import 'package:jourapothole/features/main_tab/main_parent_screen.dart'; // Assuming this screen exists

class AuthController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPageIndex = 0.obs;

  final isLoading = false.obs;

  ///feild_controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController =
      TextEditingController(); // Unused in provided methods

  final newPasswordController =
      TextEditingController(); // Used in signUp validation
  final rePasswordController =
      TextEditingController(); // Used in signUp validation

  var otp = ''.obs;
  var tempTokenReset = ''.obs;

  final isRemembered = false.obs; // Unused in provided methods
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
    pageController.dispose(); // Dispose pageController too
    super.dispose();
  }

  Future<void> signInUser() async {
    try {
      isLoading.value = true;

      // Add basic validation
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        GlobWidgetHelper.showToast(
          isSuccess: false,
          message: "Email and password cannot be empty.",
        );
        return; // Stop execution
      }

      final data = {
        'email': emailController.text.trim(), // Trim whitespace
        'password': passwordController.text,
      };

      // Assume ApiServices returns http.Response
      final response = await ApiServices.postData(
        body: data,
        url: ApiEndpoints.login, // Use the correct login endpoint
        // headers: {'Authorization': 'Bearer your_token'}, // Add headers if needed later
      );

      // Check status code AFTER the API call returns the http.Response
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final body = jsonDecode(response.body);
        // Check if 'data' and 'accessToken' exist before accessing
        if (body != null &&
            body['data'] != null &&
            body['data']['accessToken'] != null) {
          final token = body['data']['accessToken'];
          // TODO: Store auth token/user data from responseBody
          await PrefHelper.saveData(Utils.token, token); // Await saveData
          printInfo(info: '=====>>>>> token: $token');
          Get.offAll(() => const MainParentScreen());
        } else {
          // Handle case where response body structure is unexpected
          GlobWidgetHelper.showToast(
            isSuccess: false,
            message: "Login failed: Invalid response from server.",
          );
          printError(info: 'Login failed: Invalid response body: $body');
        }
      } else {
        printError(
          info:
              'Login failed with status: ${response.statusCode}. Response body: ${response.body}',
        );
        // The ApiServices._handleResponseFeedback should ideally show a toast for API errors
        // If not, you might add a generic error toast here.
        // Example: GlobWidgetHelper.showToast(isSuccess: false, message: "Login failed. Please try again.");
      }
    } catch (e) {
      // This catch block handles network errors or exceptions during processing
      printError(info: 'Login Error: $e');
      // ApiServices catch block should show a network error toast.
      // If not, you might add a generic network error toast here.
      // Example: GlobWidgetHelper.showToast(isSuccess: false, message: "Network error. Please check your connection.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp() async {
    try {
      isLoading.value = true;

      // Add basic validation
      if (firstNameController.text.isEmpty ||
          lastNameController.text.isEmpty ||
          emailController.text.isEmpty ||
          passwordController.text.isEmpty) {
        GlobWidgetHelper.showToast(
          isSuccess: false,
          message: "All fields are required for signup.",
        );
        return; // Stop execution
      }

      final data = {
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text, // Use the new password for signup
        // Include other fields like phoneNumber if required by API
      };

      // Assume ApiServices now returns http.Response
      final response = await ApiServices.postData(
        body: data,
        url: ApiEndpoints.signUp, // Use the correct signup endpoint
      );

      // Check status code AFTER the API call returns the http.Response
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Get.back();
        // TODO: Decide the next step - auto-login? Show success screen? Navigate to login?
        GlobWidgetHelper.showToast(
          isSuccess: true,
          message: "Signup successful!",
        );

        pageController.animateToPage(
          0, // Assuming 0 is the login page index
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        // Clear signup fields after successful signup (optional)
        firstNameController.clear();
        lastNameController.clear();
        emailController.clear();
        passwordController.clear(); // If used for signup
        newPasswordController.clear();
        rePasswordController.clear();
      } else {
        // Handle non-200 status codes
        printError(
          info:
              'Signup failed with status: ${response.statusCode}. Response body: ${response.body}',
        );
        // ApiServices._handleResponseFeedback should ideally show a toast for API errors
        // If not, you might add a generic error toast here.
        // Example: GlobWidgetHelper.showToast(isSuccess: false, message: "Signup failed. Please try again.");
      }
    } catch (e) {
      printError(info: 'Signup Error: $e');
      // ApiServices catch block should show a network error toast.
      // If not, you might add a generic network error toast here.
      // Example: GlobWidgetHelper.showToast(isSuccess: false, message: "Network error. Please check your connection.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgetPassWord() async {
    try {
      isLoading.value = true;
      final data = {'email': emailController.text};
      final response = await ApiServices.postData(
        body: data,
        url: ApiEndpoints.forgotPassword,
      );
      if (response.statusCode == 200) {
        Get.to(
          () => OtpScreen(email: emailController.text, isForgetPass: false),
        );
      }
    } catch (e) {
      printInfo(info: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOTP() async {
    try {
      isLoading.value = true;
      final data = {'email': emailController.text};
      final response = await ApiServices.postData(
        body: data,
        url: ApiEndpoints.forgotPassword,
      );
      if (response.statusCode == 200) {}
    } catch (e) {
      printInfo(info: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    try {
      isLoading.value = true;
      final data = {'email': emailController.text, 'oneTimeCode': otp.value};
      isLoading.value = true;
      final response = await ApiServices.postData(
        body: data,
        url: ApiEndpoints.verifyEmail,
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final tempToken = body['data'];
        tempTokenReset.value = tempToken;
        await PrefHelper.saveData(Utils.tempToken, tempToken);
        printError(info: '=========>>>>>>>> ${tempTokenReset.value}');

        Get.to(PassSetScreen());
      }
    } catch (e) {
      printError(info: '===========>>>>>>>> $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    print('=== resetPassword called ===');
    try {
      isLoading.value = true;

      final token = await PrefHelper.getData(Utils.token);
      print('Token: $token');

      final data = {
        'newPassword': newPasswordController.text,
        'confirmPassword': rePasswordController.text,
      };

      print('Sending Data: $data');

      final response = await ApiServices.postData(
        body: data,
        url: ApiEndpoints.changePassword,
        headers: {'Authorization': tempTokenReset.value},
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        Get.offAll(() => SignInScreen());
      } else {
        Get.snackbar('Failed', 'Check your credentials or try again');
      }
    } catch (e) {
      printError(info: 'RESET ERROR: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
