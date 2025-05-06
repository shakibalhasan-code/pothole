import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart';
import 'package:jourapothole/core/utils/constants/app_icons.dart';
import 'package:jourapothole/features/profile_/controller/profile_controller.dart';
import 'package:jourapothole/features/profile_/view/components/profile_componens.dart';
import 'package:jourapothole/features/profile_/view/screens/edit_profile.dart';
import 'package:jourapothole/features/profile_/view/screens/my_reports_screen.dart';
import 'package:jourapothole/features/profile_/view/screens/privacy_policy_screen.dart';
import 'package:jourapothole/features/profile_/view/screens/support_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              // Profile Header with Image, Name, Email
              Obx(
                () =>
                    controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                          children: [
                            // Profile Image - Centered
                            Center(
                              child: Stack(
                                children: [
                                  // Profile Image
                                  Hero(
                                    tag: 'profileImage',
                                    child: Container(
                                      width: 100.r,
                                      height: 100.r,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.greyColor
                                              .withOpacity(0.3),
                                          width: 2,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          50.r,
                                        ),
                                        child:
                                            controller.pickedImage.value != null
                                                ? Image.file(
                                                  controller.pickedImage.value!,
                                                  fit: BoxFit.cover,
                                                )
                                                : CachedNetworkImage(
                                                  imageUrl:
                                                      controller
                                                          .profile
                                                          .value
                                                          .image ??
                                                      'https://thispersondoesnotexist.com/',
                                                  fit: BoxFit.cover,
                                                  placeholder:
                                                      (
                                                        context,
                                                        url,
                                                      ) => const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const Icon(
                                                            Icons.person,
                                                            size: 50,
                                                            color:
                                                                AppColors
                                                                    .greyColor,
                                                          ),
                                                ),
                                      ),
                                    ),
                                  ),

                                  // Camera Icon for changing image
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.pickImage();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8.r),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: AppColors.whiteColor,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 16.h),

                            // User Name
                            Text(
                              controller.profile.value.fullName ?? "User Name",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 5.h),

                            // User Email
                            Text(
                              controller.profile.value.email ??
                                  "email@example.com",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.greyColor,
                              ),
                            ),
                          ],
                        ),
              ),

              SizedBox(height: 24.h),
              const Divider(),
              SizedBox(height: 10.h),

              // Profile Options
              _buildProfileOption(
                icon: Icon(Icons.person_outline, color: AppColors.primaryColor),
                title: "Edit Profile",
                ontap:
                    () => Get.to(
                      () => EditProfile(profileModel: controller.profile.value),
                    ),
              ),

              _buildProfileOption(
                icon: Icon(Icons.bar_chart, color: AppColors.primaryColor),
                title: "My Reports",
                ontap: () => Get.to(() => MyReportsScreen()),
              ),

              _buildProfileOption(
                icon: Icon(Icons.support_agent, color: AppColors.primaryColor),
                title: "Support",
                ontap: () => Get.to(() => SupportScreen()),
              ),

              _buildProfileOption(
                icon: SvgPicture.asset(
                  AppIcons.passwordIcon,
                  color: AppColors.primaryColor,
                ),
                title: "Privacy Policy",
                ontap: () => Get.to(() => PrivacyPolicyScreen()),
              ),

              _buildProfileOption(
                icon: SvgPicture.asset(
                  AppIcons.logoutIcon,
                  color: AppColors.redColor,
                ),
                title: "Logout",
                hasLast: false,
                ontap: () => ProfileComponents.showLogOutSheet(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required Widget icon,
    required String title,
    required VoidCallback ontap,
    bool hasLast = true,
  }) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          leading: SizedBox(width: 24.w, height: 24.h, child: icon),
          title: Text(
            title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
          trailing:
              hasLast
                  ? const Icon(
                    Icons.chevron_right_outlined,
                    color: AppColors.greyColor,
                  )
                  : null,
        ),
      ),
    );
  }
}
