import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class LocationServices extends GetxService {
  final userCurrentLocation = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    await getUserLocationWithAddress();
  }

  Future<void> getUserLocationWithAddress() async {
    try {
      Position position = await determinePosition();
      await getAddressFromLatLng(position);
    } catch (e) {
      userCurrentLocation.value = 'Failed to get location: $e';
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied.';
    }

    final LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
  }

  Future<void> getAddressFromLatLng(Position position) async {
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
  }
}
