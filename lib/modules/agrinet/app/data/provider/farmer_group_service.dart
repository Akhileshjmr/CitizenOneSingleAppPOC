import 'package:citizenone_app/modules/agrinet/app/components/utils/user_prefs.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/farmer_group/farmer_group_list.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/farmer_group/farmer_list.dart';
import 'package:citizenone_app/modules/agrinet/app/data/remote/api_service/ApiEndPoints.dart';
import 'package:citizenone_app/modules/agrinet/app/data/remote/api_service/init_api_service.dart';
import 'package:flutter/foundation.dart';

import '../../components/ui/ag_snackbar.dart';

class FarmerGroupService {
  static Future<AgriFormerGroupListResponse?> fetchGroupFarmerList() async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.farmerGroupList,
        data: {"filterVal": "${UserPrefs.user?.userId}"},
      );
      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return null;
      } else if (response.data != null && response.statusCode == 200) {
        return AgriFormerGroupListResponse.fromJson(response.data!);
      } else {
        agSnackbar(title: "Error", msg: "Invalid server response");
      }
      return null;
    } catch (e) {
      agSnackbar(title: "Error", msg: "Something went wrong");
      return null;
    }
  }

  static Future<FarmersListResponse?> fetchFarmerList() async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.farmerList,
        data: {"filterVal": "${UserPrefs.user?.userId}"},
      );
      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return null;
      } else if ((response.data != null && response.statusCode == 200)) {
        final result = await compute(parseFarmersListResponse, response.data!);
        return result;
      } else {
        agSnackbar(title: "Error", msg: "Invalid server response");
      }
    } catch (e) {
      agSnackbar(title: "Error", msg: "Something went wrong");
      return null;
    }
    return null;
  }

  static Future<dynamic> createFarmerGroup({required requestBody}) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.createFarmerGroup,
        data: requestBody,
      );
      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return null;
      } else if (response.data != null && response.statusCode == 200) {
        return response.data;
      } else {
        agSnackbar(title: "Error", msg: "Invalid server response");
      }
    } catch (e) {
      agSnackbar(title: "Error", msg: "Something went wrong");
      return null;
    }
  }
}

FarmersListResponse parseFarmersListResponse(Map<String, dynamic> json) {
  return FarmersListResponse.fromJson(json);
}
