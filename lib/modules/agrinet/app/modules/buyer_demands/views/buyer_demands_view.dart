import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_loader.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/buyer_demands/views/widget/buyer_demand_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_pull_refresh.dart';
import '../../../components/utils/user_prefs.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/ag_user_consts.dart';
import '../controllers/buyer_demands_controller.dart';

class BuyerDemandsView extends GetView<BuyerDemandsController> {
  const BuyerDemandsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(
        title: "Demands View",
        showSearch: true,
        onSearchChanged: (val) => controller.onSearch(val),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: AgLoader());
        }

        if (controller.demands.isEmpty) {
          return const Center(child: Text("No demands available"));
        }

        return AgPullRefresh(
          onRefresh: controller.loadDemands,
          child: ListView.separated(
            itemCount: controller.demands.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder:
                (_, index) => BuyerDemandTile(item: controller.demands[index]),
          ),
        );
      }),

      bottomNavigationBar: Visibility(
        visible: UserPrefs.user?.role != AgUserConsts.palType,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: AgButton(
            title: "Advertise Demand",
            onTap: () async {
              final res = await Get.toNamed(Routes.BUYER_ADS_DEMAND);

              if (res == true) {
                controller.loadDemands();
              }
            },
          ),
        ),
      ),
    );
  }
}
