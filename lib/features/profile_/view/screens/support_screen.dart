import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  // --- Helper Methods for Launching URLs ---
  Future<void> _launchUrlHelper(String urlString, BuildContext context) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        _showErrorSnackbar('Could not launch $urlString');
      }
    } catch (e) {
      _showErrorSnackbar('Error launching URL: $e');
    }
  }

  void _showErrorSnackbar(String message) {
    // Ensure Get is initialized if you call this very early
    if (Get.isSnackbarOpen) return;
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
    );
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context); // Get theme data

    return Scaffold(
      // Use screen background color for consistency
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        elevation: 1.0, // Subtle elevation

        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          tooltip: 'Back',
        ),
        title: const Text(
          'Support',
          style: TextStyle(fontWeight: FontWeight.bold), // Bolder title
        ),
      ),
      body: Padding(
        // Use Padding instead of ListView if content is fixed
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          // Use Column for vertical arrangement
          crossAxisAlignment: CrossAxisAlignment.start, // Align title left
          children: [
            _buildContactCard(context),
            const Spacer(), // Pushes the footer text to the bottom
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets for Building Sections ---

  Widget _buildContactCard(BuildContext context) {
    // Use primary color for prominent icons in this section
    Color iconColor = AppColors.primaryColor;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: AppColors.primaryLightColor),
        borderRadius: BorderRadius.circular(10.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        // Only Email and Call options
        children: [
          _buildSupportTile(
            context,
            icon: Icons.email_rounded,
            iconColor: iconColor,
            title: 'Email Support',
            // --- !!! REPLACE WITH YOUR EMAIL !!! ---
            subtitle: 'mehdi.jaber.99@gmail.com',
            onTap:
                () => _launchUrlHelper(
                  'mailto:mehdi.jaber.99@gmail.com',
                  context,
                ),
          ),
          _buildDivider(), // Divider between email and call
          _buildSupportTile(
            context,
            icon: Icons.phone_rounded,
            iconColor: iconColor,
            title: 'Call Us',
            // --- !!! REPLACE WITH YOUR PHONE NUMBER !!! ---
            subtitle: '+971502759139',
            onTap: () => _launchUrlHelper('tel:+971502759139', context),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 12.0,
      ), // Adjusted padding
      leading: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: onTap,
    );
  }

  // Helper for consistent dividers
  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 72, // Indent past the icon+padding area
      endIndent: 20,
      color: Colors.grey[200],
    );
  }
}
