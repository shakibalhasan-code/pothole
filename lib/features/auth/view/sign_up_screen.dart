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

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final AuthController controller = Get.find<AuthController>();
  // --- ADD LOCAL KEY ---
  final _signUpFormKey = GlobalKey<FormState>(); // <<< ADD THIS LINE
  final firebaseServices = Get.find<FirebaseServices>();

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
              Text("Create your Account", style: AppTextStyles.headerLarge),
              SizedBox(height: 24.h),

              Form(
                // --- USE LOCAL KEY ---
                key: _signUpFormKey, // <<< UPDATE THIS LINE
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // --- First Name ---
                    Text('First Name', style: AppTextStyles.bodyMedium),
                    SizedBox(height: 5.h),
                    TextFormField(
                      controller: controller.firstNameController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          // Use trim()
                          return 'Please enter your first name';
                        }
                        // Removed email validation on name field
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your first name', // Update hint text
                        contentPadding: contentPadding,
                        prefixIcon: Padding(
                          padding: iconPadding,
                          child: SvgPicture.asset(
                            AppIcons.personIcon,
                            width: 20.w,
                            height: 20.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),

                    // --- Last Name ---
                    Text('Last Name', style: AppTextStyles.bodyMedium),
                    SizedBox(height: 5.h),
                    TextFormField(
                      controller: controller.lastNameController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          // Use trim()
                          return 'Please enter your last name';
                        }
                        // Removed email validation on name field
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your last name', // Update hint text
                        contentPadding: contentPadding,
                        prefixIcon: Padding(
                          padding: iconPadding,
                          child: SvgPicture.asset(
                            AppIcons.personIcon,
                            width: 20.w,
                            height: 20.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),

                    // --- Email ---
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

                    // --- Phone ---
                    Text('Phone', style: AppTextStyles.bodyMedium),
                    SizedBox(height: 5.h),
                    TextFormField(
                      controller: controller.phoneNumberController,
                      keyboardType: TextInputType.phone, // Use phone type
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (!GetUtils.isPhoneNumber(value)) {
                          // Use phone validation
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your phone number', // Update hint text
                        contentPadding: contentPadding,
                        prefixIcon: Padding(
                          padding: iconPadding,
                          child: SvgPicture.asset(
                            AppIcons.callIcon, // Assuming callIcon is for phone
                            width: 20.w,
                            height: 20.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),

                    // --- Password ---
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

                    // --- Agreement Checkbox ---
                    Row(
                      children: [
                        Obx(() {
                          return Checkbox(
                            value:
                                controller
                                    .isRemembered
                                    .value, // Reuse? Or add a new RxBool like 'agreedToTerms'?
                            onChanged: (value) {
                              // Maybe controller.agreedToTerms.value = value ?? false;
                              controller.isRemembered.value =
                                  value ?? false; // Update if reusing
                            },
                            // ... other checkbox properties
                          );
                        }),
                        Expanded(
                          // Wrap text to prevent overflow
                          child: GestureDetector(
                            onTap: () {
                              // controller.agreedToTerms.toggle();
                              controller.isRemembered
                                  .toggle(); // Update if reusing
                            },
                            child: Text(
                              'I agree to the processing of Personal data', // Consider linking to policy
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.grayColor,
                              ),
                              overflow:
                                  TextOverflow.ellipsis, // Handle long text
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
                    ? Center(child: CircularProgressIndicator())
                    : CustomButton(
                      buttonTitle: 'SignUp',
                      onTap: () {
                        // --- UPDATE VALIDATION CALL ---
                        if (_signUpFormKey.currentState?.validate() ?? false) {
                          print('Sign up validation successful');
                          // Maybe navigate to OTP screen or directly to sign in/home after success
                          controller.signUp();
                        } else {
                          print('Sign up validation failed');
                        }
                      },
                    );
              }),
              SizedBox(height: 30.h),
              // ... (Or Continue With Row) ...
              Row(/* ... Divider ... */),
              SizedBox(height: 20.h),
              // ... (Social Auth Cards Row) ...
              Row(
                children: [
                  Expanded(
                    child: AuthCard(
                      onTap: () async {
                        await firebaseServices.signInGoogle();
                      },
                      iconPath: AppIcons.googleIcon,
                    ),
                  ),
                  // SizedBox(width: 8.w),
                  // Expanded(child: AuthCard(iconPath: AppIcons.fbIcon)),
                  SizedBox(width: 8.w),

                  Expanded(
                    child: AuthCard(
                      onTap: () async {
                        await firebaseServices.signInApple();
                      },
                      iconPath: AppIcons.appleIcon,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              // ... (SignIn Navigation Row) ...
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?'),
                  SizedBox(width: 5.w),
                  InkWell(
                    onTap:
                        () =>
                            Get.back(), // Go back to the previous screen (likely SignIn)
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
