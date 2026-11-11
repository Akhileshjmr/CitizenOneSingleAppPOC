import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_alert_dialogue.dart';
import 'package:get/get.dart';

import '../../components/utils/user_prefs.dart';
import '../model/profitability/profitability_response.dart';
import '../remote/api_service/ApiEndPoints.dart';
import '../remote/api_service/init_api_service.dart';

class ProfitabilityService {
  /// ---------------------------------------------
  /// FETCH PROFITABILITY DETAILS
  /// ---------------------------------------------
  Future<ProfitabilityResponse?> fetchProfitability(String planId) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.farmingPlanProfitability,
        data: {
          "reqSecureKey": UserPrefs.user?.reqSecureKey ?? "447349",
          "filterVal": planId,
        },
      );

      if (response == null) {
        AgAlertDialog.show(
          title: "Info",
          message: "Unable to connect to server",
          onOk: () {
            Get.back(); // Close the detail screen and go back to list
          },
        );
        return null;
      }

      final json = response.data ?? {};
      final parsed = ProfitabilityResponse.fromJson(json);

      if (parsed.chMessage.isError == true) {
        AgAlertDialog.show(
          title: parsed.chMessage.subject ?? "Alert",
          message: parsed.chMessage.message ?? "Something went wrong",
          onOk: () {
            Get.back(); // Close the detail screen and go back to list
          },
        );
        return null;
      }

      if (parsed.farmPlanProfit == null) {
        AgAlertDialog.show(
          title: parsed.chMessage.dispType ?? "Info",
          message: parsed.chMessage.message ?? "No details found",
          onOk: () {
            Get.back();
          },
        );
        return null;
      }
      return parsed;
    } catch (e) {
      AgAlertDialog.show(
        title: "Error",
        message: "Failed to load profitability: $e",
        onOk: () {
          Get.back();
        },
      );
      return null;
    }
  }
}
