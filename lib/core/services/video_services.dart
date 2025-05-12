import 'dart:async';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoServices extends GetxService {
  final Rxn<VideoPlayerController> _controller = Rxn<VideoPlayerController>();
  VideoPlayerController? get controller => _controller.value;

  final RxBool isInitialized = false.obs;
  final RxBool isPlaying = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool showControls = true.obs; // To show/hide controls
  final Rx<Duration> videoDuration = Duration.zero.obs;
  final Rx<Duration> currentPosition = Duration.zero.obs;

  Timer? _hideControlsTimer;

  Future<void> initializeVideoPlayer(String videoUrl) async {
    // Reset states for new video
    isInitialized.value = false;
    isPlaying.value = false;
    errorMessage.value = '';
    showControls.value = true;
    videoDuration.value = Duration.zero;
    currentPosition.value = Duration.zero;

    // Dispose previous controller if any
    _controller.value?.removeListener(_videoListener);
    await _controller.value?.dispose();
    _controller.value = null;

    try {
      final newController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
      );
      await newController.initialize();

      _controller.value = newController; // Assign to the Rx variable
      isInitialized.value = true;
      videoDuration.value = newController.value.duration;

      await newController.setLooping(true);
      // We won't auto-play; user will initiate via controls

      newController.addListener(_videoListener);
      _startHideControlsTimer(); // Show controls initially, then hide if playing
    } catch (e) {
      print("Error initializing video: $e");
      errorMessage.value =
          "Could not load video. Please check the URL or network.";
      isInitialized.value = false;
    }
  }

  void _videoListener() {
    if (_controller.value == null || !_controller.value!.value.isInitialized) {
      // If controller is disposed or not initialized, stop listening.
      if (_controller.value != null)
        _controller.value!.removeListener(_videoListener);
      return;
    }
    final value = _controller.value!.value;
    isPlaying.value = value.isPlaying;
    currentPosition.value = value.position;

    if (value.hasError) {
      errorMessage.value = "Video player error: ${value.errorDescription}";
      isPlaying.value = false; // Stop playback on error
    }
  }

  void play() {
    if (isInitialized.value &&
        _controller.value != null &&
        !_controller.value!.value.isPlaying) {
      _controller.value!.play();
      _startHideControlsTimer();
    }
  }

  void pause() {
    if (isInitialized.value &&
        _controller.value != null &&
        _controller.value!.value.isPlaying) {
      _controller.value!.pause();
      _cancelHideControlsTimer(); // Keep controls visible when paused by user
      showControls.value = true; // Ensure controls are shown when paused
    }
  }

  void togglePlayPause() {
    if (!isInitialized.value || _controller.value == null) return;
    if (_controller.value!.value.isPlaying) {
      pause();
    } else {
      play();
    }
  }

  void seekTo(Duration position) {
    if (isInitialized.value && _controller.value != null) {
      _controller.value!.seekTo(position);
      currentPosition.value = position; // Optimistically update for smoother UI
      if (isPlaying.value)
        _startHideControlsTimer(); // Reset timer if seeking while playing
    }
  }

  void toggleControlsVisibility() {
    showControls.value = !showControls.value;
    if (showControls.value && isPlaying.value) {
      _startHideControlsTimer();
    } else if (!showControls.value) {
      _cancelHideControlsTimer();
    }
  }

  void _startHideControlsTimer() {
    _cancelHideControlsTimer();
    if (isPlaying.value) {
      // Only auto-hide if playing
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        if (isPlaying.value) {
          // Check again in case it was paused
          showControls.value = false;
        }
      });
    }
  }

  void _cancelHideControlsTimer() {
    _hideControlsTimer?.cancel();
  }

  @override
  void onClose() {
    print("VideoServices onClose: Disposing controller");
    _cancelHideControlsTimer();
    _controller.value?.removeListener(_videoListener);
    _controller.value?.dispose();
    _controller.value = null; // Clear the Rx variable
    super.onClose();
  }
}
