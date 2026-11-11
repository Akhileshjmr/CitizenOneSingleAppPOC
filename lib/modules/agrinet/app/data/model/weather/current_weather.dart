import 'package:intl/intl.dart';

class WeatherCurrent {
  final Coord coord;
  final List<Weather> weather;
  final MainData main;
  final Wind wind;
  final Clouds clouds;
  final int dt;
  final Sys sys;
  final String name;

  WeatherCurrent({
    required this.coord,
    required this.weather,
    required this.main,
    required this.wind,
    required this.clouds,
    required this.dt,
    required this.sys,
    required this.name,
  });

  factory WeatherCurrent.fromJson(Map<String, dynamic> json) {
    return WeatherCurrent(
      coord: Coord.fromJson(json["coord"]),
      weather:
          (json["weather"] as List).map((e) => Weather.fromJson(e)).toList(),
      main: MainData.fromJson(json["main"]),
      wind: Wind.fromJson(json["wind"]),
      clouds: Clouds.fromJson(json["clouds"]),
      dt: json["dt"],
      sys: Sys.fromJson(json["sys"]),
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "coord": coord.toJson(),
      "weather": weather.map((e) => e.toJson()).toList(),
      "main": main.toJson(),
      "wind": wind.toJson(),
      "clouds": clouds.toJson(),
      "dt": dt,
      "sys": sys.toJson(),
      "name": name,
    };
  }

  // ---------------------------------------------------------
  // 🔥 UI-FRIENDLY FORMATTED GETTERS
  // ---------------------------------------------------------

  /// Temperature rounded to one decimal
  String get temp1 => main.temp.toStringAsFixed(1);

  /// Feels-like temperature rounded
  String get feelsLike1 => main.feelsLike.toStringAsFixed(1);

  /// Wind speed rounded to 1 decimal
  String get windSpeed1 => wind.speed.toStringAsFixed(1);

  /// "65 %" style humidity
  String get humidity1 => "${main.humidity} %";

  /// "1015 hPa" style pressure
  String get pressure1 => "${main.pressure} hPa";

  /// Weather description
  String get description => weather.isNotEmpty ? weather.first.description : "";

  /// Local sunrise time
  String get sunriseFormatted => DateFormat(
    "h:mm a",
  ).format(DateTime.fromMillisecondsSinceEpoch(sys.sunrise * 1000).toLocal());

  /// Local sunset time
  String get sunsetFormatted => DateFormat(
    "h:mm a",
  ).format(DateTime.fromMillisecondsSinceEpoch(sys.sunset * 1000).toLocal());
}

// ===================================================================
// SUPPORTING MODELS
// ===================================================================

class Coord {
  final double lat;
  final double lon;

  Coord({required this.lat, required this.lon});

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(
      lat: (json["lat"] as num).toDouble(),
      lon: (json["lon"] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {"lat": lat, "lon": lon};
}

class Weather {
  final int id;
  final String main;
  final String description;
  final String icon;

  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: json["id"],
      main: json["main"],
      description: json["description"],
      icon: json["icon"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "main": main,
    "description": description,
    "icon": icon,
  };
}

class MainData {
  final double temp;
  final double feelsLike;
  final int pressure;
  final int humidity;

  MainData({
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
  });

  factory MainData.fromJson(Map<String, dynamic> json) {
    return MainData(
      temp: (json["temp"] as num).toDouble(),
      feelsLike: (json["feels_like"] as num).toDouble(),
      pressure: (json["pressure"] as num).toInt(),
      humidity: (json["humidity"] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
    "temp": temp,
    "feels_like": feelsLike,
    "pressure": pressure,
    "humidity": humidity,
  };

  // Formatted getters
  String get temp1 => temp.toStringAsFixed(1);
  String get feelsLike1 => feelsLike.toStringAsFixed(1);
  String get pressure1 => "$pressure hPa";
  String get humidity1 => "$humidity %";
}

class Wind {
  final double speed;
  final int deg;

  Wind({required this.speed, required this.deg});

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: (json["speed"] as num).toDouble(),
      deg: (json["deg"] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {"speed": speed, "deg": deg};

  String get speed1 => speed.toStringAsFixed(1);
}

class Clouds {
  final int all;

  Clouds({required this.all});

  factory Clouds.fromJson(Map<String, dynamic> json) {
    return Clouds(all: json["all"]);
  }

  Map<String, dynamic> toJson() => {"all": all};
}

class Sys {
  final String country;
  final int sunrise;
  final int sunset;

  Sys({required this.country, required this.sunrise, required this.sunset});

  factory Sys.fromJson(Map<String, dynamic> json) {
    return Sys(
      country: json["country"],
      sunrise: json["sunrise"],
      sunset: json["sunset"],
    );
  }

  Map<String, dynamic> toJson() => {
    "country": country,
    "sunrise": sunrise,
    "sunset": sunset,
  };
}
