import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/agrinet/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/agrinet/app/data/config/ag_dimens.dart';
import 'package:citizenone_app/modules/agrinet/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_button.dart';
import '../../../components/ui/ag_image.dart';
import '../../../data/model/onboarding/onboarding_farmer_list.dart';
import '../controllers/farmer_list_controller.dart';

class FarmerListView extends GetView<FarmerListController> {
  const FarmerListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(
        title: 'Farmer List',
        showSearch: true,
        onSearchChanged: (text) => controller.filterFarmers(text),
      ),
      body: Obx(
        () => BaseScreen(
          isLoading: controller.isLoading.value,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: 8,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Obx(
                    () => ListView.separated(
                      itemCount: controller.filteredFarmers.length,
                      separatorBuilder:
                          (_, __) =>
                              Divider(height: 1, color: Colors.grey.shade300),
                      itemBuilder: (context, index) {
                        FarmerOnBoard farmer =
                            controller.filteredFarmers[index];

                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              Routes.FARMER_PROFILE,
                              arguments: {
                                "farmerId": farmer.bankDetails?.formerId?.type,
                                "docId": farmer.id,
                                "status": farmer.status,
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                AgImage(
                                  imageUrl:
                                      farmer
                                          .generalDetails
                                          ?.custPhoto
                                          ?.docUrl
                                          ?.addBaseUrl ??
                                      '',
                                  isCircular: true,
                                ),

                                const SizedBox(width: 14),

                                /// NAME + ID
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        farmer.generalDetails?.name ?? '',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        farmer
                                                .bankDetails
                                                ?.formerId
                                                ?.friendlyType ??
                                            '',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () {
                                    if (farmer.status == "Draft") {
                                      Get.toNamed(
                                        Routes.ADD_FARMER,
                                        arguments: {
                                          "farmerId":
                                              farmer
                                                  .bankDetails
                                                  ?.formerId
                                                  ?.type,
                                          "docId": farmer.id,
                                        },
                                      );
                                    }
                                  },
                                  child: Text(
                                    farmer.status ?? '',
                                    style: const TextStyle(
                                      color: Color(0xFF2E5A1A),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Add Farmer Button
                AgButton(
                  onTap: () {
                    Get.toNamed(Routes.ADD_FARMER);
                  },
                  title: 'Add Farmer',
                  width: Get.width,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
