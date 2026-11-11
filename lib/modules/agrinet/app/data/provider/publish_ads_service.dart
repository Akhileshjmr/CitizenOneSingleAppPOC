import 'package:citizenone_app/modules/agrinet/app/components/utils/user_prefs.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/publish_ads/farm_plan_detail.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/publish_ads/farm_plan_list.dart';
import 'package:citizenone_app/modules/agrinet/app/data/remote/api_service/ApiEndPoints.dart';
import 'package:citizenone_app/modules/agrinet/app/data/remote/api_service/init_api_service.dart';

import '../../components/ui/ag_snackbar.dart';
import '../model/publish_ads/document/advertise_docs_response.dart';

class PublishAdsService {
  static Future<FarmPlanListResponse?> fetchFarmPlanList() async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.farmPlanList,
        data: {"reqSecureKey": UserPrefs.user?.userId ?? ''},
      );
      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return null;
      } else if (response.data != null && response.statusCode == 200) {
        return FarmPlanListResponse.fromJson(response.data!);
      } else {
        agSnackbar(title: "Error", msg: "Invalid server response");
      }
    } catch (e) {
      agSnackbar(title: "Error", msg: "Something went wrong");
      return null;
    }
    return null;
  }

  static Future<CropDetailResponse?> getFarmPlanDetails({
    required requestBody,
  }) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.planDetails,
        data: requestBody,
      );
      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return null;
      } else if (response.data != null && response.statusCode == 200) {
        return CropDetailResponse.fromJson(response.data!);
      } else {
        agSnackbar(title: "Error", msg: "Invalid server response");
      }
    } catch (e) {
      agSnackbar(title: "Error", msg: "Something went wrong");
      return null;
    }
    return null;
  }

  static Future<dynamic> savePublishAds({required requestBody}) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.advertiseAds,
        data: requestBody,
      );
      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return null;
      } else if (response.data != null && response.statusCode == 200) {
        return response.data!;
      } else {
        agSnackbar(title: "Error", msg: "Invalid server response");
      }
    } catch (e) {
      agSnackbar(title: "Error", msg: "Something went wrong");
      return null;
    }
    return null;
  }

  static Future<AdvertiseDocsResponse?> uploadAdvertiseDocuments({
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.uploadAdvertiseDocuments,
        data: requestBody,
      );

      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return null;
      } else if (response.data != null && response.statusCode == 200) {
        return AdvertiseDocsResponse.fromJson(response.data ?? {});
      } else {
        agSnackbar(title: "Error", msg: "Invalid server response");
      }
    } catch (e) {
      agSnackbar(title: "Error", msg: "Something went wrong");
      return null;
    }

    return null;
  }
}
