import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jourapothole/core/services/location_services.dart'; // Your LocationServices path
import 'package:jourapothole/core/utils/constants/app_colors.dart'; // Your AppColors path
import 'package:jourapothole/core/utils/components/custom_button.dart'; // Your CustomButton path
import 'package:jourapothole/features/reports/controllers/report_controller.dart'; // Your ReportController path
import 'dart:io'; // For File type in _buildMediaPreview

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

  late final ReportController reportController;
  late final LocationServices locationController;

  @override
  void initState() {
    super.initState();

    try {
      reportController = Get.find<ReportController>();
      locationController = Get.find<LocationServices>();
    } catch (e) {
      print(
        "Error finding controllers: $e. Make sure they are Get.put() before this widget is built.",
      );
      // Fallback or rethrow, depending on how critical these are for the UI to function.
      // For now, let's re-put them if not found, but this isn't ideal for global controllers.
      reportController = Get.put(ReportController());
      locationController = Get.put(LocationServices());
      // Consider showing an error to the user or preventing the sheet from fully rendering
      // if controllers can't be initialized.
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0 + bottomPadding),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildIssueDropdown(),
            const SizedBox(height: 16),
            _buildSeverityDropdown(),
            const SizedBox(height: 16),
            _buildLocationField(),
            const SizedBox(height: 16),
            _buildDescriptionField(),
            const SizedBox(height: 16),
            _buildAttachmentField(),
            const SizedBox(height: 12),
            _buildMediaPreview(),
            const SizedBox(height: 24),
            Obx(() {
              return reportController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                    buttonTitle: 'Submit Report',
                    onTap: _submitReport,
                  );
            }),
            const SizedBox(height: 10), // For some padding at the very bottom
            CustomButton(
              buttonTitle: 'Cancel',

              isFilled: false,
              onTap: () {
                reportController.clearMedia(); // Clear media if user cancels
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10), // For some padding at the very bottom
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Report a Pothole',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            reportController
                .clearMedia(); // Clear media if user closes without submitting
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildIssueDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Type of Issue',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedIssueType,
          decoration: InputDecoration(
            hintText: 'Select issue type...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primaryLightColor),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 12.0,
            ),
          ),
          items:
              ['Pothole', 'Manhole', 'Road Crack', 'Water Leakage']
                  .map(
                    (type) => DropdownMenuItem(value: type, child: Text(type)),
                  )
                  .toList(),
          onChanged: (value) {
            setState(() {
              selectedIssueType = value;
            });
          },
          validator:
              (value) => value == null ? 'Please select an issue type' : null,
        ),
      ],
    );
  }

  Widget _buildSeverityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Severity Level',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedSeverityLevel,
          decoration: InputDecoration(
            hintText: 'Select severity level...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primaryLightColor),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 12.0,
            ),
          ),
          items:
              ['Mild', 'Moderate', 'Severe']
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
          validator:
              (value) =>
                  value == null ? 'Please select a severity level' : null,
        ),
      ],
    );
  }

  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Column(
            children: [
              TextFormField(
                // Using a key ensures the initialValue updates if location changes externally
                key: ValueKey(locationController.userCurrentLocation.value),
                initialValue:
                    locationController.userCurrentLocation.value.isNotEmpty
                        ? locationController.userCurrentLocation.value
                        : null,
                readOnly:
                    true, // Make it read-only, location is fetched or picked
                decoration: InputDecoration(
                  hintText:
                      locationController.userCurrentLocation.value.isEmpty
                          ? 'Fetching location...'
                          : 'Tap icon to refresh or pick',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primaryLightColor),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 12.0,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.my_location,
                      color: AppColors.primaryColor,
                    ),
                    onPressed: () async {
                      // You might want to show a loading indicator while fetching
                      if (locationController.getUserLocationWithAddress()
                          is Function) {
                        // Check if method exists
                        await locationController.getUserLocationWithAddress();
                      } else {
                        print(
                          "getCurrentLocation method not found in LocationServices",
                        );
                      }
                    },
                  ),
                ),
                onTap: () {
                  // Could also be used to open a map picker
                  print("Location Field Tapped - consider opening map picker");
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description (Optional)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: descriptionController,
          maxLines: 3,
          minLines: 3,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'Provide additional details...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primaryLightColor),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 12.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentField() {
    return GestureDetector(
      onTap: () {
        reportController.showMediaSourceSelection();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(
            color: AppColors.primaryLightColor.withOpacity(0.5),

            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              color: AppColors.primaryColor,
              size: 36,
            ),
            const SizedBox(height: 8),
            Text(
              'Upload Photos or Videos',
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '(Max 5 files, 10MB each)', // Example helper text
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPreview() {
    return Obx(() {
      final mediaList = reportController.pickedMedia;
      if (mediaList.isEmpty) {
        return const SizedBox.shrink();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Attachments (${mediaList.length})",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mediaList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Adjust number of columns as needed
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1, // Make items square
            ),
            itemBuilder: (context, index) {
              final file = mediaList[index];
              final isVideo =
                  file.path.toLowerCase().endsWith('.mp4') ||
                  file.path.toLowerCase().endsWith('.mov') ||
                  file.path.toLowerCase().endsWith('.avi') ||
                  file.path.toLowerCase().endsWith('.mkv') ||
                  file.path.toLowerCase().endsWith('.webm');

              return Hero(
                // Optional: For smooth transition if you open image/video full screen
                tag: file.path,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child:
                          isVideo
                              ? Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.black,
                                child: const Icon(
                                  Icons.play_circle_fill_rounded,
                                  size: 40,
                                  color: Colors.white70,
                                ),
                              )
                              : Image.file(
                                file,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap:
                            () => reportController.pickedMedia.removeAt(index),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.6),
                          ),
                          padding: const EdgeInsets.all(3),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
    });
  }

  void _submitReport() async {
    // Basic form validation (can be expanded with a Form widget and GlobalKey)
    if (selectedIssueType == null) {
      Get.snackbar(
        "Validation Error",
        "Please select an issue type.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (selectedSeverityLevel == null) {
      Get.snackbar(
        "Validation Error",
        "Please select a severity level.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (locationController.userCurrentLocation.value.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Location is required. Please ensure location is fetched.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    // Optional: Validate if media is required
    // if (reportController.pickedMedia.isEmpty) {
    //   Get.snackbar("Validation Error", "Please attach at least one photo or video.", snackPosition: SnackPosition.BOTTOM);
    //   return;
    // }

    await reportController.createReport(
      issueType: selectedIssueType,
      severityLevel: selectedSeverityLevel,
      description: descriptionController.text.trim(),
      location: locationController.userCurrentLocation.value,
      // latitude: locationController.latitude.value, // If you have these
      // longitude: locationController.longitude.value, // If you have these
    );
    reportController.clearMedia(); // Clear media after submission
  }
}
