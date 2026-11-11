import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_carousel_slider.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_loader.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/purchase/purchase_main.dart';
import 'package:citizenone_app/modules/agrinet/app/data/remote/api_service/init_api_service.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/purchase/views/view_all_page.dart';
import 'package:citizenone_app/modules/agrinet/app/routes/app_pages.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_assets.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/purchase_controller.dart';

class PurchaseView extends GetView<PurchaseController> {
  const PurchaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgColors.kEFFFF2,
      drawer: _customDrawer(),
      body: Column(
        children: [_purchaseCustomAppBar(context), Expanded(child: _body())],
      ),
    );
  }

  Widget _body() {
    return Obx(
      () =>
          controller.isLoading.value
              ? Center(child: AgLoader())
              : Column(
                children: [
                  _bannerSlider(),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories',
                          style: TextStyle(color: AgColors.buttonColor),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => ViewAllPage());
                          },
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: _categoryWidget()),
                ],
              ),
    );
  }

  Widget _bannerSlider() => Padding(
    padding: const EdgeInsets.all(10),
    child: AgCarouselSlider(imageList: controller.bannerImageList),
  );

  Widget _categoryWidget() {
    if (controller.categoryList.isEmpty) {
      return const Center(child: Text("No categories available"));
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 8,
        childAspectRatio: 1.27,
      ),
      itemCount:
          controller.categoryList.length > 1
              ? 2
              : controller.categoryList.length,
      itemBuilder: (context, index) {
        Category category = controller.categoryList[index];

        return InkWell(
          onTap: () {
            Get.toNamed(Routes.PRODUCT_VIEW, arguments: category);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: CachedNetworkImage(
                    imageUrl:
                        '${APIService.baseUrl.substring(0, APIService.baseUrl.length - 1)}${category.imgUrl!}',
                    fit: BoxFit.contain,

                    placeholder:
                        (context, url) =>
                            const Center(child: CircularProgressIndicator()),

                    errorWidget:
                        (context, url, error) => const Icon(Icons.image),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      category.name!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _purchaseCustomAppBar(BuildContext context) {
    return Container(
      color: AgColors.colorPrimary,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Left Menu Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Builder(
                      builder:
                          (context) => InkWell(
                            onTap: () => Scaffold.of(context).openDrawer(),
                            child: const Icon(Icons.menu, color: Colors.white),
                          ),
                    ),
                  ),

                  // Center Logo
                  Image.asset(AgAssets.farmerIconAppBar, width: 45, height: 45),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Find Crops',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _customDrawer() {
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
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, size: 30, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Welcome',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 40),
                    _drawerItem(
                      icon: Icons.shopping_bag_outlined,
                      label: 'My WishList',
                    ),
                    const SizedBox(height: 12),
                    _drawerItem(
                      icon: Icons.inventory_2_outlined,
                      label: 'My Orders',
                    ),
                    const SizedBox(height: 12),
                    _drawerItem(
                      icon: Icons.shopping_cart_outlined,
                      label: 'Shopping Cart',
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

  Widget _drawerItem({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 16),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }
}
