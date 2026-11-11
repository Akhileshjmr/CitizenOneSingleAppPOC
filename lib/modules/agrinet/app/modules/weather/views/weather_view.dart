import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_loader.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/weather/views/widgets/forecast_tile.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/weather/views/widgets/weather_icons.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/weather/views/widgets/wind_arrow_widget.dart';
import 'package:citizenone_app/modules/agrinet/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app_environment.dart';
import '../../../data/model/weather/forecast_entry.dart';
import '../../../routes/app_pages.dart';
import '../controllers/weather_controller.dart';

class WeatherView extends GetView<WeatherController> {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(body: Center(child: AgLoader()));
      }

      final cur = controller.current.value;
      if (cur == null) {
        return const Scaffold(body: Center(child: Text("No weather data")));
      }

      return DefaultTabController(
        length: 3,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 330,
                  backgroundColor: AgColors.colorPrimary,
                  elevation: 0,

                  // BACK BUTTON
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 22,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    onPressed: () => Get.back(),
                  ),

                  // COMPACT ACTIONS + MORE MENU
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 22,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      onPressed: controller.refreshWeather,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 22,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      onPressed: () => _openSearchDialog(context),
                    ),

                    // MORE MENU
                    PopupMenuButton<int>(
                      color: Colors.white,
                      elevation: 4,
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 22,
                      ),

                      onSelected: (value) {
                        switch (value) {
                          case 1:
                            Get.toNamed(Routes.WEATHER_MAPS);
                            break;
                          case 2:
                            Get.toNamed(Routes.WEATHER_GRAPHS);
                            break;
                          case 3:
                            controller.fetchWeather();
                            break;
                        }
                      },

                      itemBuilder:
                          (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: Row(
                                children: const [
                                  Icon(Icons.map, size: 20),
                                  SizedBox(width: 12),
                                  Text("Weather Maps"),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: Row(
                                children: const [
                                  Icon(Icons.graphic_eq, size: 20),
                                  SizedBox(width: 12),
                                  Text("Weather Graphs"),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 3,
                              child: Row(
                                children: const [
                                  Icon(Icons.my_location, size: 20),
                                  SizedBox(width: 12),
                                  Text("My Location"),
                                ],
                              ),
                            ),
                          ],
                    ),
                  ],

                  // TITLE
                  title: Text(
                    "${cur.name}, ${cur.sys.country}",
                    style: kw500White18,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // =====================================================
                  // FLEXIBLE SPACE (BACKGROUND + WEATHER DETAILS)
                  // =====================================================
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          "assets/images/weather_bg.jpg",
                          fit: BoxFit.cover,
                          package: AppEnvironment.packageName,
                        ),
                        Container(color: Colors.black.withOpacity(0.35)),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 90, 18, 50),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // LEFT SIDE WEATHER DETAILS
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${cur.main.temp1} °C",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 42,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      cur
                                              .weather
                                              .first
                                              .description
                                              .capitalizeFirst ??
                                          "",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 18,
                                      ),
                                    ),

                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Text(
                                          "Wind: ${cur.wind.speed1} m/s ",
                                          style: kw400White14,
                                        ),
                                        WindDirectionArrow(
                                          degree: cur.wind.deg,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),

                                    Text(
                                      "Pressure: ${cur.main.pressure1}",
                                      style: kw400White14,
                                    ),
                                    Text(
                                      "Humidity: ${cur.main.humidity1}",
                                      style: kw400White14,
                                    ),
                                    Text(
                                      "Sunrise: ${controller.formatEpoch(cur.sys.sunrise)}",
                                      style: kw400White14,
                                    ),
                                    Text(
                                      "Sunset: ${controller.formatEpoch(cur.sys.sunset)}",
                                      style: kw400White14,
                                    ),
                                  ],
                                ),
                              ),

                              // RIGHT SIDE ICON + LAST UPDATE
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  WeatherIcon(
                                    iconCode: cur.weather.first.icon,
                                    size: 95,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    "Last update:",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  Text(
                                    DateFormat(
                                      "hh:mm a",
                                    ).format(DateTime.now()),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // =====================================================
                  // TAB BAR
                  // =====================================================
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(48),
                    child: Container(
                      color: Colors.black.withOpacity(0.30),
                      child: const TabBar(
                        indicatorColor: Colors.white,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white70,
                        tabs: [
                          Tab(text: "TODAY"),
                          Tab(text: "TOMORROW"),
                          Tab(text: "LATER"),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },

            body: TabBarView(
              children: [
                _buildList(controller.getForecast("today")),
                _buildList(controller.getForecast("tomorrow")),
                _buildList(controller.getForecast("later")),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildList(List<ForecastEntry> items) {
    if (items.isEmpty) {
      return const Center(child: Text("No data available"));
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      separatorBuilder:
          (_, __) => const Divider(height: 1, color: Color(0xFFE5EBE8)),
      itemBuilder: (context, index) {
        return ForecastTile(entry: items[index]);
      },
    );
  }

  void _openSearchDialog(BuildContext context) {
    final textController = TextEditingController();

    Get.dialog(
      Center(
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.82,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Search for city", style: kw500Primary18),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: textController,
                  autofocus: true,
                  cursorColor: Colors.green,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 6),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AgColors.colorPrimary,
                        width: 2,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AgColors.colorPrimary,
                        width: 1.4,
                      ),
                    ),
                  ),
                  style: const TextStyle(fontSize: 16, height: 1.3),
                ),

                const SizedBox(height: 22),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("CANCEL", style: kw500Green14),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        final city = textController.text.trim();
                        if (city.isNotEmpty) {
                          controller.fetchWeatherByCity(city);
                        }
                        Get.back();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Text("OK", style: kw500Green14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }
}
