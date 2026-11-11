import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../data/remote/providers/weather_api_service.dart';

class WeatherTileProvider extends TileProvider {
  final String layer;

  WeatherTileProvider(this.layer);

  @override
  ImageProvider getImage(TileCoordinates coords, TileLayer options) {
    final url = WeatherService.tileUrl(
      layer,
      coords.x,
      coords.y,
      coords.z.toInt(),
    );

    return NetworkImage(url);
  }
}
