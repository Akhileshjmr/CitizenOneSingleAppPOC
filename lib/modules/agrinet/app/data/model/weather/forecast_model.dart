// lib/app/data/model/weather/forecast_model.dart

import 'current_weather.dart';
import 'forecast_entry.dart';

class WeatherForecast {
  final List<ForecastEntry> list;
  final City city;

  WeatherForecast({required this.list, required this.city});

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      list:
          (json["list"] as List).map((e) => ForecastEntry.fromJson(e)).toList(),
      city: City.fromJson(json["city"]),
    );
  }
}

class City {
  final String name;
  final Coord coord;
  final String country;
  final int sunrise;
  final int sunset;

  City({
    required this.name,
    required this.coord,
    required this.country,
    required this.sunrise,
    required this.sunset,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json["name"],
      coord: Coord.fromJson(json["coord"]),
      country: json["country"],
      sunrise: json["sunrise"],
      sunset: json["sunset"],
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "coord": coord.toJson(),
    "country": country,
    "sunrise": sunrise,
    "sunset": sunset,
  };
}
