import 'package:citizenone_app/modules/agrinet/app/modules/plant_protection/views/details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_appbar.dart';
import '../../../components/ui/ag_loader.dart';
import '../../../data/model/plant_protection/insect_model.dart';
import '../../../theme/ag_text_styles.dart';
import '../controllers/plant_protection_controller.dart';
import '../widgets/selection_card.dart';

class InsectSelectionView extends StatelessWidget {
  final PlantProtectionController controller = Get.find();

  InsectSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: "Insect Selection", showLogout: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: AgLoader());
        }
        if (controller.insects.isEmpty) {
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
                  itemCount: controller.insects.length,
                  itemBuilder: (ctx, i) {
                    final InsectModel ins = controller.insects[i];
                    return SelectionCard(
                      index: i,
                      title: ins.insName,
                      image: ins.insDocument,
                      onTap: () async {
                        controller.fetchDetails(ins.insNum);
                        Get.to(() => DetailsView());
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
