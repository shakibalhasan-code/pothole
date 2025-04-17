import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jourapothole/core/components/custom_button.dart';
import 'package:jourapothole/core/constants/app_colors.dart';
import 'package:jourapothole/core/constants/app_icons.dart';
import 'package:jourapothole/core/constants/app_text_styles.dart';
import 'package:jourapothole/features/auth/controller/auth_controller.dart';
import 'package:jourapothole/features/auth/view/otp_screen.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});
  final controller = Get.put(AuthController());
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
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        title: Text('Forget Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select which contact details should we use to reset your password.',
            ),
            SizedBox(height: 20.h),
            Text('Email', style: AppTextStyles.bodyMedium),
            SizedBox(height: 10.h),

            TextFormField(
              controller: controller.emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                contentPadding: contentPadding, // Added content padding
                prefixIcon: Padding(
                  // Added Padding around the icon
                  padding: iconPadding,
                  child: SvgPicture.asset(
                    AppIcons.emailIcon,
                    // color: AppColors.grayColor,
                    width: 20.w,
                    height: 20.h,
                    fit: BoxFit.contain,
                  ),
                ),

                // Removed suffixIconConstraints
              ),
            ),
            SizedBox(height: 20.h),
            CustomButton(
              buttonTitle: 'Continue',
              onTap:
                  () => Get.to(
                    () => OtpScreen(
                      email: controller.emailController.text,
                      isForgetPass: false,
                    ),
                  ),
            ),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }
}
