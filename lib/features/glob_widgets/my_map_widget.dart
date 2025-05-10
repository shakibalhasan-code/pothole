// widgets/my_map_widget.dart (or wherever you place it)
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jourapothole/core/services/map_services.dart';

class MyMapWidget extends StatelessWidget {
  MyMapWidget({super.key});

  final MapServices _controller = Get.find<MapServices>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.kGooglePlex.value == null) {
        print("MyMapWidget: kGooglePlex is null, showing loader.");
        return const Center(child: CupertinoActivityIndicator(radius: 20));
      }
      print(
        "MyMapWidget: kGooglePlex is available, building GoogleMap. Target: ${_controller.kGooglePlex.value!.target}",
      );
      return GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _controller.kGooglePlex.value!,
        onMapCreated: (GoogleMapController controller) {
          if (!_controller.controller.isCompleted) {
            _controller.controller.complete(controller);
            print("GoogleMap onMapCreated: Controller completed.");
          }
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _controller.markers, // 👈 this shows pothole markers!
      );
    });
  }
}
