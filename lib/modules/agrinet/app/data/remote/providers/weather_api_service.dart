import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../model/weather/current_weather.dart';
import '../../model/weather/forecast_model.dart';
import '../api_service/init_api_service.dart';

class WeatherService {
  static const String apiKey = "80b372530045d7ed4f29feae51e6830d";

  //base weather url foe weather and forecast
  static const String _weatherBaseUrl = "https://api.openweathermap.org";

  //base weather map tile
  static const String defaultMapBaseUrl = "https://tile.openstreetmap.org";
  static const String mapTileBaseUrl = "https://tile.openweathermap.org";

  // ------------------------------------------------------------------
  // TILE URL BUILDER (Used for weather maps)
  // ------------------------------------------------------------------
  static String tileUrl(String layer, int x, int y, int z) {
    return "$mapTileBaseUrl/map/$layer/$z/$x/$y.png?appid=$apiKey";
  }

  // ------------------------------------------------------------------
  // FETCH TILE IMAGE (Used by WeatherTileProvider)
  // ------------------------------------------------------------------
  Future<Uint8List> fetchTile(String layer, int x, int y, int z) async {
    final url = tileUrl(layer, x, y, z);

    try {
      final response = await APIService.dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.data != null) {
        return Uint8List.fromList(response.data!);
      }
    } catch (e) {
      print("❌ Tile Fetch Error: $e");
    }

    return Uint8List(0);
  }

  // ------------------------------------------------------------------
  // CURRENT WEATHER - LAT/LON
  // ------------------------------------------------------------------
  Future<WeatherCurrent?> fetchCurrent(double lat, double lon) async {
    final path = "/data/2.5/weather";

    final res = await APIService.get(
      forcedBaseUrl: _weatherBaseUrl,
      path: path,
      params: {"lat": lat, "lon": lon, "appid": apiKey, "units": "metric"},
    );

    if (res?.data == null) return null;

    try {
      return WeatherCurrent.fromJson(res!.data!);
    } catch (e) {
      print("❌ Parsing Current Weather Error: $e");
      return null;
    }
  }

  // ------------------------------------------------------------------
  // FORECAST - LAT/LON
  // ------------------------------------------------------------------
  Future<WeatherForecast?> fetchForecast(double lat, double lon) async {
    final path = "/data/2.5/forecast";

    final res = await APIService.get(
      forcedBaseUrl: _weatherBaseUrl,
      path: path,
      params: {"lat": lat, "lon": lon, "appid": apiKey, "units": "metric"},
    );

    if (res?.data == null) return null;

    try {
      return WeatherForecast.fromJson(res!.data!);
    } catch (e) {
      print("❌ Parsing Forecast Error: $e");
      return null;
    }
  }

  // ------------------------------------------------------------------
  // CURRENT WEATHER - CITY
  // ------------------------------------------------------------------
  Future<WeatherCurrent?> fetchCurrentByCity(String city) async {
    final path = "/data/2.5/weather";

    final res = await APIService.get(
      forcedBaseUrl: _weatherBaseUrl,
      path: path,
      params: {"q": city, "appid": apiKey, "units": "metric"},
    );

    if (res?.data == null) return null;

    try {
      return WeatherCurrent.fromJson(res!.data!);
    } catch (e) {
      print("❌ Parsing City Weather Error: $e");
      return null;
    }
  }

  // ------------------------------------------------------------------
  // FORECAST - CITY
  // ------------------------------------------------------------------
  Future<WeatherForecast?> fetchForecastByCity(String city) async {
    final path = "/data/2.5/forecast";

    final res = await APIService.get(
      forcedBaseUrl: _weatherBaseUrl,
      path: path,
      params: {"q": city, "appid": apiKey, "units": "metric"},
    );

    if (res?.data == null) return null;

    try {
      return WeatherForecast.fromJson(res!.data!);
    } catch (e) {
      print("❌ Parsing City Forecast Error: $e");
      return null;
    }
  }
}
