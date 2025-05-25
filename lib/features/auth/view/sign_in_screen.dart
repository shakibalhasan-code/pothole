import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jourapothole/core/services/firebase_services.dart';
import 'package:jourapothole/core/utils/components/custom_button.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart';
import 'package:jourapothole/core/utils/constants/app_icons.dart';
import 'package:jourapothole/core/utils/constants/app_text_styles.dart';
import 'package:jourapothole/core/wrappers/body_wrapper.dart';
import 'package:jourapothole/features/auth/components/auth_card.dart';
import 'package:jourapothole/features/auth/controller/auth_controller.dart';
import 'package:jourapothole/features/auth/view/forget_password_screen.dart';
import 'package:jourapothole/features/auth/view/sign_up_screen.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  // Get the shared controller instance
  final AuthController controller = Get.find<AuthController>();
  // --- ADD LOCAL KEY ---
  final _formKey = GlobalKey<FormState>(); // <<< ADD THIS LINE
  final FirebaseServices firebaseServices = Get.find<FirebaseServices>();

  @override
  Widget build(BuildContext context) {
    const iconPadding = EdgeInsets.all(12.0);
    final contentPadding = EdgeInsets.symmetric(
      horizontal: 16.w,
      vertical: 14.h,
    );

    return BodyWrapper(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.h),
              Text("Login to your Account", style: AppTextStyles.headerLarge),
              SizedBox(height: 24.h),

              Form(
                // --- USE LOCAL KEY ---
                key: _formKey, // <<< UPDATE THIS LINE
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ... (Email TextFormField) ...
                    Text('Email', style: AppTextStyles.bodyMedium),
                    SizedBox(height: 5.h),
                    TextFormField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!GetUtils.isEmail(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        contentPadding: contentPadding,
                        prefixIcon: Padding(
                          padding: iconPadding,
                          child: SvgPicture.asset(
                            AppIcons.emailIcon,
                            width: 20.w,
                            height: 20.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    // ... (Password TextFormField) ...
                    Text('Password', style: AppTextStyles.bodyMedium),
                    SizedBox(height: 5.h),
                    Obx(() {
                      return TextFormField(
                        controller: controller.passwordController,
                        obscureText: !controller.isPasswordVisible.value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          contentPadding: contentPadding,
                          prefixIcon: Padding(
                            padding: iconPadding,
                            child: SvgPicture.asset(
                              AppIcons.passwordIcon,
                              width: 20.w,
                              height: 20.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                          suffixIcon: IconButton(
                            padding: iconPadding,
                            icon: SvgPicture.asset(
                              controller.isPasswordVisible.value
                                  ? AppIcons.eyeVisibleIcon
                                  : AppIcons.eyeInvisibleIcon,
                              width: 20.w,
                              height: 20.h,
                              fit: BoxFit.contain,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 10.h),
                    // ... (Remember Me Row) ...
                    Row(
                      children: [
                        Obx(() {
                          return Checkbox(
                            value: controller.isRemembered.value,
                            onChanged: (value) {
                              controller.isRemembered.value = value ?? false;
                            },
                            // ... other checkbox properties
                          );
                        }),
                        GestureDetector(
                          onTap: () => controller.isRemembered.toggle(),
                          child: Text(
                            'Remember Me',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grayColor,
                            ),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Get.to(() => ForgetPasswordScreen());
                          },
                          child: Text(
                            'Forget Password?',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.h),
              Obx(() {
                return controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                      buttonTitle: 'SignIn',
                      onTap: () {
                        // --- UPDATE VALIDATION CALL ---
                        if (_formKey.currentState?.validate() ?? false) {
                          print('Validation successful, navigating...');
                          controller.signInUser();
                        } else {
                          print('Validation failed');
                        }
                      },
                    );
              }),
              // SizedBox(height: 30.h),

              // SizedBox(height: 20.h),
              // // ... (Social Auth Cards Row) ...
              // Row(
              //   children: [
              //     Expanded(
              //       child: AuthCard(
              //         onTap: () async {
              //           await firebaseServices.signInGoogle();
              //         },
              //         iconPath: AppIcons.googleIcon,
              //       ),
              //     ),
              //     // SizedBox(width: 8.w),
              //     // Expanded(child: AuthCard(iconPath: AppIcons.fbIcon)),
              //     // SizedBox(width: 8.w),

              //     // Expanded(
              //     //   child: AuthCard(
              //     //     onTap: () async {
              //     //       await firebaseServices.signInApple();
              //     //     },
              //     //     iconPath: AppIcons.appleIcon,
              //     //   ),
              //     // ),
              //   ],
              // ),
              SizedBox(height: 30.h),
              // ... (SignUp Navigation Row) ...
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  SizedBox(width: 5.w),
                  InkWell(
                    onTap: () {
                      // Use off instead of to if you don't want SignIn to remain in stack
                      Get.to(() => SignUpScreen());
                    },
                    child: Text(
                      'SignUp',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h), // Add some bottom padding
            ],
          ),
        ),
      ),
    );
  }

  // Dummy icon path - replace with your actual eye hidden icon path
  static const String _eyeHiddenIconPath = AppIcons.eyeVisibleIcon; // Replace!
}
// Add a definition for AppIcons.eyeHiddenIcon in your AppIcons class if it doesn't exist
// class AppIcons {
//   // ... other icons
//   static const String eyeVisibleIcon = 'assets/icons/eye_visible.svg'; // Example
//   static const String eyeHiddenIcon = 'assets/icons/eye_hidden.svg';   // Example
// }