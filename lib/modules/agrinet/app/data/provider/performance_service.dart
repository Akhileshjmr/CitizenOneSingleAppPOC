import 'dart:developer';

import 'package:citizenone_app/modules/agrinet/app/components/utils/user_prefs.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/performance/performance.dart';
import 'package:citizenone_app/modules/agrinet/app/data/remote/api_service/ApiEndPoints.dart';
import 'package:citizenone_app/modules/agrinet/app/data/remote/api_service/init_api_service.dart';

class PerformanceService {
  static Future<PerformanceSummary?> fetchPerformance() async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.performance,
        data: {"filterVal": UserPrefs.user?.userId ?? ''},
      );

      if (response == null) return null;

      return PerformanceSummary.fromJson(response.data!);
    } catch (e) {
      log("Performance API Error: $e");
      return null;
    }
  }
}
