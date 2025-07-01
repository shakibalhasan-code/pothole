import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:jourapothole/core/utils/constants/app_colors.dart';
import 'package:jourapothole/core/services/location_services.dart';

class MapPickerScreen extends StatefulWidget {
  final Function(double lat, double lng, String address) onLocationSelected;

  const MapPickerScreen({Key? key, required this.onLocationSelected})
    : super(key: key);

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  GoogleMapController? mapController;
  LatLng? selectedLocation;
  String selectedAddress = '';
  bool isLoading = false;
  bool isSearching = false;

  // Search functionality
  final TextEditingController searchController = TextEditingController();
  List<geocoding.Placemark> searchResults = [];
  bool showSearchResults = false;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (searchController.text.length > 2) {
      _performSearch();
    } else {
      setState(() {
        showSearchResults = false;
        searchResults.clear();
      });
    }
  }

  Future<void> _performSearch() async {
    if (searchController.text.isEmpty) return;

    setState(() {
      isSearching = true;
      showSearchResults = true;
    });

    try {
      // Search for multiple locations with the query
      List<geocoding.Location> locations = await geocoding.locationFromAddress(
        searchController.text,
      );

      // Get placemarks for each location to get detailed address information
      List<geocoding.Placemark> placemarks = [];

      for (geocoding.Location location in locations) {
        try {
          List<geocoding.Placemark> marks = await geocoding
              .placemarkFromCoordinates(location.latitude, location.longitude);
          if (marks.isNotEmpty) {
            placemarks.add(marks.first);
          }
        } catch (e) {
          // If reverse geocoding fails for a location, skip it
          continue;
        }
      }

      // Remove duplicates based on address
      final uniquePlacemarks = <String, geocoding.Placemark>{};
      for (var placemark in placemarks) {
        final address = _formatAddress(placemark);
        if (!uniquePlacemarks.containsKey(address)) {
          uniquePlacemarks[address] = placemark;
        }
      }

      setState(() {
        searchResults = uniquePlacemarks.values.toList();
        isSearching = false;
      });
    } catch (e) {
      setState(() {
        isSearching = false;
        searchResults.clear();
      });
      print("Search error: $e");
    }
  }

  String _formatAddress(geocoding.Placemark placemark) {
    List<String> addressParts = [];

    if (placemark.name != null && placemark.name!.isNotEmpty) {
      addressParts.add(placemark.name!);
    }
    if (placemark.street != null && placemark.street!.isNotEmpty) {
      addressParts.add(placemark.street!);
    }
    if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
      addressParts.add(placemark.subLocality!);
    }
    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      addressParts.add(placemark.locality!);
    }
    if (placemark.administrativeArea != null &&
        placemark.administrativeArea!.isNotEmpty) {
      addressParts.add(placemark.administrativeArea!);
    }
    if (placemark.country != null && placemark.country!.isNotEmpty) {
      addressParts.add(placemark.country!);
    }

    return addressParts.join(', ');
  }

  String _getPrimaryText(geocoding.Placemark placemark) {
    // Priority: name > street > subLocality > locality
    if (placemark.name != null && placemark.name!.isNotEmpty) {
      return placemark.name!;
    }
    if (placemark.street != null && placemark.street!.isNotEmpty) {
      return placemark.street!;
    }
    if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
      return placemark.subLocality!;
    }
    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      return placemark.locality!;
    }
    return 'Unknown Location';
  }

  String _getSecondaryText(geocoding.Placemark placemark) {
    List<String> parts = [];

    if (placemark.street != null &&
        placemark.street!.isNotEmpty &&
        placemark.name != placemark.street) {
      parts.add(placemark.street!);
    }
    if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
      parts.add(placemark.subLocality!);
    }
    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      parts.add(placemark.locality!);
    }

    return parts.join(', ');
  }

  String _getTertiaryText(geocoding.Placemark placemark) {
    List<String> parts = [];

    if (placemark.administrativeArea != null &&
        placemark.administrativeArea!.isNotEmpty) {
      parts.add(placemark.administrativeArea!);
    }
    if (placemark.country != null && placemark.country!.isNotEmpty) {
      parts.add(placemark.country!);
    }

    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pick Location',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (selectedLocation != null)
            TextButton(
              onPressed: () => _confirmLocation(context),
              child: const Text(
                'Confirm',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search for a location...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            setState(() {
                              showSearchResults = false;
                              searchResults.clear();
                            });
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primaryLightColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.primaryColor,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ),

          // Search Results
          if (showSearchResults)
            Container(
              constraints: const BoxConstraints(maxHeight: 300),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Search Results',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                        isSearching
                            ? const Center(child: CircularProgressIndicator())
                            : searchResults.isEmpty
                            ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  'No results found',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )
                            : ListView.builder(
                              itemCount: searchResults.length,
                              itemBuilder: (context, index) {
                                final placemark = searchResults[index];
                                final address = _formatAddress(placemark);

                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[200]!,
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.location_on,
                                        color: AppColors.primaryColor,
                                        size: 20,
                                      ),
                                    ),
                                    title: Text(
                                      _getPrimaryText(placemark),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _getSecondaryText(placemark),
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          _getTertiaryText(placemark),
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 12,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    onTap: () async {
                                      // Get coordinates from the placemark
                                      List<geocoding.Location> locations =
                                          await geocoding.locationFromAddress(
                                            address,
                                          );
                                      if (locations.isNotEmpty) {
                                        final location = locations.first;
                                        await _goToLocation(
                                          LatLng(
                                            location.latitude,
                                            location.longitude,
                                          ),
                                        );
                                        setState(() {
                                          showSearchResults = false;
                                          searchResults.clear();
                                          searchController.clear();
                                        });
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
            ),

          // Map
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      Get.find<LocationServices>().latitude,
                      Get.find<LocationServices>().longitude,
                    ),
                    zoom: 15,
                  ),
                  onTap: (LatLng position) {
                    setState(() {
                      selectedLocation = position;
                      isLoading = true;
                    });
                    _getAddressFromCoordinates(position);
                  },
                  markers: _buildMarkers(),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  compassEnabled: true,
                  zoomControlsEnabled: true,
                  mapType: MapType.terrain,
                  trafficEnabled: true,
                ),

                if (isLoading)
                  const Positioned(
                    top: 100,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 16),
                              Text('Getting address...'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Selected Location Info
          if (selectedLocation != null && selectedAddress.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: AppColors.primaryColor),
                      const SizedBox(width: 8),
                      const Text(
                        'Selected Location:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () => _confirmLocation(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Confirm Location'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(selectedAddress, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    'Lat: ${selectedLocation!.latitude.toStringAsFixed(6)}, '
                    'Lng: ${selectedLocation!.longitude.toStringAsFixed(6)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Set<Marker> _buildMarkers() {
    Set<Marker> markers = {};

    // Selected location marker
    if (selectedLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('selected_location'),
          position: selectedLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: 'Selected Location',
            snippet:
                selectedAddress.isNotEmpty
                    ? selectedAddress
                    : 'Getting address...',
          ),
        ),
      );
    }

    return markers;
  }

  Future<void> _goToLocation(LatLng target) async {
    if (mapController != null) {
      await mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(target, 15),
      );
    }
  }

  Future<void> _getAddressFromCoordinates(LatLng position) async {
    try {
      List<geocoding.Placemark> placemarks = await geocoding
          .placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        final geocoding.Placemark place = placemarks[0];
        setState(() {
          selectedAddress =
              "${place.name}, ${place.locality}, ${place.country}";
          isLoading = false;
        });
      } else {
        setState(() {
          selectedAddress = "Address not found";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        selectedAddress = "Error getting address";
        isLoading = false;
      });
      print("Error getting address: $e");
    }
  }

  void _confirmLocation(BuildContext context) {
    if (selectedLocation != null) {
      widget.onLocationSelected(
        selectedLocation!.latitude,
        selectedLocation!.longitude,
        selectedAddress,
      );
      // Force navigation back
      Navigator.pop(context);
    }
  }
}
