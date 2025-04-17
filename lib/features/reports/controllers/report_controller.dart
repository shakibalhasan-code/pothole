import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ReportController extends GetxController {
  RxList<File> pickedMedia = <File>[].obs;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> mediaFiles = await picker.pickMultipleMedia();

    if (mediaFiles.isNotEmpty) {
      pickedMedia.value = mediaFiles.map((file) => File(file.path)).toList();
    }
  }
}
