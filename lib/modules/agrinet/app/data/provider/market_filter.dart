import 'package:citizenone_app/modules/agrinet/app/data/model/user/main_response.dart';
import 'package:flutter/cupertino.dart';

import '../model/market/market_response.dart';
import '../remote/api_service/ApiEndPoints.dart';
import '../remote/api_service/init_api_service.dart';

class MarketFilterService {
  static Future<MainResponse?> getStateAndCommodities() async {
    try {
      final response = await APIService.get(
        path: ApiEndPoints.getStateCommodities,
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

  static Future<MarketResponse?> getCommoditiesPrice({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.getCommoditiesPrice,
        data: data,
      );

      if (response != null && response.data != null) {
        final Map<String, dynamic> json = response.data as Map<String, dynamic>;
        return MarketResponse.fromJson(json);
      }

      return null;
    } catch (err, stacktrace) {
      debugPrint("Error in getCommoditiesPrice: $err");
      debugPrint("$stacktrace");
      return null;
    }
  }
}
