import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jourapothole/core/components/custom_button.dart';
import 'package:jourapothole/core/constants/app_colors.dart';
import 'package:jourapothole/core/constants/app_icons.dart';
import 'package:jourapothole/core/constants/app_text_styles.dart';
import 'package:jourapothole/core/wrappers/body_wrapper.dart';
import 'package:jourapothole/features/auth/components/auth_card.dart';
import 'package:jourapothole/features/auth/controller/auth_controller.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  // Assuming AuthController has emailController, passwordController, formKey,
  // isRemembered (RxBool), isPasswordVisible (RxBool, initially true or false),
  // togglePasswordVisibility() method, and a signIn() method.
  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    // Define common padding for icons
    const iconPadding = EdgeInsets.all(12.0); // Adjust as needed
    // Define common content padding for text fields
    final contentPadding = EdgeInsets.symmetric(
      horizontal: 16.w,
      vertical: 14.h,
    ); // Adjust as needed

    return BodyWrapper(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.h), // Add some top spacing if needed
              Text("Create your Account", style: AppTextStyles.headerLarge),
              SizedBox(height: 24.h),

              Form(
                key: controller.signUpFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('First Name', style: AppTextStyles.bodyMedium),
                    SizedBox(height: 5.h),
                    TextFormField(
                      controller: controller.firstNameController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        // Add basic validation
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        if (!GetUtils.isEmail(value)) {
                          return 'Please enter a valid name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        contentPadding: contentPadding, // Added content padding
                        prefixIcon: Padding(
                          // Added Padding around the icon
                          padding: iconPadding,
                          child: SvgPicture.asset(
                            AppIcons.personIcon,
                            // color: AppColors.grayColor, // Consider using theme's icon color or a less prominent color
                            width: 20.w, // Ensure consistent icon size
                            height: 20.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                        // Removed prefixIconConstraints, Padding handles it
                      ),
                    ),
                    SizedBox(height: 15.h), // Increased spacing

                    Text('Last Name', style: AppTextStyles.bodyMedium),
                    SizedBox(height: 5.h),
                    TextFormField(
                      controller: controller.lastNameController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        // Add basic validation
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        if (!GetUtils.isEmail(value)) {
                          return 'Please enter a valid name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        contentPadding: contentPadding, // Added content padding
                        prefixIcon: Padding(
                          // Added Padding around the icon
                          padding: iconPadding,
                          child: SvgPicture.asset(
                            AppIcons.personIcon,
                            // color: AppColors.grayColor, // Consider using theme's icon color or a less prominent color
                            width: 20.w, // Ensure consistent icon size
                            height: 20.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                        // Removed prefixIconConstraints, Padding handles it
                      ),
                    ),
                    SizedBox(height: 15.h), // Increased spacing

                    Text('Email', style: AppTextStyles.bodyMedium),
                    SizedBox(height: 5.h),
                    TextFormField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        // Add basic validation
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
                        contentPadding: contentPadding, // Added content padding
                        prefixIcon: Padding(
                          // Added Padding around the icon
                          padding: iconPadding,
                          child: SvgPicture.asset(
                            AppIcons.emailIcon,
                            // color: AppColors.grayColor, // Consider using theme's icon color or a less prominent color
                            width: 20.w, // Ensure consistent icon size
                            height: 20.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                        // Removed prefixIconConstraints, Padding handles it
                      ),
                    ),
                    SizedBox(height: 15.h), // Increased spacing

                    Text('Phone', style: AppTextStyles.bodyMedium),
                    SizedBox(height: 5.h),
                    TextFormField(
                      controller: controller.phoneNumberController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        // Add basic validation
                        if (value == null || value.isEmpty) {
                          return 'Please enter your number';
                        }
                        if (!GetUtils.isEmail(value)) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        contentPadding: contentPadding, // Added content padding
                        prefixIcon: Padding(
                          // Added Padding around the icon
                          padding: iconPadding,
                          child: SvgPicture.asset(
                            AppIcons.callIcon,
                            // color: AppColors.grayColor, // Consider using theme's icon color or a less prominent color
                            width: 20.w, // Ensure consistent icon size
                            height: 20.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                        // Removed prefixIconConstraints, Padding handles it
                      ),
                    ),
                    SizedBox(height: 15.h), // Increased spacing

                    Text('Password', style: AppTextStyles.bodyMedium),
                    SizedBox(height: 5.h),
                    Obx(() {
                      // Obx needed here to react to password visibility changes
                      return TextFormField(
                        controller: controller.passwordController,
                        obscureText:
                            !controller
                                .isPasswordVisible
                                .value, // Control visibility
                        validator: (value) {
                          // Add basic validation
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            // Example minimum length
                            return 'Password must be at least 6 characters';
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
                              // color: AppColors.grayColor,
                              width: 20.w,
                              height: 20.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                          // Removed prefixIconConstraints
                          suffixIcon: IconButton(
                            // Make suffix icon tappable
                            padding: iconPadding, // Ensure consistent padding
                            icon: SvgPicture.asset(
                              controller.isPasswordVisible.value
                                  ? AppIcons
                                      .eyeVisibleIcon // Change icon based on state
                                  : AppIcons
                                      .eyeVisibleIcon, // Assuming you have this icon
                              // color: AppColors.grayColor,
                              width: 20.w,
                              height: 20.h,
                              fit: BoxFit.contain,
                            ),
                            onPressed: () {
                              // Call method in controller to toggle visibility
                              controller.togglePasswordVisibility();
                            },
                          ),
                          // Removed suffixIconConstraints
                        ),
                      );
                    }),
                    SizedBox(height: 10.h),
                    Row(
                      // Keep Checkbox and Forget Password row
                      children: [
                        Obx(() {
                          // Obx for the checkbox state
                          return Checkbox(
                            value: controller.isRemembered.value,
                            onChanged: (value) {
                              // Correctly update the value
                              controller.isRemembered.value = value ?? false;
                            },
                            checkColor: AppColors.whiteColor,
                            focusColor: AppColors.primaryColor,
                          );
                        }),
                        // Wrap Text with GestureDetector to make it tappable
                        GestureDetector(
                          onTap: () {
                            // Toggle checkbox when text is tapped
                            controller.isRemembered.toggle();
                          },
                          child: Text(
                            'I agree to the processing of Personal date',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grayColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25.h), // Increased spacing
              CustomButton(
                buttonTitle: 'SignUp',
                onTap: () {
                  // Call the sign-in method in the controller
                  // Optionally add form validation check
                  if (controller.formKey.currentState?.validate() ?? false) {
                    // controller.signIn();
                  }
                },
              ),
              SizedBox(height: 30.h), // Increased spacing
              Row(
                // Improved Divider Row
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColors.grayColor.withOpacity(0.5),
                      thickness: 1.h,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                    ), // Add space around text
                    child: Text(
                      'Or Continue With',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grayColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppColors.grayColor.withOpacity(0.5),
                      thickness: 1.h,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: AuthCard(iconPath: AppIcons.googleIcon),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Center(child: AuthCard(iconPath: AppIcons.fbIcon)),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Center(
                      child: AuthCard(iconPath: AppIcons.appleIcon),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Already have an account?'),
                  SizedBox(width: 5.w),
                  InkWell(
                    onTap: () => Get.back(),
                    child: Text(
                      'SignIn',
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
      ),
    );
  }
}
