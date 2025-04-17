import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jourapothole/core/constants/app_colors.dart';
import 'package:jourapothole/core/components/custom_button.dart';
import 'package:jourapothole/features/reports/controllers/report_controller.dart';

class PotholeReportBottomSheet extends StatefulWidget {
  const PotholeReportBottomSheet({super.key});

  @override
  State<PotholeReportBottomSheet> createState() =>
      _PotholeReportBottomSheetState();
}

class _PotholeReportBottomSheetState extends State<PotholeReportBottomSheet> {
  String? selectedIssueType;
  String? selectedSeverityLevel;
  final TextEditingController descriptionController = TextEditingController();
  final reportController = Get.put(ReportController());

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // It's generally safer and good practice to add padding MediaQuery based padding
    // especially for bottom sheets to account for notches and system UI.
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      // Add bottom padding dynamically based on keyboard visibility
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0 + bottomPadding),
      child: SingleChildScrollView(
        // Wrap with SingleChildScrollView to prevent overflow when keyboard appears
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  // const is fine here as Text contents are literal strings
                  'Pothole Reporting',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // Optional: Add a close button if needed
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16), // const is fine here
            const Text(
              // const is fine here
              'Issue',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8), // const is fine here
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                hintText: 'Select issue type...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  // REMOVED const from BorderSide
                  borderSide: BorderSide(color: AppColors.primaryLightColor),
                ),
                enabledBorder: OutlineInputBorder(
                  // Also style enabled/focused borders
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.primaryLightColor.withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.primaryLightColor,
                    width: 2,
                  ),
                ),
              ),
              value: selectedIssueType,
              items:
                  ['Pothole', 'Crack', 'Other']
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  selectedIssueType = value;
                });
              },
            ),
            const SizedBox(height: 16), // const is fine here
            const Text(
              // const is fine here
              'Severity Level',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8), // const is fine here
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                hintText: 'Select severity level...', // Changed hint text
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  // REMOVED const from BorderSide
                  borderSide: BorderSide(color: AppColors.primaryLightColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.primaryLightColor.withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.primaryLightColor,
                    width: 2,
                  ),
                ),
              ),
              value: selectedSeverityLevel,
              items:
                  ['Low', 'Medium', 'High']
                      .map(
                        (level) =>
                            DropdownMenuItem(value: level, child: Text(level)),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  selectedSeverityLevel = value;
                });
              },
            ),
            const SizedBox(height: 16), // const is fine here
            const Text(
              // const is fine here
              'Location',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8), // const is fine here
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Tap icon to get location', // Improved hint text
                // Use Icon directly, avoid const if color is not const
                suffixIcon: Icon(Icons.my_location, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  // REMOVED const from BorderSide
                  borderSide: BorderSide(color: AppColors.primaryLightColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.primaryLightColor.withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.primaryLightColor,
                    width: 2,
                  ),
                ),
              ),
              onTap: () {
                // Add location picker functionality here
                print("Location Tapped"); // Placeholder
              },
            ),
            const SizedBox(height: 16), // const is fine here
            const Text(
              // const is fine here
              'Description (optional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8), // const is fine here
            TextFormField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter description...', // Improved hint text
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  // REMOVED const from BorderSide
                  borderSide: BorderSide(color: AppColors.primaryLightColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.primaryLightColor.withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.primaryLightColor,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16), // const is fine here
            const Text(
              // const is fine here
              'Attachment (Max 5 files)', // Corrected typo: file -> files
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8), // const is fine here
            GestureDetector(
              onTap: () async {
                // Add file picker functionality here
                await reportController.pickImage();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ), // const okay here
                decoration: BoxDecoration(
                  // REMOVED const from Border.all (implicitly) because color is not const
                  border: Border.all(color: AppColors.primaryLightColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                // REMOVED const from Center because its child Text uses a non-const color
                child: Center(
                  child: Column(
                    children: [
                      // Icon can be const if color is const, but keep it non-const for consistency if parent isn't const
                      Icon(
                        Icons.upload,
                        color: Colors.black,
                      ), // Colors.black IS const
                      const SizedBox(height: 4), // const is fine here
                      Text(
                        // Text cannot be const because TextStyle uses non-const color
                        'Photo or video Upload',
                        // TextStyle cannot be const because color is not const
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final mediaList = reportController.pickedMedia;
              return mediaList.isEmpty
                  ? const SizedBox()
                  : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: mediaList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                    itemBuilder: (context, index) {
                      final file = mediaList[index];
                      final isVideo =
                          file.path.toLowerCase().endsWith('.mp4') ||
                          file.path.toLowerCase().endsWith('.mov') ||
                          file.path.toLowerCase().endsWith('.avi');

                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child:
                                isVideo
                                    ? Container(
                                      color: Colors.black26,
                                      child: const Center(
                                        child: Icon(Icons.videocam, size: 40),
                                      ),
                                    )
                                    : Image.file(file, fit: BoxFit.cover),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap:
                                  () => reportController.pickedMedia.removeAt(
                                    index,
                                  ),
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black54,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
            }),

            CustomButton(buttonTitle: 'Continue', onTap: () {}),
          ],
        ),
      ),
    );
  }
}
