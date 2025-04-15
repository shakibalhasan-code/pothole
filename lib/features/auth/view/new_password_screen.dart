import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jourapothole/core/components/custom_button.dart';
import 'package:jourapothole/core/constants/app_colors.dart';
import 'package:jourapothole/core/constants/app_icons.dart';
import 'package:jourapothole/core/constants/app_text_styles.dart';
import 'package:jourapothole/features/auth/controller/auth_controller.dart';
import 'package:jourapothole/features/auth/view/sign_in_screen.dart';

class PassSetScreen extends StatelessWidget {
  PassSetScreen({super.key});
  final controller = Get.find<AuthController>();

  // Define common padding for icons
  static const iconPadding = EdgeInsets.all(12.0); // Adjust as needed
  // Define common content padding for text fields
  final contentPadding = EdgeInsets.symmetric(
    horizontal: 16.w,
    vertical: 14.h,
  ); // Adjust as needed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        title: Text('Set Password'),
      ),
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create your new password',
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.black),
                ),
                SizedBox(height: 10.h),
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Password', style: AppTextStyles.bodyMedium),
                      SizedBox(height: 5.h),
                      TextFormField(
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          // Add basic validation
                          if (value == null || value.isEmpty) {
                            return 'Please enter your new password';
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'Please enter re-your new password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          contentPadding:
                              contentPadding, // Added content padding
                          prefixIcon: Padding(
                            // Added Padding around the icon
                            padding: iconPadding,
                            child: SvgPicture.asset(
                              AppIcons.passwordIcon,
                              // color: AppColors.grayColor, // Consider using theme's icon color or a less prominent color
                              width: 20.w, // Ensure consistent icon size
                              height: 20.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                          // Removed prefixIconConstraints, Padding handles it
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text('Re-Password', style: AppTextStyles.bodyMedium),
                      SizedBox(height: 5.h),
                      TextFormField(
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          // Add basic validation
                          if (value == null || value.isEmpty) {
                            return 'Please enter your new password';
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'Please enter re-your new password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          contentPadding:
                              contentPadding, // Added content padding
                          prefixIcon: Padding(
                            // Added Padding around the icon
                            padding: iconPadding,
                            child: SvgPicture.asset(
                              AppIcons.passwordIcon,
                              // color: AppColors.grayColor, // Consider using theme's icon color or a less prominent color
                              width: 20.w, // Ensure consistent icon size
                              height: 20.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                          // Removed prefixIconConstraints, Padding handles it
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
                CustomButton(
                  buttonTitle: 'Continue',
                  onTap: () => Get.offAll(() => SignInScreen()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
