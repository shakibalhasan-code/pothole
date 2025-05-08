import 'dart:async';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jourapothole/core/services/location_services.dart';

class MapServices extends GetxService {
  ///fetch the location services
  final locationServices = Get.find<LocationServices>();

  final Completer<GoogleMapController> controller =
      Completer<GoogleMapController>();
  late CameraPosition kGooglePlex;

  @override
  void onInit() async {
    super.onInit();
    await locationServices.getUserLocationWithAddress();
    kGooglePlex = CameraPosition(
      target: LatLng(locationServices.latt, locationServices.long),
      zoom: 14.4746,
    );
  }
}
