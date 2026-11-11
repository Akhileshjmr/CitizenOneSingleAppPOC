import 'package:flutter/cupertino.dart';

import '../model/plan_summary/plan_summary_model.dart';
import '../remote/api_service/ApiEndPoints.dart';
import '../remote/api_service/init_api_service.dart';

class PlanSummeryService {
  static Future getPlanSummery({required Map<String, dynamic> request}) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.getPlanSummary,
        data: request,
      );

      if (response != null && response.data != null) {
        final Map<String, dynamic> json = response.data as Map<String, dynamic>;
        return PlanSummaryResponse.fromJson(json);
      }

      return null;
    } catch (err, stacktrace) {
      debugPrint("Error in getPlanSummery: $err");
      debugPrint("$stacktrace");
      return null;
    }
  }
}
