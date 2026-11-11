import 'package:citizenone_app/modules/agrinet/app/modules/weather/views/widgets/weather_icons.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/weather/views/widgets/wind_arrow_widget.dart';
import 'package:citizenone_app/modules/agrinet/app/theme/ag_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';

import '../../../../data/model/weather/forecast_entry.dart';

class ForecastTile extends StatelessWidget {
  final ForecastEntry entry;

  const ForecastTile({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      "EEE dd.MM.yyyy - HH:mm",
    ).format(entry.date);
    final icon = entry.weather.first.icon;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(formattedDate, style: kw500Primary16),
                const SizedBox(height: 5),

                // weather description
                Text(
                  entry.weather.first.description.capitalizeFirst ?? "",
                  style: kw500Secondary14,
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Text(
                      "Wind: ${entry.wind.speed1} m/s ",
                      style: kw400Secondary14,
                    ),
                    WindDirectionArrow(degree: entry.wind.deg, size: 16),
                  ],
                ),
                Text("Pressure: ${entry.pressure1}", style: kw400Secondary14),
                Text("Humidity: ${entry.humidity1}", style: kw400Secondary14),
              ],
            ),
          ),

          // RIGHT SIDE TEMP DISPLAY
          Column(
            children: [
              WeatherIcon(iconCode: icon, size: 95, color: Colors.white),
              const SizedBox(height: 6),

              Text(
                "${entry.temp1}°C",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
