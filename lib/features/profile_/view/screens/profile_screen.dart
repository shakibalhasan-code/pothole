import 'package:flutter/cupertino.dart'; // For CupertinoActivityIndicator
import 'package:flutter/material.dart'; // Import Material for CircularProgressIndicator
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart'; // Ensure these imports are correct
import 'package:jourapothole/core/utils/constants/app_icons.dart';
import 'package:jourapothole/core/utils/constants/app_images.dart';
import 'package:jourapothole/core/utils/constants/app_text_styles.dart';
import 'package:jourapothole/features/profile_/controller/profile_controller.dart'; // Ensure controller import is correct
import 'package:jourapothole/features/profile_/view/components/profile_componens.dart';
import 'package:jourapothole/features/profile_/view/screens/edit_profile.dart';
import 'package:jourapothole/features/profile_/view/screens/my_reports_screen.dart';
import 'package:jourapothole/features/profile_/view/screens/privacy_policy_screen.dart';
import 'package:jourapothole/features/profile_/view/screens/support_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  // Get.put() initializes the controller and calls onInit() which fetches data
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        // Optional: Add an AppBar for title
        title: Text('Profile'),
        backgroundColor: AppColors.primaryColor, // Or your desired color
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              // Wrap the part displaying dynamic profile data with Obx
              Obx(() {
                // Show a loading indicator while the controller is fetching data
                if (controller.isLoading.value) {
                  return const Expanded(
                    // Use Expanded if the Column is in a flex container
                    child: Center(
                      child:
                          CupertinoActivityIndicator(), // Or CircularProgressIndicator()
                    ),
                  );
                }

                final pickedImage = controller.pickedImage.value;
                final profileImageUrl =
                    controller
                        .profile
                        .value
                        .image; // Get the image URL from the fetched profile

                return Column(
                  mainAxisSize:
                      MainAxisSize.min, // Use min to not take full height
                  children: [
                    // ========>>>>>>> Image selector <<<<<<<<==========
                    InkWell(
                      onTap: () async {
                        await controller.pickImage();
                      },

                      child: Obx(() {
                        // Keep this inner Obx for pickedImage reactivity
                        return Stack(
                          children: [
                            SizedBox(
                              width: 100.w,
                              height: 100.h,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.r),
                                child:
                                    pickedImage !=
                                            null // Prioritize a newly picked image
                                        ? Image.file(
                                          pickedImage,
                                          fit: BoxFit.cover,
                                        )
                                        : (profileImageUrl != null &&
                                                profileImageUrl
                                                    .isNotEmpty // Use fetched image if available and not empty
                                            ? Image.network(
                                              profileImageUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const Icon(
                                                    Icons.error,
                                                    color: Colors.red,
                                                  ),
                                              loadingBuilder: (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  // Show loader while network image loads
                                                  child: CircularProgressIndicator(
                                                    value:
                                                        loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                loadingProgress
                                                                    .expectedTotalBytes!
                                                            : null,
                                                  ),
                                                );
                                              },
                                            )
                                            : const Icon(Icons.error)),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.w,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.edit, color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    SizedBox(height: 10.h), // Add some spacing
                    // ========>>>>>>> Name Email <<<<<<<<==========
                    Text(
                      controller.profile.value.fullName ??
                          'No Name', // Use fetched data, with fallback
                      style: AppTextStyles.bodyLarge,
                    ),
                    SizedBox(height: 5.h), // Add some spacing
                    Text(
                      controller.profile.value.email ??
                          'No Email', // Use fetched data, with fallback
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grayColor,
                      ),
                    ),
                    SizedBox(height: 20.h), // Add some spacing before divider
                  ],
                );
              }),

              // Divider and Profile Options are static/don't depend directly on the profile object's internal state changing after load
              const Divider(),
              SizedBox(height: 10.h), // Add some spacing after divider
              // ========>>>>>>> Profile Options <<<<<<<<==========
              _buildProfileOption(
                icon: const Icon(Icons.person_3_outlined),
                title: "Edit Profile",
                ontap:
                    () => Get.to(
                      () => EditProfile(),
                    ), // Use Get.to() with function
              ),

              _buildProfileOption(
                icon: const Icon(Icons.bar_chart),
                title: "My Reports",
                ontap:
                    () => Get.to(
                      () => MyReportsScreen(),
                    ), // Use Get.to() with function
              ),

              _buildProfileOption(
                icon: const Icon(Icons.support_agent),
                title: "Support",
                ontap:
                    () => Get.to(
                      () => SupportScreen(),
                    ), // Use Get.to() with function
              ),

              _buildProfileOption(
                icon: SvgPicture.asset(AppIcons.passwordIcon),
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

  // Moved _buildProfileOption outside the build method
  Widget _buildProfileOption({
    required Widget icon,
    required String title,
    required VoidCallback ontap,
    bool hasLast = true,
  }) {
    return GestureDetector(
      onTap: ontap,
      child: ListTile(
        leading: icon,
        title: Text(title),
        trailing:
            hasLast ? const Icon(Icons.chevron_right_outlined, size: 30) : null,
      ),
    );
  }
}
