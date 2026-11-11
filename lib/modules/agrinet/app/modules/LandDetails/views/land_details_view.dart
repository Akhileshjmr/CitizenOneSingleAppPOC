import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/agrinet/app/data/config/ag_dimens.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/shgDetails/shgDetailsResp.dart';
import '../../../theme/ag_text_styles.dart';
import '../controllers/land_details_controller.dart';

class LandDetailsView extends GetView<LandDetailsController> {
  const LandDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgColors.kWhite,
      appBar: AgAppbar(title: "Land Details"),
      body: Obx(() {
        return BaseScreen(
          isLoading: controller.isLoading.value,
          child:
              (controller.landDetails.value?.groupDetails ?? []).isNotEmpty
                  ? _buildLandList()
                  : _buildEmptyState(),
        );
      }),
    );
  }

  // ---------------- UI when data exists ----------------
  Widget _buildLandList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: controller.landDetails.value!.groupDetails!.length,
            itemBuilder: (context, index) {
              final group = controller.landDetails.value!.groupDetails![index];
              final landList = group.landDetails ?? [];

              return Container(
                height: 200,
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding,
                          ),
                          child: Text(
                            '${group.custName}',
                            style: kw600Primary16,
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: landList.length,
                        itemBuilder: (context, landIndex) {
                          final land = landList[landIndex];
                          return landCard(land, index);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: AgButton(
                  title: 'Add Land',
                  onTap: controller.onAddLandTap,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AgButton(
                  title: 'Submit',
                  onTap: controller.saveFarmingPlan,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- UI when no data ----------------
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: AgButton(
              width: double.infinity,
              title: 'Add Land',
              onTap: controller.onAddLandTap,
            ),
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }

  // ---------------- Land Card ----------------
  Widget landCard(LandDetail land, int groupIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Container(
        width: Get.width * 0.6,
        decoration: BoxDecoration(
          color: AgColors.colorSecondaryDark,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Village Name Row
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    land.village ?? "Village",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    child: const Icon(Icons.close, color: Colors.white),
                    onTap:
                        () => controller.deleteItem(
                          land: land,
                          groupIndex: groupIndex,
                        ),
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white24),

            // Details Row
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Owned Area
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Owned Area",
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        land.ownedArea.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // Irrigated %
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Irrigated %",
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        (land.irrigatedPerc ?? '').toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
