import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:jourapothole/core/helpers/widget_helper.dart';
import 'package:jourapothole/core/models/pothole_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:jourapothole/core/config/api_endpoints.dart';
import 'package:jourapothole/core/helpers/pref_helper.dart';
import 'package:jourapothole/core/models/profile_model.dart';
import 'package:jourapothole/core/services/api_services.dart';
import 'package:jourapothole/core/utils/utils.dart';

class ProfileController extends GetxController {
  Rx<File?> pickedImage = Rx<File?>(null);
  List<PotholeModel> allMyPothole = [];

  final Rx<ProfileModel> profile = ProfileModel().obs;
  final TextEditingController fullNameController =
      TextEditingController(); // For display or if API supports it
  final TextEditingController firstNameController =
      TextEditingController(); // Was nickNameController
  final TextEditingController lastNameController =
      TextEditingController(); // New
  final TextEditingController dobController =
      TextEditingController(); // Used as string fallback
  final TextEditingController emailController =
      TextEditingController(); // Likely read-only for updates
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  var isLoading = false.obs;
  var isUploading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await getProfileData();
    await getMyReports();
  }

  void initializeFields(ProfileModel model) {
    fullNameController.text = model.fullName ?? '';
    firstNameController.text = model.firstName ?? '';
    lastNameController.text = model.lastName ?? ''; // New
    emailController.text = model.email ?? '';
    phoneController.text = model.phoneNumber ?? ''; // Updated
    addressController.text = model.address ?? ''; // Updated

    if (model.dateOfBirth != null && model.dateOfBirth!.isNotEmpty) {
      try {
        selectedDate.value = DateTime.parse(model.dateOfBirth!);
        dobController.text = model.dateOfBirth!;
      } catch (e) {
        print("Error parsing dateOfBirth from model: $e");
        selectedDate.value = null;
        dobController.text = model.dateOfBirth!;
      }
    } else {
      selectedDate.value = null;
      dobController.text = '';
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      dobController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await showModalBottomSheet<XFile?>(
        context: Get.context!,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () async {
                    Navigator.pop(
                      context,
                      await picker.pickImage(source: ImageSource.gallery),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    Navigator.pop(
                      context,
                      await picker.pickImage(source: ImageSource.camera),
                    );
                  },
                ),
              ],
            ),
          );
        },
      );

      if (image != null) {
        final compressedImage = await compressImage(File(image.path));
        pickedImage.value = compressedImage;
        await updateProfileWithImage(
          compressedImage,
        ); // This should ideally update profile.value.image and then persist
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<File> compressImage(File file) async {
    try {
      final fileExt = path.extension(file.path).toLowerCase();
      final tempDir = await getTemporaryDirectory();
      final targetPath = path.join(
        tempDir.path,
        'compressed_${DateTime.now().millisecondsSinceEpoch}$fileExt',
      );

      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 80,
        minWidth: 800,
        minHeight: 800,
        format: fileExt == '.webp' ? CompressFormat.webp : CompressFormat.jpeg,
      );

      if (result == null) {
        print('Image compression failed, using original file');
        return file;
      }
      return File(result.path);
    } catch (e) {
      print('Error compressing image: $e');
      return file;
    }
  }

  Future<void> updateProfileWithImage(File imageFile) async {
    // Or whatever you named it
    isUploading.value = true;
    try {
      final token = await PrefHelper.getData(Utils.token);
      if (token == null) {
        throw Exception('Authentication token not found.');
      }

      // 1. Prepare the textual data object that goes INSIDE the 'data' field
      Map<String, dynamic> profileUpdatePayload =
          {}; // This will be the value of the 'data' field
      if (firstNameController.text.trim().isNotEmpty) {
        profileUpdatePayload['firstName'] = firstNameController.text.trim();
      }
      if (lastNameController.text.trim().isNotEmpty) {
        profileUpdatePayload['lastName'] = lastNameController.text.trim();
      }
      if (phoneController.text.trim().isNotEmpty) {
        profileUpdatePayload['phoneNumber'] = phoneController.text.trim();
      }
      if (addressController.text.trim().isNotEmpty) {
        profileUpdatePayload['address'] = addressController.text.trim();
      }
      // The 'image' field in your Zod schema `image: z.string().nullable().optional()`
      // usually means the backend expects a URL string here *if you were sending only JSON*.
      // When sending a multipart request with the actual file, the backend typically handles
      // saving the file and updating this 'image' field with the new URL itself.
      // So, you generally DO NOT include an 'image' field in `profileUpdatePayload` here.
      // If your backend specifically requires you to also send a placeholder or some other value
      // for 'image' in the 'data' object even when a file is uploaded, you'd add it here.
      // But the common pattern is to omit it and let the backend derive it from the uploaded file.

      // 2. Prepare the `formTextFields` map for ApiServices.sendMultipartData
      // This map will contain the JSON string of your `profileUpdatePayload`
      // under the field name 'data'.
      Map<String, String> formTextFields = {};

      // *** THIS IS THE CRUCIAL PART ***
      // The backend expects a field named 'data' containing an object.
      // In a multipart/form-data request, if 'data' is supposed to be an object,
      // you usually send it as a JSON string.
      if (profileUpdatePayload.isNotEmpty) {
        // The field name here 'data' must match the Zod schema path `["data"]`
        formTextFields['data'] = json.encode(profileUpdatePayload);
      } else {
        // If there are no textual updates, you might need to send an empty 'data' object
        // or your backend might allow omitting the 'data' field entirely if only an image is updated.
        // Sending an empty object is safer if 'data' is always expected.
        // formTextFields['data'] = json.encode({});
        // For now, let's assume if profileUpdatePayload is empty, we don't send the 'data' field.
        // However, the error "Expected object, received null" suggests 'data' is required.
        // So, even if empty, send an empty object:
        formTextFields['data'] = json.encode(
          {},
        ); // Ensure 'data' field is always present if required
        // If `profileUpdatePayload` can be empty and you still want to upload ONLY the image,
        // and your backend expects 'data' to be an object:
        // formTextFields['data'] = json.encode(profileUpdatePayload); // This will be `json.encode({})` if empty.
      }

      // If `profileUpdatePayload` is empty and your backend allows 'data' to be optional
      // when only uploading an image, then you could conditionally add it:
      // if (profileUpdatePayload.isNotEmpty) {
      //    formTextFields['data'] = json.encode(profileUpdatePayload);
      // }
      // But based on the error, 'data' seems required. So always include it, even if empty.
      // Let's ensure 'data' is always sent, even if it's an empty object.
      formTextFields['data'] = json.encode(
        profileUpdatePayload.isNotEmpty ? profileUpdatePayload : {},
      );

      // 3. Define the field name for the image file (as per your log, it's 'image')
      final String imageFileFieldName =
          'image'; // Your log shows "Files: image: compressed_..."

      final response = await ApiServices.sendMultipartData(
        url:
            "${ApiEndpoints.baseUrl}/user", // Your log shows "/api/v1/user" so ensure baseUrl includes /api/v1
        method: 'PATCH',
        files: {imageFileFieldName: imageFile},
        data: formTextFields, // Pass the prepared form fields
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          await getProfileData();
          pickedImage.value = null; // Clear the preview
          Get.snackbar(
            'Success',
            responseData['message'] ?? 'Profile updated successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          throw Exception(
            responseData['message'] ?? 'Failed to update profile on server.',
          );
        }
      } else {
        String errorMessage =
            'Failed to update profile. Status: ${response.statusCode}';
        try {
          final errorResponseData = json.decode(response.body);
          if (errorResponseData['message'] != null) {
            errorMessage = errorResponseData['message'];
            if (errorResponseData['errorSources'] != null &&
                errorResponseData['errorSources'] is List) {
              final errors = (errorResponseData['errorSources'] as List)
                  .map((e) => "${e['path']}: ${e['message']}")
                  .join('\n');
              errorMessage += "\nDetails: $errors";
            }
          }
        } catch (_) {
          /* Ignore if response body is not JSON */
        }
        // The original error "Expected object, received null" for path "data" is very specific.
        throw Exception(errorMessage); // Throw the more detailed error message
      }
    } catch (e) {
      printError(info: 'Error updating profile with image: ${e.toString()}');
      Get.snackbar(
        'Error',
        // 'Failed to update profile: ${e.toString()}',
        e.toString(), // Show the specific error message from the exception
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> getProfileData() async {
    try {
      isLoading.value = true;
      final token = await PrefHelper.getData(Utils.token);

      final response = await ApiServices.getData(
        url: ApiEndpoints.getMe,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          profile.value = ProfileModel.fromJson(responseData['data']);

          fullNameController.text = profile.value.fullName ?? '';
          firstNameController.text = profile.value.firstName ?? '';
          lastNameController.text = profile.value.lastName ?? ''; // New
          emailController.text = profile.value.email ?? '';
          phoneController.text = profile.value.phoneNumber ?? ''; // Updated
          addressController.text = profile.value.address ?? ''; // Updated

          if (profile.value.dateOfBirth != null &&
              profile.value.dateOfBirth!.isNotEmpty) {
            try {
              selectedDate.value = DateTime.parse(profile.value.dateOfBirth!);
              dobController.text = profile.value.dateOfBirth!;
            } catch (e) {
              print("Error parsing dateOfBirth from API: $e");
              selectedDate.value = null;
              dobController.text = profile.value.dateOfBirth!;
            }
          } else {
            selectedDate.value = null;
            dobController.text = '';
          }
          // If pickedImage should reflect the profile image URL, you might load it here
          // For now, pickedImage is only for newly picked files.
        } else {
          throw Exception(
            responseData['message'] ??
                'Failed to fetch profile data or data is null',
          );
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      printError(info: 'Error fetching profile data: ${e.toString()}');
      // Optionally show a snackbar for fetch error
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      final token = await PrefHelper.getData(Utils.token);

      final Map<String, dynamic> dataToUpdate = {};

      if (firstNameController.text.trim().isNotEmpty) {
        dataToUpdate['firstName'] = firstNameController.text.trim();
      }
      if (lastNameController.text.trim().isNotEmpty) {
        dataToUpdate['lastName'] = lastNameController.text.trim();
      }
      if (phoneController.text.trim().isNotEmpty) {
        // Add phone validation if needed here or rely on backend
        dataToUpdate['phoneNumber'] = phoneController.text.trim();
      }
      if (addressController.text.trim().isNotEmpty) {
        dataToUpdate['address'] = addressController.text.trim();
      }

      // Note: dateOfBirth and email are not in the backend `updateUser` schema provided.
      // If they were, you'd add them like this:
      // String? formattedDate;
      // if (selectedDate.value != null) {
      //   formattedDate =
      //       '${selectedDate.value!.year}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')}';
      // } else if (dobController.text.isNotEmpty) {
      //   // Potentially validate dobController.text format before sending
      //   formattedDate = dobController.text;
      // }
      // if (formattedDate != null) {
      //   dataToUpdate['dateOfBirth'] = formattedDate;
      // }
      // if (emailController.text.trim().isNotEmpty) { // Usually email is not updated this way
      //    dataToUpdate['email'] = emailController.text.trim();
      // }

      if (dataToUpdate.isEmpty) {
        Get.snackbar(
          'Info',
          'No changes to update.',
          snackPosition: SnackPosition.BOTTOM,
        );
        isLoading.value = false;
        return;
      }

      print("Profile data to update: $dataToUpdate");

      final response = await ApiServices.updateData(
        url: ApiEndpoints.updateProfile,
        body: dataToUpdate, // Send data directly, not inside 'data'
        headers: {'Authorization': 'Bearer $token'},
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await getProfileData(); // Refresh data from server
        Get.back(); // Go back to the previous screen (e.g., Profile View)
      } else {
        String errorMessage =
            'Failed to update profile. Server error: ${response.statusCode}';
        if (responseBody != null && responseBody['message'] != null) {
          errorMessage = responseBody['message'];
        } else if (responseBody != null &&
            responseBody['error'] != null &&
            responseBody['error']['message'] != null) {
          errorMessage = responseBody['error']['message'];
        } else if (responseBody != null &&
            responseBody['errors'] != null &&
            responseBody['errors'] is List &&
            responseBody['errors'].isNotEmpty) {
          errorMessage = (responseBody['errors'] as List)
              .map((e) => e['message'] ?? 'Unknown error')
              .join('\n');
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      printError(info: 'Error updating profile: ${e.toString()}');
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMyReports() async {
    try {
      final token = await PrefHelper.getData(Utils.token);
      final response = await ApiServices.getData(
        url: ApiEndpoints.getMyReports,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> data = responseData['data'];
          allMyPothole.clear();
          allMyPothole.addAll(
            data.map((pothole) => PotholeModel.fromJson(pothole)).toList(),
          );
          update();
        } else {
          throw Exception(responseData['message'] ?? 'Failed to fetch reports');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      printError(info: 'Error fetching reports: ${e.toString()}');
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    firstNameController.dispose(); // Was nickNameController
    lastNameController.dispose(); // New
    dobController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
