import 'package:citizenone_app/modules/agrinet/app/data/model/farmer_group/farmer_group_list.dart';
import 'package:citizenone_app/modules/agrinet/app/data/provider/farmer_group_service.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/farmer_group/controllers/farmer_group_variables.dart';
import 'package:get/get.dart';

class FarmerGroupController extends GetxController with FarmerGroupVariables {
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFarmerGroupList();

    searchController.addListener(() {
      filterGroups(searchController.text);
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchFarmerGroupList() async {
    try {
      isLoading(true);

      AgriFormerGroupListResponse? response =
          await FarmerGroupService.fetchGroupFarmerList();

      if (response != null && response.agriFormerList != null) {
        allFarmerGroups.assignAll(response.agriFormerList!);
        farmerGroupList.assignAll(response.agriFormerList!);
      }
    } catch (e) {
      print('Error fetching farmer group list: $e');
    } finally {
      isLoading(false);
    }
  }

  void filterGroups(String query) {
    if (query.trim().isEmpty) {
      farmerGroupList.assignAll(allFarmerGroups);
      return;
    }

    final lowerQuery = query.toLowerCase();

    farmerGroupList.assignAll(
      allFarmerGroups.where((group) {
        final groupName = group.grpName?.toLowerCase() ?? '';

        final farmerType =
            group.formerList != null && group.formerList!.isNotEmpty
                ? group.formerList!.first.farmer?.friendlyType?.toLowerCase() ??
                    ''
                : '';

        return groupName.contains(lowerQuery) ||
            farmerType.contains(lowerQuery);
      }).toList(),
    );
  }
}
