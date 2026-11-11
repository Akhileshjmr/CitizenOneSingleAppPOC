import '../../components/ui/ag_snackbar.dart';
import '../../components/utils/user_prefs.dart';
import '../model/plant_protection/crop_model.dart';
import '../model/plant_protection/damage_model.dart';
import '../model/plant_protection/insect_model.dart';
import '../model/plant_protection/stage_model.dart';
import '../remote/api_service/ApiEndPoints.dart';
import '../remote/api_service/init_api_service.dart';

class PlantProtectionService {
  // ---------------------------------------------------------------------------
  // Helper → validate success
  // ---------------------------------------------------------------------------
  bool _isSuccess(Map<String, dynamic> json) {
    final msg = json["chMessage"];
    if (msg == null) return false;

    return msg["code"] == "SUCCESS";
  }

  void _showError(Map<String, dynamic>? json) {
    final msg = json?["chMessage"];
    final message = msg?["message"] ?? "Something went wrong";
    agSnackbar(title: "Error", msg: message.toString());
  }

  // ---------------------------------------------------------------------------
  // 1) FETCH CROP LIST
  // ---------------------------------------------------------------------------
  Future<List<CropModel>> fetchCropList() async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.plantProtection,
        data: {
          "reqSecureKey": UserPrefs.user?.reqSecureKey,
          "screenId": "CROP_MAINTENANCE",
        },
      );

      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return [];
      }

      final json = response.data ?? {};

      if (!_isSuccess(json)) {
        _showError(json);
        return [];
      }

      final list = (json["cropList"] as List?) ?? [];
      return list.map((e) => CropModel.fromJson(e)).toList();
    } catch (e) {
      agSnackbar(title: "Error", msg: "Failed to load crops: $e");
      return [];
    }
  }

  // ---------------------------------------------------------------------------
  // 2) FETCH STAGES
  // ---------------------------------------------------------------------------
  Future<List<SeedModel>> fetchSeeds(String cropSerialNum) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.plantProtection,
        data: {
          "reqSecureKey": UserPrefs.user?.reqSecureKey,
          "screenId": "DAMAGE_PROTECTION",
          "addiParams": [cropSerialNum],
        },
      );

      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return [];
      }

      final json = response.data ?? {};

      if (!_isSuccess(json)) {
        _showError(json);
        return [];
      }

      final list = (json["cropMaintenanceList"] as List?) ?? [];
      return list.map((e) => SeedModel.fromJson(e)).toList();
    } catch (e) {
      agSnackbar(title: "Error", msg: "Failed to load stages: $e");
      return [];
    }
  }

  // ---------------------------------------------------------------------------
  // 3) FETCH DAMAGE TYPES
  // ---------------------------------------------------------------------------
  Future<List<DamageModel>> fetchPests(String damageId) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.plantProtection,
        data: {
          "reqSecureKey": UserPrefs.user?.reqSecureKey,
          "screenId": "DAMAGE_MAINTENANCE",
          "addiParams": [damageId],
        },
      );

      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return [];
      }

      final json = response.data ?? {};

      if (!_isSuccess(json)) {
        _showError(json);
        return [];
      }

      final list = (json["damageList"] as List?) ?? [];
      return list.map((e) => DamageModel.fromJson(e)).toList();
    } catch (e) {
      agSnackbar(title: "Error", msg: "Failed to load damage types: $e");
      return [];
    }
  }

  // ---------------------------------------------------------------------------
  // 4) FETCH INSECT LIST
  // ---------------------------------------------------------------------------
  Future<List<InsectModel>> fetchInsects(
    String damageId,
    String damageName,
  ) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.plantProtection,
        data: {
          "reqSecureKey": UserPrefs.user?.reqSecureKey ?? "447349",
          "screenId": "INSECTS_MAINTENANCE",
          "addiParams": [damageId, damageName],
        },
      );

      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return [];
      }

      final json = response.data ?? {};

      if (!_isSuccess(json)) {
        _showError(json);
        return [];
      }

      final list = (json["insectsList"] as List?) ?? [];
      return list.map((e) => InsectModel.fromJson(e)).toList();
    } catch (e) {
      agSnackbar(title: "Error", msg: "Failed to load insects: $e");
      return [];
    }
  }

  // ---------------------------------------------------------------------------
  // 5) FETCH INSECT DETAILS
  // ---------------------------------------------------------------------------
  Future<InsectModel?> fetchDetails(String insNum) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.plantProtection,
        data: {
          "reqSecureKey": UserPrefs.user?.reqSecureKey,
          "screenId": "IMP_DETAILS",
          "addiParams": [insNum],
        },
      );

      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return null;
      }

      final json = response.data ?? {};

      if (!_isSuccess(json)) {
        _showError(json);
        return null;
      }

      final list = (json["insectsList"] as List?) ?? [];
      if (list.isEmpty) return null;

      return InsectModel.fromJson(list.first);
    } catch (e) {
      agSnackbar(title: "Error", msg: "Failed to load insect details: $e");
      return null;
    }
  }
}
