// weather_graphs_view.dart
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../data/model/weather/forecast_entry.dart';
import '../../weather/controllers/weather_controller.dart';

class WeatherGraphsView extends GetView<WeatherController> {
  const WeatherGraphsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final forecast = controller.forecast.value;

      if (controller.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      if (forecast == null) {
        return const Scaffold(body: Center(child: Text("No forecast data")));
      }

      // Convert forecast entries to chart data
      final chartData = _prepareChartData(forecast.list);

      return Scaffold(
        backgroundColor: AgColors.colorPrimary,
        appBar: AgAppbar(title: "Graphs"),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _buildTemperatureGraph(chartData),
              const SizedBox(height: 12),
              _buildRainGraph(chartData),
              const SizedBox(height: 12),
              _buildPressureGraph(chartData),
            ],
          ),
        ),
      );
    });
  }

  List<WeatherChartData> _prepareChartData(List<ForecastEntry> entries) {
    List<WeatherChartData> chartData = [];
    String lastDay = '';

    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final dt = DateTime.fromMillisecondsSinceEpoch(entry.dt * 1000);
      final dayName = DateFormat('EEE').format(dt);

      // Show day label only when day changes
      String displayLabel = '';
      if (dayName != lastDay) {
        displayLabel = dayName;
        lastDay = dayName;
      }

      double rain = 0.0;
      if (entry.rain != null) {
        rain = entry.rain!.toDouble();
      }

      chartData.add(
        WeatherChartData(
          index: i,
          dayLabel: displayLabel,
          temp: entry.main.temp,
          pressure: entry.main.pressure.toDouble(),
          rain: rain,
        ),
      );
    }

    return chartData;
  }

  Widget _buildTemperatureGraph(List<WeatherChartData> data) {
    // Calculate dynamic min/max with some padding
    final temps = data.map((d) => d.temp).toList();
    final minTemp = temps.reduce((a, b) => a < b ? a : b);
    final maxTemp = temps.reduce((a, b) => a > b ? a : b);
    final tempRange = maxTemp - minTemp;
    final tempMin = (minTemp - tempRange * 0.1).floorToDouble();
    final tempMax = (maxTemp + tempRange * 0.1).ceilToDouble();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Text(
            'Temperature',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: NumericAxis(
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(width: 0),
                labelStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
                axisLabelFormatter: (AxisLabelRenderDetails details) {
                  final index = details.value.toInt();
                  if (index >= 0 && index < data.length) {
                    final label = data[index].dayLabel;
                    if (label.isNotEmpty) {
                      return ChartAxisLabel(label, details.textStyle);
                    }
                  }
                  return ChartAxisLabel('', details.textStyle);
                },
              ),
              primaryYAxis: NumericAxis(
                minimum: tempMin,
                maximum: tempMax,
                majorGridLines: const MajorGridLines(
                  width: 1,
                  color: Colors.black12,
                  dashArray: [5, 5],
                ),
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(width: 0),
                labelStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              series: <CartesianSeries<WeatherChartData, num>>[
                LineSeries<WeatherChartData, num>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.index,
                  yValueMapper: (d, _) => d.temp,
                  color: const Color(0xFFFF5722),
                  width: 3,
                  markerSettings: const MarkerSettings(isVisible: false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRainGraph(List<WeatherChartData> data) {
    // Calculate dynamic max for rain
    final rains = data.map((d) => d.rain).toList();
    final maxRain = rains.reduce((a, b) => a > b ? a : b);
    final rainMax = maxRain > 0 ? (maxRain * 1.2).ceilToDouble() : 1.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Text(
            'Rain',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: NumericAxis(
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(width: 0),
                labelStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
                axisLabelFormatter: (AxisLabelRenderDetails details) {
                  final index = details.value.toInt();
                  if (index >= 0 && index < data.length) {
                    final label = data[index].dayLabel;
                    if (label.isNotEmpty) {
                      return ChartAxisLabel(label, details.textStyle);
                    }
                  }
                  return ChartAxisLabel('', details.textStyle);
                },
              ),
              primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: rainMax,
                majorGridLines: const MajorGridLines(
                  width: 1,
                  color: Colors.black12,
                  dashArray: [5, 5],
                ),
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(width: 0),
                labelStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              series: <CartesianSeries<WeatherChartData, num>>[
                ColumnSeries<WeatherChartData, num>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.index,
                  yValueMapper: (d, _) => d.rain,
                  color: const Color(0xFF2196F3),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  spacing: 0.2,
                  width: 0.6,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPressureGraph(List<WeatherChartData> data) {
    // Calculate dynamic min/max for pressure
    final pressures = data.map((d) => d.pressure).toList();
    final minPressure = pressures.reduce((a, b) => a < b ? a : b);
    final maxPressure = pressures.reduce((a, b) => a > b ? a : b);
    final pressureRange = maxPressure - minPressure;
    final pressureMin = (minPressure - pressureRange * 0.1).floorToDouble();
    final pressureMax = (maxPressure + pressureRange * 0.1).ceilToDouble();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Text(
            'Pressure',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: NumericAxis(
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(width: 0),
                labelStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
                axisLabelFormatter: (AxisLabelRenderDetails details) {
                  final index = details.value.toInt();
                  if (index >= 0 && index < data.length) {
                    final label = data[index].dayLabel;
                    if (label.isNotEmpty) {
                      return ChartAxisLabel(label, details.textStyle);
                    }
                  }
                  return ChartAxisLabel('', details.textStyle);
                },
              ),
              primaryYAxis: NumericAxis(
                minimum: pressureMin,
                maximum: pressureMax,
                majorGridLines: const MajorGridLines(
                  width: 1,
                  color: Colors.black12,
                  dashArray: [5, 5],
                ),
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(width: 0),
                labelStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              series: <CartesianSeries<WeatherChartData, num>>[
                LineSeries<WeatherChartData, num>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.index,
                  yValueMapper: (d, _) => d.pressure,
                  color: const Color(0xFF4CAF50),
                  width: 3,
                  markerSettings: const MarkerSettings(isVisible: false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Data class for chart
class WeatherChartData {
  final int index;
  final String dayLabel;
  final double temp;
  final double pressure;
  final double rain;

  WeatherChartData({
    required this.index,
    required this.dayLabel,
    required this.temp,
    required this.pressure,
    required this.rain,
  });
}
