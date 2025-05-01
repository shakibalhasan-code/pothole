import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jourapothole/core/utils/components/custom_button.dart';
import 'package:jourapothole/core/utils/constants/app_images.dart';
import 'package:jourapothole/core/utils/constants/app_text_styles.dart';
import 'package:jourapothole/core/utils/routes/app_pages.dart';
import 'package:jourapothole/features/auth/controller/auth_controller.dart';

class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({super.key});

  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: (index) {
              controller.currentPageIndex.value = index;
            },
            children: [
              // Add your onboarding pages here
              _buildOnBoarding(
                AppImages.splashScreen1,
                "Your Guide to Road Crack Management",
              ),
              // Individual Screen
              _buildOnBoarding(
                AppImages.splashScreen2,
                "Essential Training for Leak Detection & Control",
              ),
              // Individual Screen
              _buildOnBoarding(
                AppImages.splashScreen3,
                "Navigating the Manhole Problem",
              ),
            ],
          ),
          Positioned(
            bottom: 20.h,
            left: 0,
            right: 0,
            child: Obx(
              () => Column(
                spacing: 40.h,
                children: [
                  DotsIndicator(
                    // dots count == the number of individual screens
                    dotsCount: 3,
                    position: controller.currentPageIndex.value.toDouble(),
                    decorator: DotsDecorator(
                      size: const Size.square(9.0),
                      activeSize: const Size(18.0, 9.0),
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: CustomButton(
                      // currentIndex < 2 indicates we reached the last page
                      buttonTitle:
                          controller.currentPageIndex.value < 2
                              ? "Next"
                              : "Get Started",
                      onTap: () {
                        if (controller.currentPageIndex.value < 2) {
                          controller.pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        } else {
                          Get.offAllNamed(Routes.signIn);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // individual screen created with image and title
  SizedBox _buildOnBoarding(image, title) {
    return SizedBox.expand(
      child: Column(
        children: [
          Image.asset(
            image,
            height: Get.height / 2,
            width: double.maxFinite,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Text(
              title,
              style: AppTextStyles.headerLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
