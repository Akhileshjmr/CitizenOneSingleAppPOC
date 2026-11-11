import 'package:flutter/material.dart';

import '../model/crop_insurance.dart';
import '../remote/api_service/ApiEndPoints.dart';
import '../remote/api_service/init_api_service.dart';

class CropInsuranceService {
  static Future<CropInsuranceResponse?> saveCropInsurance({
    required Map<String, dynamic> request,
  }) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.saveFarmingPlan,
        data: request,
      );

      if (response?.data != null && response!.data is Map<String, dynamic>) {
        return CropInsuranceResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      return null;
    } catch (err, stacktrace) {
      debugPrint("Error in saveCropInsurance: $err");
      debugPrint("$stacktrace");
      return null;
    }
  }
}
