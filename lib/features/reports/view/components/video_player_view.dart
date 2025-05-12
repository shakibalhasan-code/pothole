import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Ensure this path is correct for your project structure
import 'package:jourapothole/features/reports/controllers/video_player_controller.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerViewGetx extends StatelessWidget {
  final String videoUrl;
  final String _controllerTag;

  VideoPlayerViewGetx({super.key, required this.videoUrl})
    : _controllerTag =
          'VideoPlayerGetxController_${videoUrl.hashCode}_${DateTime.now().millisecondsSinceEpoch}' {
    Get.put(
      VideoPlayerGetxController(videoUrl: videoUrl),
      tag: _controllerTag,
      permanent: false,
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}";
    }
    return "${twoDigits(minutes)}:${twoDigits(seconds)}";
  }

  @override
  Widget build(BuildContext context) {
    final VideoPlayerGetxController controller =
        Get.find<VideoPlayerGetxController>(tag: _controllerTag);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Player"),
        backgroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Obx(() {
          if (controller.errorMessage.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                controller.errorMessage.value,
                style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!controller.isInitialized.value ||
              controller.playerController == null) {
            return const CircularProgressIndicator(color: Colors.white);
          }

          // InteractiveViewer enables pinch-to-zoom and pan
          return InteractiveViewer(
            transformationController: controller.transformationController,
            minScale: 1.0, // Minimum scale (original size)
            maxScale: 4.0, // Maximum zoom level
            // boundaryMargin: EdgeInsets.all(double.infinity), // Allows free panning
            boundaryMargin: EdgeInsets.zero, // Constrains to viewport edges
            constrained: true, // Prevents panning content fully out of view
            child: AspectRatio(
              aspectRatio: controller.playerController!.value.aspectRatio,
              child: Stack(
                children: <Widget>[
                  VideoPlayer(controller.playerController!),

                  // GestureDetector for single tap (toggle controls) and double tap (zoom)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        // Only toggle controls if not significantly scaled,
                        // or if controls are already shown (to allow hiding them)
                        // This prevents accidental control toggling when trying to interact with a zoomed video.
                        // You might want to refine this logic based on UX preference.
                        if (controller.transformationController.value
                                    .getMaxScaleOnAxis() <
                                1.05 ||
                            controller.showControls.value) {
                          controller.toggleVideoControlsVisibility();
                        }
                      },
                      onDoubleTap: () {
                        controller.handleDoubleTap();
                      },
                      behavior:
                          HitTestBehavior.opaque, // Ensures taps are registered
                      child: Container(
                        // Transparent container to catch gestures
                        // Color is transparent, so it doesn't obscure the video
                        color: Colors.transparent,
                      ),
                    ),
                  ),

                  // Video Controls Overlay (remains fixed, not scaled by InteractiveViewer)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Obx(
                      () => AnimatedOpacity(
                        opacity: controller.showControls.value ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: IgnorePointer(
                          ignoring: !controller.showControls.value,
                          child: _buildControlsOverlay(context, controller),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildControlsOverlay(
    BuildContext context,
    VideoPlayerGetxController controller,
  ) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Colors.black54, Colors.black87],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ).copyWith(bottom: MediaQuery.of(context).padding.bottom + 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: <Widget>[
                Obx(
                  () => Text(
                    _formatDuration(controller.currentPosition.value),
                    style: const TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                ),
                Expanded(
                  child: Obx(
                    () =>
                        controller.playerController != null &&
                                controller.playerController!.value.isInitialized
                            ? VideoProgressIndicator(
                              controller.playerController!,
                              allowScrubbing: true,
                              padding: const EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 8.0,
                              ),
                              colors: VideoProgressColors(
                                playedColor:
                                    Theme.of(context).colorScheme.primary,
                                bufferedColor: Colors.white54,
                                backgroundColor: Colors.white24,
                              ),
                            )
                            : SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 0.0,
                                ),
                                overlayShape: RoundSliderOverlayShape(
                                  overlayRadius: 0.0,
                                ),
                                trackHeight: 2.0,
                              ),
                              child: Slider(
                                value: 0,
                                onChanged: null,
                                activeColor: Colors.white24,
                                inactiveColor: Colors.white12,
                              ),
                            ),
                  ),
                ),
                Obx(
                  () => Text(
                    _formatDuration(controller.videoDuration.value),
                    style: const TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    controller.isPlaying.value
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    color: Colors.white,
                    size: 48.0,
                  ),
                  onPressed: () {
                    controller.togglePlayPause();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
