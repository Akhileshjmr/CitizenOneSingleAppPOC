import 'package:citizenone_app/modules/agrinet/app/modules/plant_protection/views/insect_selection_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_appbar.dart';
import '../../../components/ui/ag_loader.dart';
import '../../../data/model/plant_protection/damage_model.dart';
import '../../../theme/ag_text_styles.dart';
import '../controllers/plant_protection_controller.dart';
import '../widgets/selection_card.dart';

class PestSelectionView extends StatelessWidget {
  final PlantProtectionController controller = Get.find();

  PestSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: "Pest Selection", showLogout: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: AgLoader());
        }
        if (controller.pests.isEmpty) {
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
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: controller.pests.length,
                  itemBuilder: (c, i) {
                    final DamageModel d = controller.pests[i];
                    return SelectionCard(
                      title: d.damagename,
                      index: i,
                      image: d.documents,
                      onTap: () async {
                        controller.selectedPests.value = d;
                        controller.fetchInsects(
                          controller.selectedSeed.value!.damageID,
                          d.damagename,
                        );
                        Get.to(() => InsectSelectionView());
                      },
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
