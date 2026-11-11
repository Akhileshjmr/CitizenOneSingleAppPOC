import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/soil_maps_controller.dart';

class SoilMapsView extends GetView<SoilMapsController> {
  const SoilMapsView({super.key});
  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Scaffold(
      appBar: AgAppbar(title: 'Soil Maps'),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFF1F7F4), // light background for the top area
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Text(
                        'Latitude',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Obx(
                        () => Text(
                          c.latitude.value.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Text(
                        'Longitude',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Obx(
                        () => Text(
                          c.longitude.value.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Map area (flexible)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Obx(
                  () => GoogleMap(
                    initialCameraPosition: c.cameraPosition.value,
                    onMapCreated: c.onMapCreated,
                    markers: c.markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: false,
                    onCameraMove: (pos) {
                      // Optionally reflect camera center to lat/lng
                      // not updating state here to avoid excessive updates
                    },
                    onTap: (latLng) {
                      // Example — update marker when user taps map
                      c.updateLocation(latLng.latitude, latLng.longitude);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom "Get Soil Report" button
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: AgButton(
          title: "Get Soil Report",
          onTap: c.onGetSoilReportPressed,
        ),
      ),
    );
  }
}
