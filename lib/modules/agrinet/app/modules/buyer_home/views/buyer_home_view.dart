import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_pull_refresh.dart';
import 'package:citizenone_app/modules/agrinet/app/routes/app_pages.dart';
import 'package:citizenone_app/modules/agrinet/app/theme/ag_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_loader.dart';
import '../../../components/utils/user_prefs.dart';
import '../../../data/model/view_bids/adverise_history_list.dart';
import '../../../utils/ag_colors.dart';
import '../../view_bids/views/bid_card_widget.dart';
import '../controllers/buyer_home_controller.dart';

class BuyerHomeView extends GetView<BuyerHomeController> {
  BuyerHomeView({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        UserPrefs.logout();
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AgAppbar(
          title: "Buy",
          leadingIcon: Icons.menu,
          leadingOnTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          showSearch: true,
          onSearchChanged: (val) => controller.filterAds(val),
          searchController: controller.searchController,
          showLeadingIcon: true,
        ),
        backgroundColor: AgColors.kEFFFF2,
        drawer: _customDrawer(),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: AgLoader());
          }

          if (controller.advertiseHistoryList.isEmpty) {
            return const Center(
              child: Text(
                "No items available",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          return AgPullRefresh(
            onRefresh: controller.fetchAdvertiseHistoryList,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: controller.advertiseHistoryList.length,
              itemBuilder: (context, index) {
                final AdvertiseProduce item =
                    controller.advertiseHistoryList[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: BidCard(
                    onTapCard: () {
                      controller.selectedAdvertiseProduce = item;
                      Get.toNamed(
                        Routes.BUYER_ADS_DETAIL,
                      )?.then((_) => controller.fetchAdvertiseHistoryList());
                    },
                    readyBy: controller.formatDate(item.readyBy ?? ""),
                    bidCloses: controller.formatDate(item.bidClose ?? ""),
                    title:
                        (item.cropName != null && item.cropName!.isNotEmpty)
                            ? item.cropName!.first.cropName ?? "Wheat"
                            : "Wheat",
                    code: (item.id ?? ""),
                    minPrice: item.minPrice ?? "",
                    quantity: item.totalQuantity ?? "",
                    imageUrl:
                        (item.documents != null && item.documents!.isNotEmpty)
                            ? item.documents!.first.fileName ?? ''
                            : '',
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  // ---------------- DRAWER --------------------

  Widget _customDrawer() {
    final pal = UserPrefs.user?.palRes;
    final imageUrl = pal?.documents?.imgUrl;
    final name = pal?.firstName ?? "";

    return Drawer(
      child: Container(
        color: AgColors.colorPrimary,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Opacity(
                    opacity: 0.15,
                    child: Icon(
                      Icons.agriculture,
                      size: 260,
                      color: Colors.white,
                    ),
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    /// PROFILE IMAGE (PAL)
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.white24,
                      backgroundImage:
                          (imageUrl != null && imageUrl.isNotEmpty)
                              ? NetworkImage(imageUrl)
                              : null,
                      child:
                          (imageUrl == null || imageUrl.isEmpty)
                              ? const Icon(
                                Icons.person,
                                size: 34,
                                color: Colors.white,
                              )
                              : null,
                    ),

                    const SizedBox(height: 16),

                    /// PAL NAME
                    Text(
                      name.isNotEmpty ? "Welcome $name" : "Welcome",
                      style: kw400White18,
                    ),

                    const SizedBox(height: 24),
                    const Text('AgriNET', style: kw600White16),
                    const SizedBox(height: 32),

                    /// MENU ITEMS
                    // _drawerItem(
                    //   icon: Icons.person_outline,
                    //   label: 'My Profile',
                    //   onTap: () {
                    //     Get.back(); // Close drawer
                    //   },
                    // ),
                    // const SizedBox(height: 12),
                    //
                    // _drawerItem(
                    //   icon: Icons.store_mall_directory_outlined,
                    //   label: 'Buy',
                    //   onTap: () {
                    //     Get.back();
                    //     Get.toNamed(Routes.BUYER_HOME);
                    //   },
                    // ),
                    // const SizedBox(height: 12),
                    _drawerItem(
                      icon: Icons.shopping_bag_outlined,
                      label: 'My Bids',
                      onTap: () {
                        Get.toNamed(Routes.BUYER_MY_BIDS);
                      },
                    ),
                    const SizedBox(height: 12),

                    _drawerItem(
                      icon: Icons.assignment_outlined,
                      label: 'My Demands',
                      onTap: () {
                        Get.toNamed(Routes.BUYER_DEMANDS);
                      },
                    ),
                    const SizedBox(height: 12),

                    _drawerItem(
                      icon: Icons.campaign_outlined,
                      label: 'Advertise Demand',
                      onTap: () {
                        Get.toNamed(Routes.BUYER_ADS_DEMAND);
                      },
                    ),

                    const SizedBox(height: 12),

                    _drawerItem(
                      icon: Icons.logout_outlined,
                      label: 'Logout',
                      onTap: () {
                        Get.back();
                        UserPrefs.logout();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
