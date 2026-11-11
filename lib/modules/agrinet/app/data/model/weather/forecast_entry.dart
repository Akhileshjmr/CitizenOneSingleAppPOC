import 'package:intl/intl.dart';

import 'current_weather.dart';

class ForecastEntry {
  final int dt; // UNIX timestamp (seconds)
  final MainData main;
  final List<Weather> weather;
  final Clouds clouds;
  final Wind wind;
  final String dtTxt;

  /// Rain volume in last 3 hours (mm)
  final double rain;

  ForecastEntry({
    required this.dt,
    required this.main,
    required this.weather,
    required this.clouds,
    required this.wind,
    required this.dtTxt,
    required this.rain,
  });

  /// Convert UNIX timestamp → DateTime
  DateTime get date => DateTime.fromMillisecondsSinceEpoch(dt * 1000).toLocal();

  // ---------------------------------------------------------
  // 🔥 ROUNDED GETTERS (for UI)
  // ---------------------------------------------------------

  /// Rounded temperature (example: 19.3)
  String get temp1 => main.temp.toStringAsFixed(1);

  /// Rounded feels-like temperature
  String get feelsLike1 => main.feelsLike.toStringAsFixed(1);

  /// Rounded humidity with %
  String get humidity1 => "${main.humidity} %";

  /// Rounded pressure with unit
  String get pressure1 => "${main.pressure} hPa";

  /// Rounded wind speed (example: 3.4)
  String get wind1 => wind.speed.toStringAsFixed(1);

  /// Primary weather description
  String get description => weather.isNotEmpty ? weather.first.description : "";

  /// Weather icon code (e.g., "10d")
  String get icon => weather.isNotEmpty ? weather.first.icon : "";

  /// 🌤 FULL icon URL ready to use in Image.network()
  String get iconUrl => "https://openweathermap.org/img/wn/${icon}@2x.png";

  /// Formatted time (HH:mm)
  String get timeFormatted => DateFormat("HH:mm").format(date);

  /// Formatted readable date
  String get dateFormatted => DateFormat("EEE dd MMM").format(date);

  // ---------------------------------------------------------
  // 🔄 JSON PARSER
  // ---------------------------------------------------------
  factory ForecastEntry.fromJson(Map<String, dynamic> json) {
    return ForecastEntry(
      dt: json["dt"],
      main: MainData.fromJson(json["main"]),
      weather:
          (json["weather"] as List).map((e) => Weather.fromJson(e)).toList(),
      clouds: Clouds.fromJson(json["clouds"]),
      wind: Wind.fromJson(json["wind"]),
      dtTxt: json["dt_txt"] ?? "",

      /// Rain safely parsed (0.0 if null)
      rain: json["rain"] != null ? (json["rain"]["3h"] ?? 0.0).toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    "dt": dt,
    "main": main.toJson(),
    "weather": weather.map((w) => w.toJson()).toList(),
    "clouds": clouds.toJson(),
    "wind": wind.toJson(),
    "dt_txt": dtTxt,
    "rain": rain,
  };
}
