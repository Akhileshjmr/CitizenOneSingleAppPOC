import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';

import '../../components/utils/user_prefs.dart';
import '../model/common/option.dart';
import '../model/plan/group_farmer_list.dart';
import '../model/plan/group_farming_plan.dart';
import '../model/plan/group_member.dart';
import '../model/plan/save_plan.dart';
import '../remote/api_service/ApiEndPoints.dart';
import '../remote/api_service/init_api_service.dart';

class PlanService {
  Future<GroupFarmerList?> fetchGroupFarmerList() async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.groupFarmerList,
        data: {
          'reqSecureKey': UserPrefs.user?.userId,
          'screenId': 'GROUP_LIST',
        },
      );

      if (response == null) {
        agSnackbar(title: 'Error', msg: 'Unable to connect to server');
        return null;
      }

      final json = response.data ?? {};
      return GroupFarmerList.fromJson(json);
    } catch (e) {
      agSnackbar(title: 'Error', msg: 'Failed to load groups: $e');
      return null;
    }
  }

  Future<List<GroupMember>> fetchGroupMembers(Option group) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.groupFarmerList,
        data: {
          'reqSecureKey': UserPrefs.user?.reqSecureKey,
          'groupId': group.toJson(),
          'screenId': 'SHG_DETAILS',
          'status': 'NEW',
        },
      );

      if (response == null) {
        agSnackbar(title: 'Error', msg: 'Unable to connect to server');
        return [];
      }

      final json = response.data ?? {};
      // Group details are returned under "groupDetails"
      final rawList = (json['groupDetails'] as List<dynamic>?) ?? [];
      final list =
          rawList
              .map((e) => GroupMember.fromJson(e as Map<String, dynamic>))
              .toList();
      return list;
    } catch (e) {
      agSnackbar(title: 'Error', msg: 'Failed to load group members: $e');
      return [];
    }
  }

  Future<SavePlanResponse?> savePlan({
    required String planName,
    required String planDesc,
    required Option group,
    required List<GroupMember> members,
  }) async {
    try {
      /// Build members JSON
      final memberJsonList =
          members.map((m) {
            final contribution =
                double.tryParse(m.contributionCtrl.text.trim()) ?? 0.0;

            return {
              "chMessage": {"dispType": "ALERT", "subject": "Alert"},
              // "reqSecureKey": contribution.toString(),
              "contribution": contribution,
              "custId": m.custId?.toJson(),
              "custName": m.custName,
              "mobileNo": " ",
              "uniqueId": " ",
            };
          }).toList();

      /// API body exactly matching backend
      final request = {
        "name": planName,
        "desc": planDesc,
        "reqSecureKey": UserPrefs.user?.userId ?? "",
        "screenId": "SHG_DETAILS",
        "status": "New",
        "groupId": group.toJson(),
        "groupDetails": memberJsonList,
      };

      final response = await APIService.post(
        path: ApiEndPoints.saveFarmingPlan,
        data: request,
      );

      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return null;
      }

      /// Convert response → model
      final model = SavePlanResponse.fromJson(response.data ?? {});

      return model; // Important: return model with message & id
    } catch (e) {
      agSnackbar(title: "Error", msg: "Save plan failed: $e");
      return null;
    }
  }

  Future<List<FarmingPlanItem>> fetchFarmingPlanList(int pageId) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.groupFarmerList,
        data: {
          "reqSecureKey": UserPrefs.user?.reqSecureKey ?? "447349",
          "screenId": "FARMINGPLAN_LIST",
          "id": pageId,
        },
      );

      if (response == null) return [];

      final json = response.data ?? {};
      final wrapper = GroupFarmingPlanList.fromJson(json);
      return wrapper.plans;
    } catch (e) {
      agSnackbar(title: "Error", msg: "Failed to load plans: $e");
      return [];
    }
  }
}
