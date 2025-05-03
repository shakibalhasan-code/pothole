import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jourapothole/core/models/pothole_model.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart';
import 'package:jourapothole/core/utils/constants/app_text_styles.dart';

class ReportProblemBottomSheet extends StatelessWidget {
  // 1. Add a required parameter for the PotholeModel
  final PotholeModel report;

  const ReportProblemBottomSheet({
    super.key,
    required this.report, // Make the report data required
  });

  @override
  Widget build(BuildContext context) {
    // Determine status color dynamically
    Color statusColor =
        report.status == 'open'
            ? AppColors.redColor
            : Colors.green; // Assuming AppColors is defined

    // Get the first image URL, or null if no images
    String? imageUrl = report.images.isNotEmpty ? report.images.first : null;

    // Determine description to display (use actual or placeholder)
    String descriptionToDisplay =
        report.description.isNotEmpty
            ? report.description
            : 'No detailed description provided for this report.'; // Default placeholder

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Dynamic title based on issue type
              Text(
                'Report Details: ${report.issue}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: AppColors.redColor),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 2. Display image dynamically, handle missing image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:
                imageUrl != null
                    ? Image.network(
                      imageUrl,
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
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
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
                      child: const Center(child: Text('No image available')),
                    ),
          ),
          const SizedBox(height: 16),

          // 3. Display dynamic data
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
            'Address : ${report.location.address}', // Display address from location
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
                    report.status, // Display dynamic status
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: statusColor, // Use dynamic color
                    ),
                  ),
                ],
              ),
              // View In Map button - keep UI, add functionality later
              Container(
                decoration: BoxDecoration(
                  color:
                      AppColors
                          .primaryLightColor, // Assuming AppColors is defined
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: InkWell(
                  // Make the container tappable
                  onTap: () {
                    // TODO: Implement map view functionality
                    print(
                      'View in Map tapped for Latitude: ${report.location.latitude}, Longitude: ${report.location.longitude}',
                    );
                    // Example: You might use url_launcher to open Google Maps or a custom map screen
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
                          color:
                              AppColors
                                  .primaryDarkColor, // Assuming AppColors is defined
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          'View In Map',
                          style: AppTextStyles.bodySmall.copyWith(
                            // Assuming AppTextStyles is defined
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

          // 4. Display dynamic description
          Text(
            descriptionToDisplay, // Use the determined description
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
