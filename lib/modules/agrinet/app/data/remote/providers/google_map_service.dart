import 'dart:developer';
import 'dart:ui';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapService extends GetxService {
  GoogleMapController? mapController;

  Rx<LatLng?> currentLocation = Rx<LatLng?>(null);
  RxBool mapReady = false.obs;
  Rx<MapType> mapType = MapType.normal.obs;

  RxSet<Marker> markers = <Marker>{}.obs;

  Future<GoogleMapService> initLocationService() async {
    await _handleLocationPermission();
    return this;
  }

  // -----------------------------------------------------------
  // PROPER LOCATION PERMISSION + FALLBACK (ALWAYS RETURNS VALUE)
  // -----------------------------------------------------------
  Future<void> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled, use fallback
      currentLocation.value = const LatLng(12.9630208, 77.7322496);
      log("Location services disabled, using fallback location");
      return;
    }

    // Check current permission status
    permission = await Geolocator.checkPermission();

    // Denied → request again
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Denied forever (never allowed)
    if (permission == LocationPermission.deniedForever) {
      // Fallback location so map loads
      currentLocation.value = const LatLng(12.9630208, 77.7322496);
      log("Location permission denied forever, using fallback location");
      return;
    }

    // STILL denied → fallback
    if (permission == LocationPermission.denied) {
      currentLocation.value = const LatLng(12.9630208, 77.7322496);
      log("Location permission denied, using fallback location");
      return;
    }

    // Now permission is granted → get actual GPS
    try {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentLocation.value = LatLng(pos.latitude, pos.longitude);
      log("Got current location: ${pos.latitude}, ${pos.longitude}");
    } catch (e) {
      // If there's any error getting location, use fallback
      currentLocation.value = const LatLng(12.9630208, 77.7322496);
      log("Error getting location: $e, using fallback");
    }
  }

  // -----------------------------------------------------------
  // GOOGLE MAP INITIALIZED
  // -----------------------------------------------------------
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    print("Map controller created");

    if (currentLocation.value != null) {
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(currentLocation.value!, 17),
      );
    }

    Future.delayed(const Duration(milliseconds: 400), () {
      mapReady.value = true;
    });
  }

  // -----------------------------------------------------------
  // ADD MARKER
  // -----------------------------------------------------------
  void addMarker({
    required String id,
    required LatLng position,
    String? label,
    BitmapDescriptor? icon,
    VoidCallback? onTap,
  }) {
    markers.add(
      Marker(
        markerId: MarkerId(id),
        position: position,
        icon: icon ?? BitmapDescriptor.defaultMarker,
        infoWindow:
            label != null ? InfoWindow(title: label) : const InfoWindow(),
        onTap: onTap,
      ),
    );

    markers.refresh();
  }
}
