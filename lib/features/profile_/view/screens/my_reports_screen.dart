import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart';
import 'package:jourapothole/core/utils/constants/app_images.dart';
import 'package:jourapothole/features/profile_/controller/profile_controller.dart';
import 'package:jourapothole/features/reports/view/components/reports_details.dart';

class MyReportsScreen extends StatelessWidget {
  MyReportsScreen({super.key});

  final profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
        title: const Text('My Reports'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Obx(() {
          if (profileController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (profileController.allMyPothole.isEmpty) {
            return const Center(
              child: Text(
                'No reports found.',
                style: TextStyle(color: Colors.black),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: profileController.allMyPothole.length,
              itemBuilder: (context, index) {
                final report = profileController.allMyPothole[index];

                // Check if images is not empty
                final imageUrl =
                    report.images.isNotEmpty
                        ? report.images[0]
                        : 'https://thumb.ac-illust.com/b1/b170870007dfa419295d949814474ab2_t.jpeg';

                return Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: _buildReportCard(
                    imageUrl,
                    report.issue,
                    report.location.address,
                    report.status,
                    report.status == 'open' ? Colors.red : Colors.green,
                    () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: AppColors.whiteColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder:
                            (context) =>
                                ReportProblemBottomSheet(report: report),
                      );
                    },
                  ),
                );
              },
            );
          }
        }),
      ),
    );
  }

  Widget _buildReportCard(
    String image,
    String issueType,
    String location,
    String status,
    Color statusColor,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.lightBlueColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Container(
              width: 80.w,
              height: 60.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.greyColor.withOpacity(0.3),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    image != null
                        ? Image.network(
                          image,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                height: 150,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Text('Failed to load image'),
                                ),
                              ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 150,
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
                          // Placeholder when no image URL is available
                          height: 150,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Text('No image available'),
                          ),
                        ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Issue type: $issueType',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColors.blueColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.greyColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        'Issue Update:',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
