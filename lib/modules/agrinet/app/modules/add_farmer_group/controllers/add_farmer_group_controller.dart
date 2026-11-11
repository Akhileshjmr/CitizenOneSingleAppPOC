import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/utils/user_prefs.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/farmer_group/farmer_list.dart';
import 'package:citizenone_app/modules/agrinet/app/data/provider/farmer_group_service.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/add_farmer_group/controllers/add_farmer_group_variables.dart';
import 'package:citizenone_app/modules/agrinet/app/routes/app_pages.dart';
import 'package:get/get.dart';

class AddFarmerGroupController extends GetxController
    with AddFarmerGroupVariables {
  final count = 0.obs;
  RxInt? selectedLeaderId = RxInt(-1);

  @override
  void onInit() async {
    super.onInit();
    await fetchFarmerList();
  }

  Future<void> fetchFarmerList() async {
    try {
      isLoading(true);
      FarmersListResponse? response =
          await FarmerGroupService.fetchFarmerList();

      if (response != null) {
        allFarmers = response.formerList ?? [];

        /// initially show all
        farmerList.assignAll(allFarmers);
      }

      isLoading(false);
    } catch (e) {
      isLoading(false);
    }
  }

  void selectLeader(int farmerId) {
    selectedLeaderId?.value = farmerId;

    if (!selectedFarmerList.contains(farmerId)) {
      selectedFarmerList.add(farmerId);
    }

    for (var farmer in farmerList) {
      farmer.isLeader = farmer.farmer!.id == farmerId;
    }

    farmerList.refresh();
  }

  void filterFarmers(String query) {
    if (query.isEmpty) {
      farmerList.assignAll(allFarmers);
      return;
    }

    final lowerQuery = query.toLowerCase();

    final filtered =
        allFarmers.where((farmer) {
          final name = farmer.farmer?.friendlyType?.toLowerCase() ?? '';
          return name.contains(lowerQuery);
        }).toList();

    farmerList.assignAll(filtered);
  }

  void toggleFarmer(FarmerModal farmer) {
    final int farmerId = farmer.id!;

    if (selectedFarmerList.contains(farmerId)) {
      selectedFarmerList.remove(farmerId);

      if (selectedLeaderId?.value == farmerId) {
        selectedLeaderId?.value = -1;
      }
    } else {
      selectedFarmerList.add(farmerId);
    }

    farmerList.refresh();
  }

  Future<void> onSaveFarmerGroup() async {
    if (groupNameController.text.isEmpty) {
      agSnackbar(title: 'Message', msg: 'Please Enter Group Name');
    } else if (groupDescriptionController.text.isEmpty) {
      agSnackbar(title: 'Message', msg: 'Please Enter Group Description');
    } else if (selectedFarmerList.isEmpty) {
      agSnackbar(title: 'Message', msg: 'Please add at least one farmer');
    } else if (selectedLeaderId?.value == -1) {
      agSnackbar(title: 'Message', msg: 'Please select a Leader');
    } else {
      List<FarmerDetail> selectedFarmers =
          farmerList
              .where((farmer) => selectedFarmerList.contains(farmer.farmer!.id))
              .toList();

      await saveFarmerGroup(selectedFarmers);
    }
  }

  Future<dynamic> saveFarmerGroup(List<FarmerDetail> selectedFarmers) async {
    try {
      isLoading(true);
      dynamic requestBody = {
        "reqSecureKey": UserPrefs.user?.userId ?? '',
        "descPriction": groupDescriptionController.text,
        "formerList":
            selectedFarmers.map((data) {
              return {
                "farmer": {
                  "friendlyType": data.farmer?.friendlyType,
                  "id": data.farmer?.id,
                  "type": data.farmer?.type,
                },
                "isLeader": data.isLeader,
                "imageUrl": data.imageUrl,
              };
            }).toList(),
        "grpName": groupNameController.text,
      };
      final response = await FarmerGroupService.createFarmerGroup(
        requestBody: requestBody,
      );
      if (response != null) {
        Get.toNamed(
          Routes.SUCCESS_INFO,
          arguments: {
            "title": "Info",
            "message":
                response.containsKey('message')
                    ? response['message']['message']
                    : 'Farmer Group Created Successfully',
            "onOk": () {
              Get.offAllNamed(Routes.HOME);
            },
          },
        );
      }
      isLoading(false);
    } catch (e) {
      isLoading(false);
    }
  }
}
