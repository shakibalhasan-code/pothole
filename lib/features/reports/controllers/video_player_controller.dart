import 'package:flutter/material.dart'; // Required for TransformationController & Matrix4
import 'package:get/get.dart';
import 'package:jourapothole/core/services/video_services.dart'; // Adjust import path
import 'package:video_player/video_player.dart';

class VideoPlayerGetxController extends GetxController {
  final String videoUrl;
  late final String _videoServicesTag;

  // For Zoom and Pan
  final TransformationController transformationController =
      TransformationController();
  final RxDouble _currentScale =
      1.0.obs; // To track current scale for double tap logic

  VideoPlayerGetxController({required this.videoUrl}) {
    _videoServicesTag =
        'VideoServices_${videoUrl.hashCode}_${DateTime.now().millisecondsSinceEpoch}';
  }

  VideoServices get videoServices =>
      Get.find<VideoServices>(tag: _videoServicesTag);

  VideoPlayerController? get playerController => videoServices.controller;
  RxBool get isInitialized => videoServices.isInitialized;
  RxBool get isPlaying => videoServices.isPlaying;
  RxString get errorMessage => videoServices.errorMessage;
  RxBool get showControls => videoServices.showControls;
  Rx<Duration> get videoDuration => videoServices.videoDuration;
  Rx<Duration> get currentPosition => videoServices.currentPosition;

  @override
  void onInit() {
    super.onInit();
    Get.put(VideoServices(), tag: _videoServicesTag, permanent: false);
    videoServices.initializeVideoPlayer(videoUrl);

    // Listen to transformation changes to update our internal scale state
    transformationController.addListener(_onTransformChanged);
  }

  void _onTransformChanged() {
    // Get the current scale from the matrix.
    // Matrix4.getMaxScaleOnAxis() gives the largest scale factor along any axis.
    // Useful for uniform scaling.
    _currentScale.value = transformationController.value.getMaxScaleOnAxis();
  }

  void togglePlayPause() {
    videoServices.togglePlayPause();
  }

  void seekVideo(Duration position) {
    videoServices.seekTo(position);
  }

  void toggleVideoControlsVisibility() {
    videoServices.toggleControlsVisibility();
  }

  // Handles double tap to zoom in/out (centered)
  void handleDoubleTap() {
    final Matrix4 matrix = Matrix4.identity();
    const double zoomFactor = 2.0;

    if (_currentScale.value > 1.01) {
      // If currently zoomed in (approx)
      // Zoom out (reset to identity)
      // transformationController.value will be updated by the listener
    } else {
      // Zoom in to the center
      matrix.scale(zoomFactor, zoomFactor);
      // InteractiveViewer's default alignment is center, so this scales around the center.
    }
    // Animate to the new matrix value for a smoother transition
    // For direct jump: transformationController.value = matrix;
    // For animation, we would typically use an AnimationController here.
    // Let's do a direct jump for simplicity in this example.
    transformationController.value = matrix;
  }

  @override
  void onClose() {
    transformationController.removeListener(_onTransformChanged);
    transformationController.dispose();
    Get.delete<VideoServices>(tag: _videoServicesTag, force: true);
    print(
      "VideoPlayerGetxController onClose for $videoUrl, VideoServices instance with tag $_videoServicesTag deleted.",
    );
    super.onClose();
  }
}
