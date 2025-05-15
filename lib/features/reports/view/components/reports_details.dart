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
          break;
        case DialogAction.dontKnow:
          print("User selected: I Don't Know");
          await reportsController.verifyReport(
            id: report.id,
            status: "I don't know",
          );
          break;
      }
    } else {
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
      padding: EdgeInsets.all(16.w), // Use responsive padding
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Report Details: ${report.issue}',
                    style: TextStyle(
                      fontSize: 18.sp, // Use responsive font size
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.redColor),
                  onPressed: () {
                    getVerifyList().then((isVerified) {
                      if (isVerified) {
                        Get.back();
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
            SizedBox(height: 8.h),
            FutureBuilder<bool>(
              future: getVerifyList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                } else if (snapshot.hasData && snapshot.data == true) {
                  return Text(
                    'You have already verified this report.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            // SizedBox(height: 8.h),
            InkWell(
              onTap: () {
                if (imageUrl != null) {
                  final imageProvider = Image.network(imageUrl).image;
                  showImageViewer(context, imageProvider, immersive: false);
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  12.r,
                ), // Use responsive border radius
                child:
                    imageUrl != null
                        ? Image.network(
                          imageUrl,
                          height: 150.h, // Use responsive height
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
                                              loadingProgress
                                                  .expectedTotalBytes!
                                          : null,
                                ),
                              ),
                            );
                          },
                        )
                        : Container(
                          height: 150.h,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Text('No image available'),
                          ),
                        ),
              ),
            ),
            SizedBox(height: 10.h),
            if (report.videos.isNotEmpty) ...[
              Text(
                'Videos:',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              SizedBox(
                height: 100.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: report.videos.length,
                  itemBuilder: (context, index) {
                    String videoUrl = report.videos[index];
                    return InkWell(
                      onTap: () {
                        Get.to(() => VideoPlayerViewGetx(videoUrl: videoUrl));
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          right: 8.w,
                        ), // Use responsive margin
                        width: 150.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            12.r,
                          ), // Use responsive radius
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
              SizedBox(height: 16.h),
            ],
            Text(
              'Issue type : ${report.issue}',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8.h),
            Text(
              'Severity Level : ${report.severityLevel}',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8.h),
            Text(
              'Address : ${report.location.address}',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Status : ',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      report.status,
                      style: TextStyle(
                        fontSize: 16.sp,
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
                        Get.snackbar(
                          'Error',
                          'Could not open map.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        print('Could not launch $mapUrl');
                      }
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
            SizedBox(height: 16.h),
            Text(
              descriptionToDisplay,
              style: TextStyle(fontSize: 14.sp, color: Colors.black87),
            ),
            // SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
