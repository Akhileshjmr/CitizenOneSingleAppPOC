import 'package:citizenone_app/modules/agrinet/app/components/utils/user_prefs.dart';
import 'package:citizenone_app/modules/agrinet/app/data/remote/api_service/ApiEndPoints.dart';
import 'package:citizenone_app/modules/agrinet/app/data/remote/api_service/init_api_service.dart';
import 'package:citizenone_app/modules/agrinet/app/routes/app_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../components/ui/ag_alert_dialogue.dart';
import '../../components/ui/ag_snackbar.dart';
import '../../modules/success_info/views/success_info_view.dart';
import '../../utils/ag_user_consts.dart';
import '../model/buyer_demand/buyer_demand_res.dart';
import '../model/buyer_demand/create_buyer_demand_req.dart';
import '../model/common/ch_message.dart';

class BuyerDemandService {
  /// FETCH BUYER DEMANDS LIST
  static Future<BuyerDemandResponse?> fetchBuyerDemands() async {
    try {
      final response = await APIService.post(
        path:
            (UserPrefs.user?.role == AgUserConsts.palType)
                ? ApiEndPoints.demandList
                : ApiEndPoints.buyerDemandList,
        data: {"filterVal": UserPrefs.user?.userId ?? ""},
      );

      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return null;
      }

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is! Map<String, dynamic>) {
          agSnackbar(title: "Error", msg: "Invalid server format");
          return null;
        }

        return BuyerDemandResponse.fromJson(response.data!);
      } else {
        agSnackbar(title: "Error", msg: "Invalid server response");
        return null;
      }
    } catch (e) {
      debugPrint("fetchBuyerDemands() Exception: $e");
      agSnackbar(title: "Error", msg: "Something went wrong");
      return null;
    }
  }

  /// CREATE BUYER DEMAND
  static Future<bool> createBuyerDemand(CreateBuyerDemandReq req) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.buyerCreateDemand,
        data: req.toJson(),
      );

      if (response == null) {
        AgAlertDialog.show(
          title: "Error",
          message: "Unable to connect to server",
        );
        return false;
      }

      final ch = ChMessage.fromJson(response.data?["chMessage"] ?? {});

      /// SUCCESS
      if (ch.code == "SUCCESS") {
        SuccessInfoView.show(
          title: "Success",
          message: ch.message ?? "Demand successfully published.",
          onOk: () => Get.offAllNamed(Routes.BUYER_HOME),
        );
        return true;
      }

      /// FAILURE
      SuccessInfoView.show(
        title: "Failed",
        message: ch.message ?? "Could not publish demand.",
        onOk: () {
          Get.back();
        },
      );

      return false;
    } catch (e) {
      debugPrint("createBuyerDemand() Exception: $e");

      SuccessInfoView.show(
        title: "Error",
        message: "Something went wrong",
        onOk: () {},
      );

      return false;
    }
  }
}
