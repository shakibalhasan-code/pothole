import 'package:flutter/material.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart';
import 'package:jourapothole/core/utils/constants/app_images.dart';
import 'package:jourapothole/features/map/view/components/map_problem_sheet.dart';
import 'package:jourapothole/features/reports/view/components/reports_bottom_sheet.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        automaticallyImplyLeading: false, // Remove back button if not needed
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Add report functionality here (e.g., show bottom sheet)
                showModalBottomSheet(
                  context: context,
                  backgroundColor: AppColors.whiteColor,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) => const PotholeReportBottomSheet(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Report Now',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map Placeholder (Replace with actual Google Maps widget)
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => const ProblemBottomSheet(),
              );
            },
            child: Center(
              child: Image.asset(
                AppImages.mapImage,
                filterQuality: FilterQuality.none,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Floating markers (for visual effect, replace with actual map markers)
          Positioned(top: 50, left: 50, child: _buildMarker(Colors.red)),
          Positioned(top: 150, right: 50, child: _buildMarker(Colors.blue)),
          Positioned(bottom: 100, left: 50, child: _buildMarker(Colors.green)),
        ],
      ),
    );
  }

  Widget _buildMarker(Color color) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.7),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: const Center(
        child: Icon(Icons.location_pin, color: Colors.white, size: 20),
      ),
    );
  }
}
