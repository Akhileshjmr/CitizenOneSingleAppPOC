import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/utils/user_prefs.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/view_bids/adverise_history_list.dart';
import 'package:citizenone_app/modules/agrinet/app/data/remote/api_service/ApiEndPoints.dart';
import 'package:citizenone_app/modules/agrinet/app/data/remote/api_service/init_api_service.dart';
import 'package:citizenone_app/modules/agrinet/app/routes/app_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../components/ui/ag_alert_dialogue.dart';
import '../../modules/success_info/views/success_info_view.dart';
import '../model/buyer_ads_bids/bid_plan_history.dart';
import '../model/buyer_ads_bids/buyer_ads_detail.dart';
import '../model/common/ch_message.dart';

class BuyerBidsService {
  static Future<AdvertiseProductResponse?> fetchAdvertiseHistory() async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.buyerAdvertiseHistory,
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

  static Future<BuyerAdsBidDetailRes?> fetchBuyerAdDetail({
    required String id,
    required String groupID,
  }) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.buyerIndividualAdsHistory,
        data: {"id": id, "groupID": groupID},
      );

      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return null;
      }

      if (response.statusCode == 200 && response.data != null) {
        return BuyerAdsBidDetailRes.fromJson(response.data!);
      } else {
        agSnackbar(title: "Error", msg: "Invalid server response");
        return null;
      }
    } catch (e) {
      agSnackbar(title: "Error", msg: "Something went wrong");
      return null;
    }
  }

  static Future<BuyerAdsBidDetailRes?> fetchBuyerBidDetail({
    required String id,
    required String groupID,
  }) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.buyerIndividualBidHistory,
        data: {"id": id, "groupID": groupID},
      );

      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return null;
      }

      if (response.statusCode == 200 && response.data != null) {
        return BuyerAdsBidDetailRes.fromJson(response.data!);
      } else {
        agSnackbar(title: "Error", msg: "Invalid server response");
        return null;
      }
    } catch (e) {
      agSnackbar(title: "Error", msg: "Something went wrong");
      return null;
    }
  }

  static Future<BidPlanResponse?> fetchMyBids() async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.buyerBidHistory,
        data: {"buyerId": UserPrefs.user?.userId},
      );

      if (response == null) {
        return null;
      }

      if (response.statusCode == 200 && response.data != null) {
        // Ensure API returned a JSON map
        if (response.data is! Map<String, dynamic>) {
          return null;
        }

        return BidPlanResponse.fromJson(response.data ?? {});
      } else {
        agSnackbar(title: "Error", msg: "Server Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("fetchMyBids() Exception: $e");
    }

    return null;
  }

  static Future<bool> cancelBid({
    required String groupID,
    required String id,
  }) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.buyerCancelBid,
        data: {"groupID": groupID, "id": id},
      );

      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return false;
      }

      if (response.statusCode == 200 && response.data != null) {
        final ch = ChMessage.fromJson(response.data?["chMessage"] ?? {});

        if (ch.code == "SUCCESS") {
          return true;
        } else {
          agSnackbar(title: "Error", msg: ch.message ?? "Something went wrong");
        }
      }

      return false;
    } catch (e) {
      debugPrint("Cancel bid exception: $e");
      return false;
    }
  }

  static Future<bool> placeBid({
    required String adId,
    required String cropName,
    required String price,
    required String quantity,
  }) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.buyerPlaceBid,
        data: {
          "adId": adId,
          "buyerId": UserPrefs.user?.userId ?? "",
          "cropName": cropName,
          "minPrice": price,
          "totalQuantity": quantity,
        },
      );

      if (response == null) {
        AgAlertDialog.show(
          title: "Error",
          message: "Unable to connect to server",
        );
        return false;
      }

      final ch = ChMessage.fromJson(response.data?["chMessage"] ?? {});

      /// ---------- SUCCESS CASE ----------
      if (ch.type == "SUCCESS") {
        SuccessInfoView.show(
          title: "Success",
          message: ch.message ?? "Bid placed successfully.",
          onOk: () {
            Get.offAllNamed(Routes.BUYER_HOME);
          },
        );
        return true;
      }

      /// ---------- FAILURE CASE ----------
      SuccessInfoView.show(
        title: "Failed",
        message: ch.message ?? "Bid submission failed.",
        onOk: () {},
      );

      return false;
    } catch (e) {
      debugPrint("Place Bid Exception: $e");

      SuccessInfoView.show(
        title: "Error",
        message: "Something went wrong. Try again later.",
        onOk: () {},
      );

      return false;
    }
  }
}

AdvertiseProductResponse parseFarmersListResponse(Map<String, dynamic> json) {
  return AdvertiseProductResponse.fromJson(json);
}
