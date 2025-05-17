import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class LocationServices extends GetxService {
  final userCurrentLocation = ''.obs;

  double longitude = 0.0;
  double latitude = 0.0;

  @override
  void onInit() async {
    super.onInit();
    await getUserLocationWithAddress();
  }

  Future<void> getUserLocationWithAddress() async {
    try {
      Position position = await determinePosition();
      userCurrentLocation.value = "Getting location...";
      longitude = position.longitude;
      latitude = position.latitude;
      await getAddressFromLatLng(position);
    } catch (e) {
      userCurrentLocation.value = 'Failed to get location: $e';
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Prompt the user to enable location services.
      await Geolocator.openLocationSettings();
      throw Exception('Location services are disabled.');
    }

    // Check the current permission status.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, prompt the user to enable them in settings.
      await Geolocator.openAppSettings();
      throw Exception('Location permissions are permanently denied.');
    }

    // When permissions are granted, get the position.
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> getAddressFromLatLng(Position position) async {
    try {
      longitude = position.longitude;
      latitude = position.latitude;

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks[0];
        userCurrentLocation.value =
            "${place.name}, ${place.locality}, ${place.country}";
      } else {
        userCurrentLocation.value = "Address not found";
      }
    } catch (e) {
      userCurrentLocation.value = "Failed to get address: $e";
      printError(info: "Failed to get address: $e");
    }
  }
}
