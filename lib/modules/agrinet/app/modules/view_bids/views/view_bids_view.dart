import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_loader.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/view_bids/adverise_history_list.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/view_bids/views/bid_card_widget.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/view_bids/views/bid_history_view.dart';
import 'package:citizenone_app/modules/agrinet/app/routes/app_pages.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/view_bids_controller.dart';

class ViewBidsView extends GetView<ViewBidsController> {
  const ViewBidsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(),

      appBar: AgAppbar(
        title: 'Advertise History',
        showSearch: true,
        onSearchChanged: controller.filterAdvertiseHistory,
      ),

      body: Obx(() {
        return _buildBody();
      }),
    );
  }

  // ===============================
  // Main Body
  // ===============================
  Widget _buildBody() {
    // Loading
    if (controller.isLoading.value) {
      return const Center(child: AgLoader());
    }

    final list = controller.advertiseHistoryList;

    // Empty / No Search Result
    if (list.isEmpty) {
      return const Center(
        child: Text(
          "No advertise history found",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }

    // List
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),

      itemCount: list.length,

      itemBuilder: (context, index) {
        final item = list[index];
        return _buildBidCard(item);
      },
    );
  }

  // ===============================
  // Bid Card
  // ===============================
  Widget _buildBidCard(AdvertiseProduce item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),

      child: BidCard(
        onTapCard: () => _openBidHistory(item),

        readyBy: controller.formatDate(item.readyBy ?? ''),
        bidCloses: controller.formatDate(item.bidClose ?? ''),

        title: item.username ?? 'NA',
        code: item.id ?? 'NA',

        minPrice: item.minPrice ?? 'NA',
        quantity: item.totalQuantity ?? 'NA',
        imageUrl:
            (item.documents != null && item.documents!.isNotEmpty)
                ? item.documents!.first.fileName ?? ''
                : '',
      ),
    );
  }

  // ===============================
  // Open History Screen
  // ===============================
  Future<void> _openBidHistory(AdvertiseProduce item) async {
    await controller.fetchOneAdvertiseHisory(item);

    Get.to(() => BidHistoryView(advertiseHistoryData: item));
  }

  // ===============================
  // Bottom Bar
  // ===============================
  Widget _buildBottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),

      child: AgButton(
        onTap: () {
          Get.toNamed(Routes.PUBLISH_ADS);
        },

        backgroundColor: AgColors.FF4500,

        title: 'Advertise Product',

        width: Get.width,
      ),
    );
  }
}
