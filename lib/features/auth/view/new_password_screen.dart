import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jourapothole/core/utils/components/custom_button.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart';
import 'package:jourapothole/core/utils/constants/app_icons.dart';
import 'package:jourapothole/core/utils/constants/app_text_styles.dart';
import 'package:jourapothole/features/auth/controller/auth_controller.dart';
import 'package:jourapothole/features/auth/view/sign_in_screen.dart';

class PassSetScreen extends StatelessWidget {
  PassSetScreen({super.key});
  final controller = Get.find<AuthController>();
  // --- ADD LOCAL KEY ---
  final _passSetFormKey = GlobalKey<FormState>(); // <<< ADD THIS LINE

  static const iconPadding = EdgeInsets.all(12.0);
  final contentPadding = EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ), // Or use themed back icon
        ),
        title: Text(
          'Set New Password', // Title more descriptive
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.black,
          ), // Example style
        ),
        backgroundColor: AppColors.whiteColor, // Match body
        elevation: 0, // Flat design
        centerTitle: true, // Center title
      ),
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              // --- USE LOCAL KEY ---
              key: _passSetFormKey, // <<< UPDATE THIS LINE
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center vertically
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    // Center the title text
                    child: Text(
                      'Create Your New Password',
                      style: AppTextStyles.bodyMedium, // Make it stand out more
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    // Center the description text
                    child: Text(
                      'Your new password must be different from previously used passwords.', // Add description
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grayColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 30.h), // Increased spacing
                  /// New Password
                  Text('Password', style: AppTextStyles.bodyMedium),
                  SizedBox(height: 5.h),
                  // Use Obx for visibility toggle if needed later
                  Obx(() {
                    return TextFormField(
                      controller: controller.newPasswordController,
                      obscureText:
                          !controller
                              .isPasswordVisible
                              .value, // Use controller state
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        // Add more complex validation if needed (uppercase, number, symbol)
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter new password', // Update hint
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
                          // Add visibility toggle
                          padding: iconPadding,
                          icon: SvgPicture.asset(
                            AppIcons.eyeVisibleIcon,
                            width: 20.w,
                            height: 20.h,
                            fit: BoxFit.contain,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 15.h),

                  /// Confirm Password
                  Text(
                    'Confirm Password',
                    style: AppTextStyles.bodyMedium,
                  ), // Changed label
                  SizedBox(height: 5.h),
                  // Use Obx for visibility toggle if needed later
                  Obx(() {
                    return TextFormField(
                      controller: controller.rePasswordController,
                      obscureText:
                          !controller
                              .isPasswordVisible
                              .value, // Use controller state
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        // Add more complex validation if needed (uppercase, number, symbol)
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter new password', // Update hint
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
                          // Add visibility toggle
                          padding: iconPadding,
                          icon: SvgPicture.asset(
                            AppIcons.eyeVisibleIcon,
                            width: 20.w,
                            height: 20.h,
                            fit: BoxFit.contain,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 32.h),

                  Obx(() {
                    return
                    /// Continue Button
                    controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                          onTap: () {
                            if (_passSetFormKey.currentState!.validate()) {
                              controller.resetPassword();
                            }
                          },
                          buttonTitle: 'Continue',
                        );
                  }),

                  SizedBox(height: 20.h), // Add some bottom padding
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
