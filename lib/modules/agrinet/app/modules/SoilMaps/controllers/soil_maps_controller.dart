import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../routes/app_pages.dart';
import '../../FarmingDashboard/bindings/farming_dashboard_binding.dart';

class SoilMapsController extends GetxController {
  //TODO: Implement SoilMapsController
  final RxDouble latitude = 37.4219983.obs;
  final RxDouble longitude = (-122.084).obs;

  final Rx<CameraPosition> cameraPosition =
      CameraPosition(target: LatLng(37.4219983, -122.084), zoom: 12.0).obs;

  GoogleMapController? mapController;

  final RxSet<Marker> markers = <Marker>{}.obs;

  late FarmArguments args;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is FarmArguments) {
      args = Get.arguments;
    }
    _initMarker();
  }

  void _initMarker() {
    final marker = Marker(
      markerId: const MarkerId('soil_pin'),
      position: LatLng(latitude.value, longitude.value),
      infoWindow: const InfoWindow(title: 'Selected location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    markers.add(marker);
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // Center camera on the selected lat/lng (useful if user taps button)
  Future<void> moveCameraToLocation() async {
    if (mapController == null) return;
    final pos = CameraPosition(
      target: LatLng(latitude.value, longitude.value),
      zoom: 15,
    );
    await mapController!.animateCamera(CameraUpdate.newCameraPosition(pos));
  }

  // Example: update coords (if user drags a pin in your real use-case)
  void updateLocation(double lat, double lng) {
    latitude.value = lat;
    longitude.value = lng;

    markers.clear();
    markers.add(
      Marker(markerId: const MarkerId('soil_pin'), position: LatLng(lat, lng)),
    );

    moveCameraToLocation();
  }

  void onGetSoilReportPressed() {
    // Replace with your actual action/route
    // Get.snackbar('Soil Report', 'Requesting soil report for selected location',
    //     snackPosition: SnackPosition.BOTTOM);
    Get.toNamed(
      Routes.SOIL_ASSESSMENT,
      arguments: soilArguments(
        farmingPlanId: args.farmingPlanId,
        farmingStatus: args.farmingStatus,
        latitude: latitude.value,
        longitude: longitude.value,
      ),
    );
  }
}
