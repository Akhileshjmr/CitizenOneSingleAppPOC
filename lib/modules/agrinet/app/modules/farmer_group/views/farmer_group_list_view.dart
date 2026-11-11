import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_loader.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/farmer_group/farmer_group_list.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/farmer_group/views/farmer_group_view.dart';
import 'package:citizenone_app/modules/agrinet/app/routes/app_pages.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/farmer_group_controller.dart';

class FarmerGroupListView extends GetView<FarmerGroupController> {
  const FarmerGroupListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AgColors.k027212,
        shape: const CircleBorder(),
        onPressed: () {
          Get.toNamed(Routes.ADD_FARMER_GROUP);
        },
        child: const Icon(Icons.group_add_sharp, color: Colors.white),
      ),
      appBar: AgAppbar(
        title: controller.agApptranslation.farmerGroup,
        showSearch: true,
        searchController: controller.searchController,
        onSearchChanged: controller.filterGroups,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: AgLoader());
      }

      if (controller.farmerGroupList.isEmpty) {
        return const Center(
          child: Text(
            'No farmer groups found',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return ListView.builder(
        itemCount: controller.farmerGroupList.length,
        itemBuilder: (context, index) {
          final AgriFormerGroup farmerGroup = controller.farmerGroupList[index];

          final members = farmerGroup.formerList ?? [];

          return InkWell(
            onTap:
                members.isEmpty
                    ? null
                    : () {
                      Get.to(() => FarmerGroupView(members: members));
                    },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            farmerGroup.grpName ?? 'Unnamed Group',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: Get.width * 0.6,
                            child: Text(
                              farmerGroup.descPriction ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Members Count',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            members.length.toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AgColors.k027212,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                index != controller.farmerGroupList.length - 1
                    ? const Divider(color: AgColors.kC4E59E, thickness: 1.5)
                    : const SizedBox(height: 20),
              ],
            ),
          );
        },
      );
    });
  }
}
