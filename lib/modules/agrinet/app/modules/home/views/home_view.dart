// home_view.dart
import 'package:citizenone_app/modules/agrinet/app/components/ui/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/home_image_carousal.dart';
import '../../../models/HomeResp/HomeImageResp.dart';
import '../controllers/home_controller.dart';
import 'MenuSectionWidget.dart';
import 'home_side_menu.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return PopScope(
      canPop: false,

      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;

        // AgrinetModule.finish('return_to_guest_user');
        Get.back();
      },
      child: Scaffold(
        backgroundColor: const Color(0xfff4faf6),
        drawer: const HomeSideMenu(),
        key: scaffoldKey,

        body: Obx(() {
          final home = controller.honeEntity();
          final images = home.slideimages ?? <Slideimages>[];
          final sections = controller.sections;

          return BaseScreen(
            isLoading: controller.isLoading.value,
            child: Column(
              children: [
                HomeHeaderCarousel(
                  images: images,
                  currentIndex: controller.currentIndex,
                  carouselController: controller.carouselSliderController,
                  onPageChanged: (index) {
                    controller.currentIndex.value = index;
                  },
                  onMenuTap: () => scaffoldKey.currentState?.openDrawer(),
                  onLogoutTap: () {
                    controller.logout();
                  },
                ),

                // ===== Body sections =====
                Expanded(
                  child: ListView.builder(
                    itemCount: sections.length,
                    itemBuilder: (context, index) {
                      final section = sections[index];
                      return MenuSectionWidget(
                        title: section.title,
                        items: section.items,
                        onTap: controller.onMenuTap,
                      ).paddingSymmetric(horizontal: 8);
                    },
                  ),
                ),
              ],
            ),
          );
        }),

        // // bottom nav (3 dots like your screen)
        // bottomNavigationBar: Container(
        //   height: 60,
        //   padding: const EdgeInsets.symmetric(horizontal: 60),
        //   decoration: const BoxDecoration(
        //     color: Colors.white,
        //     boxShadow: [
        //       BoxShadow(
        //         blurRadius: 4,
        //         offset: Offset(0, -1),
        //         spreadRadius: 1,
        //         color: Colors.black12,
        //       ),
        //     ],
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: const [
        //       Icon(Icons.dashboard_outlined),
        //       Icon(Icons.radio_button_unchecked),
        //       Icon(Icons.play_arrow),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
