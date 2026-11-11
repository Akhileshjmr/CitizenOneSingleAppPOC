import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../data/remote/providers/google_map_service.dart';

class WeatherMapsController extends GetxController {
  final google = Get.find<GoogleMapService>();

  // Flutter map controller
  final MapController mapController = MapController();

  // Current selected tab index
  RxInt currentTabIndex = 0.obs;

  // Loading state for tile layers
  RxBool isLoadingTiles = false.obs;

  // Available weather overlays
  final List<Map<String, dynamic>> tabs = [
    {"key": "precipitation_new", "label": "Rain", "icon": Icons.water_drop},
    {"key": "wind_new", "label": "Wind", "icon": Icons.air},
    {"key": "temp_new", "label": "Temperature", "icon": Icons.thermostat},
  ];

  // Get current layer key
  String get currentLayerKey => tabs[currentTabIndex.value]["key"] as String;

  @override
  void onInit() {
    super.onInit();
    // Show loader briefly when first loading
    isLoadingTiles.value = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      isLoadingTiles.value = false;
    });
  }

  // Change weather tab
  void changeTab(int index) {
    if (index == currentTabIndex.value) return;

    currentTabIndex.value = index;

    // Show loader while tiles are loading
    isLoadingTiles.value = true;
    Future.delayed(const Duration(milliseconds: 600), () {
      isLoadingTiles.value = false;
    });
  }

  // Move map to current location
  void moveToCurrentLocation() {
    final loc = google.currentLocation.value;
    if (loc == null) return;

    mapController.move(
      LatLng(loc.latitude, loc.longitude),
      10, // zoom level
    );
  }
}
