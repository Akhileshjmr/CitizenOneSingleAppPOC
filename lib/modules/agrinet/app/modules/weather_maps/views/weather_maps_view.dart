import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../data/remote/providers/google_map_service.dart';
import '../../../data/remote/providers/weather_api_service.dart';
import '../../../data/remote/providers/weather_map_tile_provider.dart';
import '../../../utils/ag_colors.dart';
import '../controllers/weather_maps_controller.dart';

class WeatherMapsView extends GetView<WeatherMapsController> {
  const WeatherMapsView({super.key});

  @override
  Widget build(BuildContext context) {
    final google = Get.find<GoogleMapService>();

    return Scaffold(
      appBar: AgAppbar(
        title: "Weather Maps",
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.white),
            onPressed: controller.moveToCurrentLocation,
          ),
        ],
      ),
      body: Obx(() {
        final loc = google.currentLocation.value;

        if (loc == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                initialCenter: LatLng(loc.latitude, loc.longitude),
                initialZoom: 10,
                minZoom: 2,
                maxZoom: 18,
              ),
              children: [
                // Base map layer
                TileLayer(
                  urlTemplate:
                      "${WeatherService.defaultMapBaseUrl}/{z}/{x}/{y}.png",
                  userAgentPackageName: "agrinet.app",
                ),
                // Weather overlay
                Obx(() {
                  final layerKey = controller.currentLayerKey;

                  return TileLayer(
                    tileProvider: WeatherTileProvider(layerKey),
                    urlTemplate:
                        "https://tile.openweathermap.org/map/$layerKey/{z}/{x}/{y}.png?appid=${WeatherService.apiKey}",
                    userAgentPackageName: "agrinet.app",
                  );
                }),
              ],
            ),

            // Tile loading indicator
            Obx(() {
              if (!controller.isLoadingTiles.value) {
                return const SizedBox.shrink();
              }

              return Container(
                color: Colors.black26,
                child: const Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AgLoader(),
                          SizedBox(height: 16),
                          Text(
                            "Loading weather layer...",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      }),

      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: controller.currentTabIndex.value,
          onTap: controller.changeTab,
          selectedItemColor: AgColors.colorPrimary,
          unselectedItemColor: Colors.grey.shade600,
          type: BottomNavigationBarType.fixed,
          items:
              controller.tabs.map((tab) {
                return BottomNavigationBarItem(
                  icon: Icon(tab["icon"] as IconData),
                  label: tab["label"] as String,
                );
              }).toList(),
        );
      }),
    );
  }
}
