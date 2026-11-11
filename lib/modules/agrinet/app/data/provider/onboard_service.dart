import 'package:citizenone_app/modules/agrinet/app/components/utils/user_prefs.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/onboarding/onboarding_farmer_list.dart';
import 'package:flutter/material.dart';

import '../model/user/main_response.dart';
import '../remote/api_service/ApiEndPoints.dart';
import '../remote/api_service/init_api_service.dart';

class OnboardService {
  static Future<MainResponse?> getOnboardData() async {
    try {
      final response = await APIService.get(path: ApiEndPoints.farmerOnBoard);

      if (response != null && response.data != null) {
        final Map<String, dynamic> json = response.data as Map<String, dynamic>;
        return MainResponse.fromJson(json);
      }

      return null;
    } catch (err, stacktrace) {
      debugPrint("Error in getOnboardData: $err");
      debugPrint("$stacktrace");
      return null;
    }
  }

  static Future saveFarmerData({required Map<String, dynamic> request}) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.farmerOnBoard,
        data: request,
      );

      if (response != null && response.data != null) {
        final Map<String, dynamic> json = response.data as Map<String, dynamic>;
        return MainResponse.fromJson(json);
      }

      return null;
    } catch (err, stacktrace) {
      debugPrint("Error in getOnboardData: $err");
      debugPrint("$stacktrace");
      return null;
    }
  }

  static Future<FarmerOnBoardList?> fetchFarmerList() async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.farmerOnBoardList,
        data: {"filterVal": UserPrefs.user?.userId ?? ''},
      );

      if (response != null && response.data != null) {
        final Map<String, dynamic> json = response.data as Map<String, dynamic>;
        return FarmerOnBoardList.fromJson(json);
      }

      return null;
    } catch (err, stacktrace) {
      debugPrint("Error in fetchFarmerList: $err");
      debugPrint("$stacktrace");
      return null;
    }
  }

  static Future saveDependent({required Map<String, dynamic> request}) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.farmerOnBoard,
        data: request,
      );

      if (response != null && response.data != null) {
        final Map<String, dynamic> json = response.data as Map<String, dynamic>;
        return MainResponse.fromJson(json);
      }

      return null;
    } catch (err, stacktrace) {
      debugPrint("Error in getOnboardData: $err");
      debugPrint("$stacktrace");
      return null;
    }
  }
}
