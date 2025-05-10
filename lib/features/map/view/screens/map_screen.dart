import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jourapothole/core/services/map_services.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart';
import 'package:jourapothole/core/utils/constants/app_images.dart';
import 'package:jourapothole/features/glob_widgets/my_map_widget.dart';
import 'package:jourapothole/features/map/view/components/map_problem_sheet.dart';
import 'package:jourapothole/features/reports/view/components/reports_bottom_sheet.dart';

class MapScreen extends StatelessWidget {
  MapScreen({super.key});

  final MapServices _controller = Get.put(MapServices());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (_controller.kGooglePlex.value == null) {
          print("MyMapWidget: kGooglePlex is null, showing loader.");
          return const Center(child: CupertinoActivityIndicator(radius: 20));
        }
        print(
          "MyMapWidget: kGooglePlex is available, building GoogleMap. Target: ${_controller.kGooglePlex.value!.target}",
        );
        return MyMapWidget();
      }),
    );
  }
}
