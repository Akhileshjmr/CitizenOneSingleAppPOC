import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_loader.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/plant_protection/views/pest_selection_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/plant_protection/stage_model.dart';
import '../../../theme/ag_text_styles.dart';
import '../controllers/plant_protection_controller.dart';
import '../widgets/selection_card.dart';

class SeedSelectionView extends StatelessWidget {
  final PlantProtectionController controller = Get.find();

  SeedSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: "Seed Selection", showLogout: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: AgLoader());
        }
        if (controller.seeds.isEmpty) {
          return Center(child: Text('No Data Found'));
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Please select the crop', style: kw400Primary16),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    childAspectRatio: 1,
                  ),
                  itemCount: controller.seeds.length,
                  itemBuilder: (context, i) {
                    final SeedModel s = controller.seeds[i];
                    return SelectionCard(
                      title: s.stage,
                      image: s.stageImage,
                      onTap: () async {
                        controller.selectedSeed.value = s;
                        controller.fetchPests(s.damageID);
                        Get.to(() => PestSelectionView());
                      },
                      index: i,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
