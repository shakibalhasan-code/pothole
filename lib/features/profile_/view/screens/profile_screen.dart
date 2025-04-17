import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jourapothole/core/constants/app_colors.dart';
import 'package:jourapothole/core/constants/app_icons.dart';
import 'package:jourapothole/core/constants/app_text_styles.dart';
import 'package:jourapothole/features/profile_/controller/profile_controller.dart';
import 'package:jourapothole/features/profile_/view/components/profile_componens.dart';
import 'package:jourapothole/features/profile_/view/screens/edit_profile.dart';
import 'package:jourapothole/features/profile_/view/screens/privacy_policy_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              // ========>>>>>>> Image selector <<<<<<<<==========
              InkWell(
                onTap: () async {
                  await controller.pickImage();
                },
                child: Obx(() {
                  final pickedImage = controller.pickedImage.value;
                  final profileImage =
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/800px-Placeholder_view_vector.svg.png';

                  return Stack(
                    children: [
                      SizedBox(
                        width: 100.w,
                        height: 100.h,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.r),
                          child:
                              pickedImage != null
                                  ? Image.file(pickedImage, fit: BoxFit.cover)
                                  : Image.network(
                                    profileImage,
                                    fit: BoxFit.cover,
                                  ),
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
              // ========>>>>>>> Name Email <<<<<<<<==========
              Text('John David', style: AppTextStyles.bodyLarge),
              Text(
                'john@gmail.com',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grayColor,
                ),
              ),
              Divider(),
              // ========>>>>>>> Profile Options <<<<<<<<==========
              _buildProfileOption(
                icon: Icon(Icons.person_3_outlined),
                title: "Edit Profile",
                ontap: () => Get.to(EditProfile()),
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

  Widget _buildProfileOption({icon, title, ontap, hasLast = true}) {
    return GestureDetector(
      onTap: ontap,
      child: ListTile(
        leading: icon,
        title: Text(title),
        trailing: hasLast ? Icon(Icons.chevron_right_outlined, size: 30) : null,
      ),
    );
  }
}
