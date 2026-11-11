// home_controller.dart
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_png_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/utils/user_prefs.dart';
import '../../../data/provider/HomeService.dart';
import '../../../models/HomeResp/HomeImageResp.dart';
import '../../../routes/app_pages.dart';
import '../../service_enquiry/controllers/enquiry_type.dart';
import '../views/MenuItemModel.dart';

class HomeController extends GetxController {
  Rx<homeViewResp> honeEntity = homeViewResp().obs;
  final CarouselController carouselController = CarouselController();
  final CarouselSliderController carouselSliderController =
      CarouselSliderController();

  var currentIndex = 0.obs;

  RxBool isLoading = false.obs;

  final sections =
      <SectionModel>[
        SectionModel(
          title: 'Farmer',
          items: [
            MenuItemModel(
              title: 'Onboarding',
              image: PngImage.onboardingImg,
              route: Routes.FARMER_LIST,
            ),
            MenuItemModel(
              title: 'Group',
              image: PngImage.groupImg,
              route: Routes.FARMER_GROUP,
            ),
            MenuItemModel(
              title: 'Plan',
              image: PngImage.planImg,
              route: Routes.PLAN,
            ),
            MenuItemModel(
              title: 'Search/Edit Plan',
              image: PngImage.searchImg,
              route: Routes.FARM_PLANS,
            ),
          ],
        ),

        SectionModel(
          title: 'Market',
          items: [
            MenuItemModel(
              title: 'Market Price',
              image: PngImage.marketPriceImg,
              route: Routes.MARKET_FILTER,
            ),
            MenuItemModel(
              title: 'NearBy Markets',
              image: PngImage.nearbyMarketImg,
              route: Routes.GOOGLE_MAP,
            ),
            MenuItemModel(
              title: 'View Bids',
              image: PngImage.viewBidsImg,
              route: Routes.VIEW_BIDS,
            ),
            MenuItemModel(
              title: 'Publish ADS',
              image: PngImage.publishAdsImg,
              route: Routes.PUBLISH_ADS,
            ),
          ],
        ),

        SectionModel(
          title: 'Agri Services',
          items: [
            MenuItemModel(
              title: 'Weather',
              image: PngImage.weatherImg,
              route: Routes.WEATHER,
            ),
            MenuItemModel(
              title: 'Service Request',
              image: PngImage.serviceRequestImg,
              route: Routes.SERVICE_ENQUIRY,
              arguments: EnquiryType.service,
            ),
            MenuItemModel(
              title: 'Profitability',
              image: PngImage.profitabilityImg,
              route: Routes.FARM_PLAN_LIST_VIEW,
            ),
            MenuItemModel(
              title: 'Performance',
              image: PngImage.performanceImg,
              route: Routes.PERFORMANCE,
            ),
            MenuItemModel(
              title: 'Measure Land',
              image: PngImage.measureLandImg,
              route: Routes.MEASURE_LAND,
            ),
            MenuItemModel(
              title: 'Transport Enquiry',
              image: PngImage.transportEnquiryImg,
              route: Routes.SERVICE_ENQUIRY,
              arguments: EnquiryType.transport,
            ),
            MenuItemModel(
              title: 'Warehouse Enquiry',
              image: PngImage.warehouseEnqImg,
              route: Routes.SERVICE_ENQUIRY,
              arguments: EnquiryType.warehouse,
            ),
            MenuItemModel(
              title: 'Plant Protection',
              image: PngImage.plantProtectionImg,
              route: Routes.PLANT_PROTECTION,
            ),
          ],
        ),

        SectionModel(
          title: 'Dashboard And Agri Inputs',
          items: [
            MenuItemModel(
              title: 'Plan Summary',
              image: PngImage.planSummaryImg,
              route: Routes.PLAN_SUMMARY,
            ),
            MenuItemModel(
              title: 'Purchase',
              image: PngImage.purchaseImg,
              route: Routes.PURCHASE,
            ),
          ],
        ),
      ].obs;

  void onMenuTap(MenuItemModel item) {
    if (item.route != null) {
      Get.toNamed(item.route!, arguments: item.arguments);
    } else {
      // demo
      agSnackbar(title: 'Tapped', msg: item.title);
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchHome();
  }

  Future<void> fetchHome() async {
    try {
      // isLoading(true);
      honeEntity(
        await HomeService.fetchDashboardProduct(
          filterVal: '${UserPrefs.user?.userId}',
        ),
      );
      // "type": "CG_HISTORY"
      // layouts(consumerGoodEntity.value.layouts);
      // List<Layouts?> data = layouts.where((i) => i?.type == 'CG_HISTORY').toList();
      // if (data.length > 0){
      //   itemsArr(data[0]);
      // }
      //
      // consumerGoodEntity.refresh();
    } finally {
      // isLoading(false);
    }
  }

  void logout() {
    try {
      isLoading(true);
      UserPrefs.logout();
    } finally {
      isLoading(false);
    }
  }
}
