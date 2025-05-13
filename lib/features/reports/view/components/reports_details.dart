import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jourapothole/core/helpers/pref_helper.dart';
import 'package:jourapothole/core/models/pothole_model.dart';
import 'package:jourapothole/core/utils/components/confirmation_dialog_view.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart';
import 'package:jourapothole/core/utils/constants/app_text_styles.dart';
import 'package:jourapothole/core/utils/utils.dart';
import 'package:jourapothole/features/reports/controllers/report_controller.dart';
import 'package:jourapothole/features/reports/view/components/video_player_view.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportProblemBottomSheet extends StatelessWidget {
  final PotholeModel report;

  ReportProblemBottomSheet({super.key, required this.report});

  final reportsController = Get.put(ReportController());

  Future<void> _showConfirmationDialog(BuildContext context) async {
    final result = await showDialog<DialogAction>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss
      builder: (BuildContext dialogContext) {
        return const ConfirmationDialog(
          title: 'Close Report Details?',
          message:
              'Are you sure you want to close this view? '
              'Please confirm if the issue has been resolved.',
          noButtonText: 'No',
          yesButtonText: 'Yes, Resolved',
          dontKnowButtonText: "I Don't Know",
        );
      },
    );

    // Handle the dialog result
    if (result != null) {
      switch (result) {
        case DialogAction.no:
          print('User selected: No');
          await reportsController.verifyReport(id: report.id, status: 'No');
          break;
        case DialogAction.yes:
          print('User selected: Yes, Resolved');
          await reportsController.verifyReport(id: report.id, status: 'Yes');
          // Potentially update report status and then close

          break;
        case DialogAction.dontKnow:
          print("User selected: I Don't Know");
          await reportsController.verifyReport(
            id: report.id,
            status: 'I don\'t Know',
          );

          // Maybe keep the bottom sheet open or take other action
          break;
      }
    } else {
      // Dialog was dismissed by other means (e.g. back button on Android if barrierDismissible true)
      print('Dialog dismissed without selection');
    }
  }

  Future<bool> getVerifyList() async {
    for (var user in report.verifiedBy) {
      if (user == await PrefHelper.getData(Utils.userId)) {
        printInfo(info: 'User is verified');
        reportsController.isVerified.value = true;
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor =
        report.status == 'open' ? AppColors.redColor : Colors.green;
    String? imageUrl = report.images.isNotEmpty ? report.images.first : null;
    String descriptionToDisplay =
        report.description.isNotEmpty
            ? report.description
            : 'No detailed description provided for this report.';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                // Added Expanded to prevent overflow if title is long
                child: Text(
                  'Report Details: ${report.issue}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis, // Handle long text
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.redColor),
                onPressed: () {
                  // Instead of Get.back(), show the custom dialog
                  getVerifyList().then((isVerified) {
                    if (isVerified) {
                      Get.back();
                      // Get.snackbar(
                      //   'Info',
                      //   'You have already verified this report.',
                      //   snackPosition: SnackPosition.BOTTOM,
                      //   backgroundColor: Colors.yellow[100],
                      //   colorText: Colors.black,
                      // );
                      printError(
                        info: 'You have already verified this report.',
                      );
                    } else {
                      _showConfirmationDialog(context);
                    }
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          FutureBuilder<bool>(
            future: getVerifyList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink(); // Show nothing while loading
              } else if (snapshot.hasData && snapshot.data == true) {
                return const Text(
                  'You have already verified this report.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          SizedBox(height: 8.h),
          // Display image dynamically
          InkWell(
            onTap: () {
              if (imageUrl != null) {
                final imageProvider = Image.network(imageUrl).image;
                showImageViewer(
                  context,
                  imageProvider,
                  immersive: false,
                ); // immersive: false is often preferred for bottom sheets
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:
                  imageUrl != null
                      ? Image.network(
                        imageUrl, // Removed imageUrl! as it's already checked
                        height: 150.h, // Used .h from screenutil
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              height: 150.h,
                              color: Colors.grey[300],
                              child: const Center(
                                child: Text('Failed to load image'),
                              ),
                            ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 150.h,
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                              ),
                            ),
                          );
                        },
                      )
                      : Container(
                        height: 150.h,
                        color: Colors.grey[300],
                        child: const Center(child: Text('No image available')),
                      ),
            ),
          ),
          const SizedBox(height: 16),

          // Video display section
          if (report.videos.isNotEmpty) ...[
            // Removed the extra SizedBox(height: 16) as there's one above
            Text(
              'Videos:',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: report.videos.length,
                itemBuilder: (context, index) {
                  String videoUrl = report.videos[index];
                  return InkWell(
                    onTap: () {
                      Get.to(
                        () => VideoPlayerViewGetx(videoUrl: videoUrl),
                      ); // Pass widget instance
                      print('Play video from URL: $videoUrl');
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      // height: 70.h, // Height is managed by parent SizedBox
                      width: 150.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 50.w,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16), // Added SizedBox after video list
          ],

          // Issue details and status
          // const SizedBox(height: 16), // Removed as videos section adds one if present
          Text(
            'Issue type : ${report.issue}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            'Severity Level : ${report.severityLevel}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            'Address : ${report.location.address}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Status : ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    report.status,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryLightColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: InkWell(
                  onTap: () async {
                    final Uri mapUrl = Uri.parse(
                      'https://www.google.com/maps/search/?api=1&query=${report.location.latitude},${report.location.longitude}',
                    );
                    if (await canLaunchUrl(mapUrl)) {
                      await launchUrl(mapUrl);
                    } else {
                      // Handle error: Could not launch URL
                      Get.snackbar(
                        'Error',
                        'Could not open map.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      print('Could not launch $mapUrl');
                    }
                    print(
                      'View in Map tapped for Latitude: ${report.location.latitude}, Longitude: ${report.location.longitude}',
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: AppColors.primaryDarkColor,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          'View In Map',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primaryDarkColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Dynamic description display
          Text(
            descriptionToDisplay,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
