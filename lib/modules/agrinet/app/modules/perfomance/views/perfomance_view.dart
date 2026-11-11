import 'package:citizenone_app/modules/agrinet/app/modules/perfomance/views/performance_stat_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../components/ui/ag_appbar.dart';
import '../../../utils/ag_assets.dart';
import '../controllers/performance_controller.dart';

class PerformanceView extends GetView<PerformanceController> {
  const PerformanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F6F4),
      appBar: AgAppbar(title: "Performance"),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Colors.green,
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              _buildChart(),
              const SizedBox(height: 12),
              _buildLegend(),
              const SizedBox(height: 20),
              _buildStatsGrid(),
            ],
          ),
        );
      }),
    );
  }

  // ---------------------- CHART ----------------------

  Widget _buildChart() {
    final labels = controller.labels;
    final values = controller.values;

    final data = List.generate(
      labels.length,
      (i) => ChartData(labels[i], values[i], _barColor(i)),
    );

    return Container(
      height: 250,
      color: const Color(0xFFEFF5F3),
      child: SfCartesianChart(
        key: ValueKey(values.length), // forces chart rebuild

        plotAreaBackgroundColor: const Color(0xFFEFF5F3),

        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 1, color: Colors.black54),
          labelStyle: const TextStyle(fontSize: 11),
        ),

        primaryYAxis: NumericAxis(
          isVisible: true,
          maximumLabelWidth: 0,
          edgeLabelPlacement: EdgeLabelPlacement.hide,
          majorTickLines: const MajorTickLines(size: 0),
          minorTickLines: const MinorTickLines(size: 0),
          axisLabelFormatter:
              (_) => ChartAxisLabel('', const TextStyle(fontSize: 0)),
          majorGridLines: MajorGridLines(
            width: 0.7,
            color: Colors.grey.shade400,
          ),
          axisLine: const AxisLine(width: 1, color: Colors.black54),
        ),

        series: <CartesianSeries>[
          ColumnSeries<ChartData, String>(
            dataSource: data,
            xValueMapper: (ChartData d, _) => d.label,
            yValueMapper: (ChartData d, _) => d.value,
            pointColorMapper: (ChartData d, _) => d.color,
            borderRadius: BorderRadius.zero,
            width: 0.8,
            spacing: 0.2,

            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.outer,
              textStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------- LEGEND ----------------------

  Widget _buildLegend() {
    return Row(
      children: [
        _legendBox(const Color(0xFF00FF00)),
        _legendBox(const Color(0xFF6B5500)),
        _legendBox(const Color(0xFFCCCCCC)),
        _legendBox(const Color(0xFF7388FF)),
        _legendBox(const Color(0xFFFFB1B1)),
        const SizedBox(width: 8),
        const Text(
          "BANDHU PERFORMANCE",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }

  Widget _legendBox(Color color) => Container(
    margin: const EdgeInsets.only(right: 6),
    width: 14,
    height: 14,
    color: color,
  );

  // ---------------------- STATS GRID ----------------------

  Widget _buildStatsGrid() {
    final width = MediaQuery.of(Get.context!).size.width;
    final aspectRatio = width > 600 ? 2.5 : 1.8;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: aspectRatio,
      children: [
        PerformanceStatItem(
          imagePath: AgAssets.icFarmerOnBoarded,
          title: "ON BOARDED",
          value: controller.data['OnBoard'].toString(),
        ),
        PerformanceStatItem(
          imagePath: AgAssets.icGroupCreated,
          title: "GROUPS CREATED",
          value: controller.data['Group'].toString(),
        ),
        PerformanceStatItem(
          imagePath: AgAssets.icFarmerOnBoarded,
          title: "REQUESTS RAISED",
          value: controller.data['Service'].toString(),
        ),
        PerformanceStatItem(
          imagePath: AgAssets.icFarmingPlansCreated,
          title: "PLANS CREATED",
          value: controller.data['Plans'].toString(),
        ),
        PerformanceStatItem(
          imagePath: AgAssets.icAdsPublished,
          title: "ADS PUBLISHED",
          value: controller.data['Ads'].toString(),
        ),
        PerformanceStatItem(
          imagePath: AgAssets.icBankApproved,
          title: "BANK APPROVED",
          value: controller.data['Bank'].toString(),
        ),
        PerformanceStatItem(
          imagePath: AgAssets.icBidsAccepted,
          title: "BIDS ACCEPTED",
          value: controller.data['BID'].toString(),
        ),
        PerformanceStatItem(
          imagePath: AgAssets.icPaymentReceived,
          title: "PAYMENT RECEIVED",
          value: controller.data['Payment'].toString(),
        ),
      ],
    );
  }

  // ---------------------- COLORS ----------------------

  Color _barColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF00FF00);
      case 1:
        return const Color(0xFF6B5500);
      case 2:
        return const Color(0xFFCCCCCC);
      case 3:
        return const Color(0xFF7388FF);
      case 4:
        return const Color(0xFFFFB1B1);
      default:
        return Colors.grey;
    }
  }
}

// ---------------------- MODEL ----------------------

class ChartData {
  final String label;
  final int value;
  final Color color;

  ChartData(this.label, this.value, this.color);
}
