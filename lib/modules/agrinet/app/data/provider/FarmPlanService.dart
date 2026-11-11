import 'package:citizenone_app/modules/agrinet/app/components/utils/user_prefs.dart';
import 'package:citizenone_app/modules/agrinet/app/data/config/api_res_ext.dart';
import 'package:dio/dio.dart';

import '../model/farmPlan/FarmPlansResp.dart';
import '../model/farmPlan/PalCreationResp.dart';
import '../model/farmPlan/ServiceResp.dart';
import '../model/farmPlan/SoilAssessment.dart';
import '../model/shgDetails/shgDetailsResp.dart';
import '../remote/api_service/ApiEndPoints.dart';
import '../remote/api_service/init_api_service.dart';

class FarmPlanService {
  static Future<FarmPlansResp?> fetchFarmList({
    required String reqSecureKey,
    required String screenId,
  }) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: ApiEndPoints.farmPlan,
        data: <String, dynamic>{
          "reqSecureKey": reqSecureKey,
          "screenId": screenId,
        },
      );
      if (response != null && response.isOk) {
        return FarmPlansResp.fromJson(response.data!);
      }
    } on Exception catch (e) {
      // logE(e);
    }
    return null;
  }

  static Future<FarmingPlanResponse?> saveFarmingPlan({
    required String reqSecureKey,
    required String screenId,
    required String farmingPlanId,
    required List<Map<String, dynamic>> groupDetails,
  }) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: ApiEndPoints.saveFarmingPlan,
        data: <String, dynamic>{
          "reqSecureKey": reqSecureKey,
          "screenId": screenId,
          "farmingPlanId": farmingPlanId,
          "groupDetails": groupDetails,
        },
      );

      if (response != null && response.isOk) {
        return FarmingPlanResponse.fromJson(response.data!);
      }
    } on Exception catch (e) {
      // logE(e);
    }

    return null;
  }

  static Future<FarmingPlanResponse?> fetchGroupFarmList({
    required String reqSecureKey,
    required String screenId,
    required String farmingPlanId,
  }) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: ApiEndPoints.farmPlan,
        data: <String, dynamic>{
          "reqSecureKey": reqSecureKey,
          "screenId": screenId,
          "farmingPlanId": farmingPlanId,
        },
      );
      if (response != null && response.isOk) {
        return FarmingPlanResponse.fromJson(response.data!);
      }
    } on Exception catch (e) {
      // logE(e);
    }
    return null;
  }

  static Future<FarmingPlanResponse?> deleteLandDetail({
    required LandDetail landDetails,
    required String farmingPlanId,
  }) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: ApiEndPoints.deleteLandDetails,
        data: <String, dynamic>{
          "reqSecureKey": farmingPlanId,
          "filterVal": (UserPrefs.user?.userId ?? 0).toString(),
          "addiParams": [
            landDetails.landId.toString(),
            landDetails.ownedArea.toString(),
          ],
        },
      );

      if (response != null && response.isOk) {
        return FarmingPlanResponse.fromJson(response.data!);
      }
    } on Exception catch (e) {
      // logE(e);
    }

    return null;
  }

  static Future<FarmingPlanResponse?> getEventsList({
    required Map<String, dynamic> formData,
  }) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: ApiEndPoints.factors,
        data: formData,
      );
      if (response != null && response.isOk) {
        return FarmingPlanResponse.fromJson(response.data!);
      }
    } on Exception catch (e) {
      // logE(e);
    }
    return null;
  }

  static Future<FarmingPlanResponse?> GroupFarmDeatilsList({
    required Map<String, dynamic> formData,
  }) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: ApiEndPoints.farmPlan,
        data: formData,
      );
      if (response != null && response.isOk) {
        return FarmingPlanResponse.fromJson(response.data!);
      }
    } on Exception catch (e) {
      // logE(e);
    }
    return null;
  }

  static Future<FarmingPlanResponse?> SaveGroupFarmDeatils({
    required Map<String, dynamic> formData,
  }) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: ApiEndPoints.saveGroupFarm,
        data: formData,
      );
      if (response != null && response.isOk) {
        return FarmingPlanResponse.fromJson(response.data!);
      }
    } on Exception catch (e) {
      // logE(e);
    }
    return null;
  }

  static Future<soilAssessmentResp?> SoilAssement({
    required Map<String, dynamic> formData,
  }) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: ApiEndPoints.soilAssessment,
        data: formData,
      );
      if (response != null && response.isOk) {
        return soilAssessmentResp.fromJson(response.data!);
      }
    } on Exception catch (e) {
      // logE(e);
    }
    return null;
  }

  static Future<soilAssessmentResp?> submitFactors({
    required Map<String, dynamic> formData,
  }) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: ApiEndPoints.factors,
        data: formData,
      );
      if (response != null && response.isOk) {
        return soilAssessmentResp.fromJson(response.data!);
      }
    } on Exception catch (e) {
      // logE(e);
    }
    return null;
  }

  static Future<FarmingPlanResponse?> RescheduleEvent({
    required Map<String, dynamic> formData,
  }) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: ApiEndPoints.reschedule,
        data: formData,
      );
      if (response != null && response.isOk) {
        return FarmingPlanResponse.fromJson(response.data!);
      }
    } on Exception catch (e) {
      // logE(e);
    }
    return null;
  }

  static Future<FarmingPlanResponse?> submitAgriInput({
    required Map<String, dynamic> formData,
  }) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: ApiEndPoints.factors,
        data: formData,
      );
      if (response != null && response.isOk) {
        return FarmingPlanResponse.fromJson(response.data!);
      }
    } on Exception catch (e) {
      // logE(e);
    }
    return null;
  }

  static Future<ServiceResponse?> serviceList({
    required Map<String, dynamic> formData,
  }) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: ApiEndPoints.serviceList,
        data: formData,
      );
      if (response != null && response.isOk) {
        return ServiceResponse.fromJson(response.data!);
      }
    } on Exception catch (e) {
      // logE(e);
    }
    return null;
  }

  static Future<ServiceResponse?> serviceDetails({
    required Map<String, dynamic> formData,
  }) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: ApiEndPoints.serviceDetail,
        data: formData,
      );
      if (response != null && response.isOk) {
        return ServiceResponse.fromJson(response.data!);
      }
    } on Exception catch (e) {
      // logE(e);
    }
    return null;
  }

  static Future<FarmingPlanResponse?> aboutUS({
    required Map<String, dynamic> formData,
  }) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: ApiEndPoints.aboutus,
        data: formData,
      );
      if (response != null && response.isOk) {
        return FarmingPlanResponse.fromJson(response.data!);
      }
    } on Exception catch (e) {
      // logE(e);
    }
    return null;
  }

  static Future<PalcreationResp?> getPalCreation() async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.get(
        path: ApiEndPoints.palCreation,
      );
      if (response != null && response.isOk) {
        return PalcreationResp.fromJson(response.data!);
      }
    } on Exception catch (e) {
      // logE(e);
    }
    return null;
  }

  static Future<ServiceResponse?> palSignUp({
    required Map<String, dynamic> formData,
  }) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: ApiEndPoints.palSignUp,
        data: formData,
      );
      if (response != null && response.isOk) {
        return ServiceResponse.fromJson(response.data!);
      }
    } on Exception catch (e) {
      // logE(e);
    }
    return null;
  }
}
