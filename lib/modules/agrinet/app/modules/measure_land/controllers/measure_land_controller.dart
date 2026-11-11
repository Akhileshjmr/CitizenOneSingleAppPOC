import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../data/remote/providers/google_map_service.dart';

class MeasureLandController extends GetxController {
  final GoogleMapService mapService = Get.find<GoogleMapService>();

  RxBool isReady = false.obs;
  Rx<LatLng?> selectedMarkerPosition = Rx<LatLng?>(null);
  RxString selectedMarkerId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initMap();
  }

  Future<void> _initMap() async {
    print("INITIALIZING MAP...");
    await mapService.initLocationService();

    // Wait a bit for the location to be set
    await Future.delayed(const Duration(milliseconds: 500));

    _addPersonMarker();

    isReady.value = true;
  }

  void _addPersonMarker() {
    if (mapService.currentLocation.value == null) return;

    mapService.addMarker(
      id: "person_marker",
      label: "M1",
      position: mapService.currentLocation.value!,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      onTap: () {
        selectedMarkerId.value = "M1";
        selectedMarkerPosition.value = mapService.currentLocation.value!;
      },
    );
  }
}
