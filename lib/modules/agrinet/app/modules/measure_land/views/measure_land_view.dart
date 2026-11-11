import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../components/ui/ag_appbar.dart';
import '../../../components/ui/ag_button.dart';
import '../../../components/ui/ag_snackbar.dart';
import '../../../data/remote/providers/google_map_service.dart';
import '../../../theme/ag_text_styles.dart';
import '../controllers/measure_land_controller.dart';

class MeasureLandView extends GetView<MeasureLandController> {
  const MeasureLandView({super.key});

  @override
  Widget build(BuildContext context) {
    final mapService = Get.find<GoogleMapService>();

    return Scaffold(
      appBar: AgAppbar(title: "Measure Land"),
      extendBody: true,

      body: Obx(() {
        if (!controller.isReady.value ||
            mapService.currentLocation.value == null) {
          return const Center(child: AgLoader());
        }

        return Stack(
          children: [
            GoogleMap(
              mapType: mapService.mapType.value,
              initialCameraPosition: CameraPosition(
                target: LatLng(12.9630208, 77.7322496),
                zoom: 17,
              ),
              onMapCreated: mapService.onMapCreated,
              markers: mapService.markers.toSet(),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),

            // Draw Polyline Button
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 260,
                  child: AgButton(
                    title: "Draw Polyline",
                    onTap: () {
                      agSnackbar(title: 'Coming soon', msg: '');
                    },
                  ),
                ),
              ),
            ),

            // MapType Floating Button
            Positioned(
              bottom: 90,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                elevation: 4,
                child: const Icon(Icons.layers, color: Colors.black),
                onPressed: () => _showMapTypeDialog(),
              ),
            ),
          ],
        );
      }),
    );
  }

  // -------------------------
  // POPUP FOR MAP TYPE
  // -------------------------
  void _showMapTypeDialog() {
    Get.dialog(
      Center(
        child: Container(
          width: Get.width * 0.85,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0EE),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.layers,
                      size: 28,
                      color: Color(0xFF496C3A),
                    ),
                    const SizedBox(width: 10),
                    Text("Select MapType:-", style: kw600Primary18),
                  ],
                ),
                const SizedBox(height: 20),

                _mapTypeOption("Normal", MapType.normal),
                _mapTypeOption("Satellite", MapType.satellite),
                _mapTypeOption("Terrain", MapType.terrain),
                _mapTypeOption("Hybrid", MapType.hybrid),

                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: const Text(
                      "CANCEL",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF496C3A),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.35),
    );
  }

  Widget _mapTypeOption(String label, MapType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          controller.mapService.mapType.value = type;
          Get.back();
        },
        child: Text("Type : $label", style: kw500Primary16),
      ),
    );
  }
}
