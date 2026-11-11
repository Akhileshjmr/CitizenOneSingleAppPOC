import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/model/weather/current_weather.dart';
import '../../../data/model/weather/forecast_entry.dart';
import '../../../data/model/weather/forecast_model.dart';
import '../../../data/remote/providers/google_map_service.dart';
import '../../../data/remote/providers/weather_api_service.dart';

class WeatherController extends GetxController {
  RxBool isLoading = true.obs;

  // Currently selected city ("" means GPS mode)
  RxString selectedCity = "".obs;

  // Typed models
  Rx<WeatherCurrent?> current = Rx<WeatherCurrent?>(null);
  Rx<WeatherForecast?> forecast = Rx<WeatherForecast?>(null);

  // Grouped forecast lists
  Map<String, List<ForecastEntry>> grouped = {
    "today": [],
    "tomorrow": [],
    "later": [],
  };

  List<ForecastEntry> getForecast(String key) => grouped[key] ?? [];

  @override
  void onInit() {
    super.onInit();
    fetchWeather(); // Load GPS weather first
  }

  // ---------------------------------------------------
  // FETCH WEATHER USING GPS
  // ---------------------------------------------------
  Future<void> fetchWeather() async {
    try {
      isLoading.value = true;
      selectedCity.value = ""; // reset → GPS mode

      final map = Get.find<GoogleMapService>();
      await map.initLocationService();

      final loc = map.currentLocation.value!;
      final service = WeatherService();

      final cur = await service.fetchCurrent(loc.latitude, loc.longitude);
      final fore = await service.fetchForecast(loc.latitude, loc.longitude);

      if (cur == null || fore == null) {
        throw "Invalid Weather API Response";
      }

      current.value = cur;
      forecast.value = fore;

      _groupForecast(fore.list);
    } catch (e) {
      print("Weather Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------
  // REFRESH WEATHER → CITY OR GPS BASED
  // ---------------------------------------------------
  void refreshWeather() {
    if (selectedCity.value.isNotEmpty) {
      fetchWeatherByCity(selectedCity.value); // refresh searched city
    } else {
      fetchWeather(); // refresh GPS weather
    }
  }

  // ---------------------------------------------------
  // FETCH WEATHER BY CITY NAME
  // ---------------------------------------------------
  Future<void> fetchWeatherByCity(String city) async {
    try {
      isLoading.value = true;
      selectedCity.value = city; // important: keep selected city

      final service = WeatherService();

      final cur = await service.fetchCurrentByCity(city);
      final fore = await service.fetchForecastByCity(city);

      if (cur == null || fore == null) {
        agSnackbar(title: "Error", msg: "City not found");
        return;
      }

      current.value = cur;
      forecast.value = fore;

      _groupForecast(fore.list);
    } catch (e) {
      print("City Weather Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------
  // GROUP FORECAST DATA INTO TODAY / TOMORROW / LATER
  // ---------------------------------------------------
  void _groupForecast(List<ForecastEntry> list) {
    grouped["today"] = [];
    grouped["tomorrow"] = [];
    grouped["later"] = [];

    final now = DateTime.now();

    for (var item in list) {
      final dt = item.date; // dt → DateTime from model

      if (dt.day == now.day) {
        grouped["today"]!.add(item);
      } else if (dt.day == now.add(const Duration(days: 1)).day) {
        grouped["tomorrow"]!.add(item);
      } else {
        grouped["later"]!.add(item);
      }
    }
  }

  // ---------------------------------------------------
  // HELPERS
  // ---------------------------------------------------
  String formatEpoch(int epoch) => DateFormat(
    "h:mm a",
  ).format(DateTime.fromMillisecondsSinceEpoch(epoch * 1000));

  String formatTemp(double t) => "${t.toStringAsFixed(1)} °C";

  String windDirection(int deg) {
    int toDeg = (deg + 180) % 360;

    if (toDeg >= 337 || toDeg < 23) return "↑"; // N
    if (toDeg >= 23 && toDeg < 68) return "↗︎"; // NE (text-safe)
    if (toDeg >= 68 && toDeg < 113) return "→"; // E
    if (toDeg >= 113 && toDeg < 158) return "↘︎"; // SE (text-safe)
    if (toDeg >= 158 && toDeg < 203) return "↓"; // S
    if (toDeg >= 203 && toDeg < 248) return "↙︎"; // SW (text-safe)
    if (toDeg >= 248 && toDeg < 293) return "←"; // W
    return "↖︎"; // NW (text-safe)
  }
}
