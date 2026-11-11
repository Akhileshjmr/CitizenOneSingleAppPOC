import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/plant_protection/views/seed_selection_view.dart';
import 'package:citizenone_app/modules/agrinet/app/theme/ag_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_loader.dart';
import '../controllers/plant_protection_controller.dart';
import '../widgets/crop_selection_card.dart';

class PlantProtectionView extends GetView<PlantProtectionController> {
  PlantProtectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: "Seed Selection", showLogout: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: AgLoader());
        }
        if (controller.error.value.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Please select the crop', style: kw400Primary16),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: controller.crops.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, idx) {
                  final crop = controller.crops[idx];

                  return CropSelectionCard(
                    crop: crop,
                    index: idx,
                    onTap: () async {
                      controller.selectedCrop.value = crop;
                      controller.fetchSeeds(crop.serialNum);
                      Get.to(() => SeedSelectionView());
                    },
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
