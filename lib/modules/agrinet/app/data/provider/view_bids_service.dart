import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/utils/user_prefs.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/view_bids/adverise_history_list.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/view_bids/one_advertise_history.dart';
import 'package:citizenone_app/modules/agrinet/app/data/remote/api_service/ApiEndPoints.dart';
import 'package:citizenone_app/modules/agrinet/app/data/remote/api_service/init_api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ViewBidsService {
  static Future<AdvertiseProductResponse?> fetchAdvertiseHistoryList() async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.advertiseHistory,
        data: {"reqSecureKey": UserPrefs.user?.userId ?? ''},
      );
      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return null;
      } else if (response.data != null && response.statusCode == 200) {
        return compute(parseFarmersListResponse, response.data!);
      } else {
        agSnackbar(title: "Error", msg: "Invalid server response");
      }
    } catch (e) {
      agSnackbar(title: "Error", msg: "Something went wrong");
      return null;
    }
    return null;
  }

  static Future<dynamic> acceptBidPlan({
    required Map<String, dynamic> requestBody,
  }) async {
    return await APIService.post(
      path: ApiEndPoints.acceptBidPlan,
      data: requestBody,
    );
  }

  static Future<dynamic> rejectBidPlan({
    required Map<String, dynamic> requestBody,
  }) async {
    return await APIService.post(
      path: ApiEndPoints.rejectBidPlan,
      data: requestBody,
    );
  }

  static Future<OneAdvertiseHistory?> fetchIndividualAdvertiseHistoryList({
    required requestBody,
  }) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.individualAdvertiseHistory,
        data: requestBody,
      );
      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return null;
      } else if (response.data != null && response.statusCode == 200) {
        return OneAdvertiseHistory.fromJson(response.data!);
      } else {
        agSnackbar(title: "Error", msg: "Invalid server response");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
      return null;
    }
    return null;
  }
}

AdvertiseProductResponse parseFarmersListResponse(Map<String, dynamic> json) {
  return AdvertiseProductResponse.fromJson(json);
}
