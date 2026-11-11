import 'package:citizenone_app/modules/agrinet/app/modules/google_map/controllers/market_price_bottomsheet.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapComponentController extends GetxController {
  GoogleMapComponentController();

  GoogleMapController? mapController;
  final List<LatLng> locations = const [
    LatLng(22.3072, 73.1812),
    LatLng(23.0225, 72.5714),
    LatLng(21.1702, 72.8311),
    LatLng(22.4707, 70.0577),
    LatLng(21.6417, 69.6293),
  ];

  var markers = <Marker>{}.obs;

  @override
  void onInit() {
    addMultipleMarkers();
    super.onInit();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // Future<void> _getCurrentPosition() async {
  //   LocationPermission permission = await Geolocator.requestPermission();
  //   Position position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );

  //   currentLocation.value = LatLng(position.latitude, position.longitude);
  //   addMarker(currentLocation.value, "Your Location");

  //   mapController?.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(target: currentLocation.value, zoom: 15),
  //     ),
  //   );
  // }

  void addMultipleMarkers() {
    for (var i = 0; i < locations.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId("marker_$i"),
          position: locations[i],
          infoWindow: InfoWindow(title: "Location $i"),
          onTap: () {
            onMarkerTap("Bharuch, Gujarat");
          },
        ),
      );
    }
  }
}

void onMarkerTap(String title) {
  Get.bottomSheet(
    MarketPriceBottomSheet(title: title),
    isScrollControlled: true,
    backgroundColor: AgColors.kWhite,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
  );
}
