import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart';
import 'package:jourapothole/core/utils/constants/app_text_styles.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
        title: const Text('Privacy Policy'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ListView.builder(
          itemCount: privacyData.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16.h,
              children: [
                const SizedBox(),
                Text(
                  "${index + 1}.  ${privacyData[index]["title"]!}",
                  style: AppTextStyles.bodyMedium,
                ),
                Text(privacyData[index]["body"]!),
              ],
            );
          },
        ),
      ),
    );
  }
}

const privacyData = [
  {
    "title": "Privacy Policy – Joura App",
    "body":
        "Effective Date: June 1\n\nJoura (“we,” “us,” or “our”) is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use the Joura mobile application (the “App”). By using the App, you consent to the practices described in this policy.",
  },
  {
    "title": "1. Information We Collect",
    "body":
        "1.1 Personal Information:\n- Email address (for account creation and support)\n- Location data (for reporting and viewing potholes)\n\n1.2 Non-Personal Information:\n- Device type and operating system\n- App usage data (e.g., frequency of reporting)\n\n1.3 Photos:\n- When voluntarily uploaded by users to accompany a report",
  },
  {
    "title": "2. How We Use Your Information",
    "body":
        "- To allow users to report and view road hazards\n- To display reports on a map and track status\n- To contact users for support, feedback, or verification\n- To analyze trends and improve the App",
  },
  {
    "title": "3. How We Share Your Information",
    "body":
        "We do not sell or rent your personal information. We may share data:\n- With municipalities or NGOs to support road maintenance efforts\n- With third-party service providers (e.g., cloud hosting, analytics)\n- As required by law or to protect rights and safety",
  },
  {
    "title": "4. Data Security",
    "body":
        "We use commercially reasonable measures to protect your information. However, no system can guarantee absolute security.",
  },
  {
    "title": "5. Account Deletion",
    "body":
        "Users may request account deletion at any time by emailing [Insert support email]. Requests are processed within 48 hours.",
  },
  {
    "title": "6. Children’s Privacy",
    "body":
        "The App is not intended for users under the age of 13. We do not knowingly collect data from children.",
  },
  {
    "title": "7. Your Rights",
    "body":
        "You have the right to:\n- Access the data we store about you\n- Request correction or deletion of your data\n- Withdraw consent at any time by deleting your account",
  },
  {
    "title": "8. Contact Us",
    "body":
        "If you have questions or concerns about this policy, please contact us at:\nEmail: mehdi.jaber.99@gmail.com\nPhone: +96171432362\n\nWe reserve the right to update this Privacy Policy from time to time. Any changes will be posted within the App and/or on our website.",
  },
];
