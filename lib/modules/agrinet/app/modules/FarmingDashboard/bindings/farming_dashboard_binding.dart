import 'package:get/get.dart';

import '../controllers/farming_dashboard_controller.dart';

class FarmingDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FarmingDashboardController>(() => FarmingDashboardController());
  }
}

class FarmArguments {
  /// Arguments to be passed when opening the quiz
  FarmArguments({
    required this.farmingPlanId,
    required this.farmingStatus,
    this.groupId,
  });

  /// Either [Sporting] or [Learning]
  final String farmingPlanId;
  final String farmingStatus;
  final String? groupId;
}

class soilArguments {
  /// Arguments to be passed when opening the quiz
  soilArguments({
    required this.farmingPlanId,
    required this.farmingStatus,
    required this.latitude,
    required this.longitude,
  });

  /// Either [Sporting] or [Learning]
  final String farmingPlanId;
  final String farmingStatus;
  final double latitude;
  final double longitude;
}
