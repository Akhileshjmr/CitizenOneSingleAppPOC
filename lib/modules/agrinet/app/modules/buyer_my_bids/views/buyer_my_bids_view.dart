import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/buyer_my_bids_controller.dart';
import 'my_bids_tile.dart';

class BuyerMyBidsView extends GetView<BuyerMyBidsController> {
  const BuyerMyBidsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(
        title: "My Bids",
        showSearch: true,
        onSearchChanged: (val) => controller.filterBids(val),
        searchController: controller.searchController,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: AgLoader());
        }
        if (controller.bids.isEmpty) {
          return const Center(child: Text("No Bids Available"));
        }

        return ListView.builder(
          itemCount: controller.bids.length,
          itemBuilder: (_, index) {
            return MyBidsTile(
              item: controller.bids[index],
              onTap: () {
                controller.selectedBid.value = controller.bids[index];
                Get.toNamed(
                  Routes.BUYER_BID_VIEW,
                )?.then((_) => controller.loadMyBids());
              },
            );
          },
        );
      }),
    );
  }
}
