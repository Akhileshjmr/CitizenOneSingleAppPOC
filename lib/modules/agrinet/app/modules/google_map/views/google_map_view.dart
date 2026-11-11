import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/google_map_controller.dart';

class GoogleMapView extends GetView<GoogleMapComponentController> {
  const GoogleMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Map')),
      body: Obx(
        () => GoogleMap(
          mapType: MapType.terrain,
          onMapCreated: controller.onMapCreated,
          initialCameraPosition: CameraPosition(
            target: controller.locations[0],
            zoom: 14,
          ),
          markers: controller.markers.toSet(),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ),
      ),
    );
  }
}
