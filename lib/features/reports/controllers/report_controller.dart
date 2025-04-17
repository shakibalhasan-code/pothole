import 'dart:io';

// Import material or cupertino for UI elements if showing dialog from controller
// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ReportController extends GetxController {
  // Keep the picker instance reusable
  final ImagePicker _picker = ImagePicker();

  // Observable list to hold the selected/captured files
  RxList<File> pickedMedia = <File>[].obs;

  // --- Method to Pick Multiple Media from Gallery ---
  Future<void> pickMediaFromGallery() async {
    try {
      // Use pickMultipleMedia to allow selecting multiple images/videos
      final List<XFile> mediaFiles = await _picker.pickMultipleMedia(
        // Optional: You can set limits or request specific types
        // imageQuality: 80, // Example: Lower quality to save space
      );

      if (mediaFiles.isNotEmpty) {
        // Add the selected files to the list
        // Use addAll to append to the existing list, or .value = ... to replace
        pickedMedia.addAll(mediaFiles.map((file) => File(file.path)).toList());
        print("Picked ${mediaFiles.length} files from gallery.");
      } else {
        print("No media selected from gallery.");
      }
    } catch (e) {
      // Handle potential exceptions (e.g., permissions denied)
      print("Error picking media from gallery: $e");
      // Optionally show a snackbar or dialog to the user
      Get.snackbar(
        'Error',
        'Could not pick media from gallery: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // --- Method to Capture Image from Camera ---
  Future<void> captureImageFromCamera() async {
    try {
      // Use pickImage for capturing a single photo
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        // Optional: Set preferred camera or resolution
        // preferredCameraDevice: CameraDevice.rear,
        // imageQuality: 80,
      );

      if (photo != null) {
        // Add the captured photo to the list
        pickedMedia.add(File(photo.path));
        print("Captured image from camera: ${photo.path}");
      } else {
        print("No image captured from camera.");
      }
    } catch (e) {
      // Handle potential exceptions (e.g., permissions denied)
      print("Error capturing image from camera: $e");
      Get.snackbar(
        'Error',
        'Could not capture image from camera: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // --- Method to Capture Video from Camera ---
  // Optional: If you want to allow video capture separately
  Future<void> captureVideoFromCamera() async {
    try {
      // Use pickVideo for capturing a single video
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.camera,
        // Optional: Set preferred camera or duration limit
        // preferredCameraDevice: CameraDevice.rear,
        // maxDuration: const Duration(seconds: 60),
      );

      if (video != null) {
        // Add the captured video to the list
        pickedMedia.add(File(video.path));
        print("Captured video from camera: ${video.path}");
      } else {
        print("No video captured from camera.");
      }
    } catch (e) {
      print("Error capturing video from camera: $e");
      Get.snackbar(
        'Error',
        'Could not capture video from camera: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // --- Optional: Helper Method to Show Choice Dialog/Sheet ---
  // This would typically be called from your UI button's onPressed callback
  void showMediaSourceSelection() {
    // Use Get.dialog or Get.bottomSheet to present the options
    Get.bottomSheet(
      Container(
        // Add styling as needed (e.g., color, padding)
        color: Get.theme.bottomSheetTheme.backgroundColor ?? Colors.white,
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Get.back(); // Close the bottom sheet
                pickMediaFromGallery(); // Call the gallery picker method
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take Photo'),
              onTap: () {
                Get.back(); // Close the bottom sheet
                captureImageFromCamera(); // Call the camera capture method
              },
            ),
            // Optional: Add video capture option
            // ListTile(
            //   leading: const Icon(Icons.videocam),
            //   title: const Text('Record Video'),
            //   onTap: () {
            //     Get.back();
            //     captureVideoFromCamera();
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  // --- Method to clear the picked media ---
  void clearMedia() {
    pickedMedia.clear();
  }
}
