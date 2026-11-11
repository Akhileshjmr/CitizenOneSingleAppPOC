import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../data/model/buyer_ads_bids/buyer_ads_detail.dart';
import '../../../data/model/view_bids/adverise_history_list.dart';
import '../../../data/provider/buyer_bids_services.dart';
import '../../buyer_home/controllers/buyer_home_controller.dart';

class BuyerAdsDetailController extends GetxController {
  RxBool isLoading = false.obs;
  Rxn<BuyerAdsBidDetailRes> adsDetail = Rxn<BuyerAdsBidDetailRes>();

  AdvertiseProduce? selectedAdvertiseProduce;
  final BuyerHomeController buyerHomeController =
      Get.find<BuyerHomeController>();

  BuyerAdsDetailController();

  /// Use onReady instead of onInit so UI is already mounted.
  @override
  void onReady() {
    super.onReady();
    fetchAdvertiseDetails();
  }

  Future<void> fetchAdvertiseDetails() async {
    isLoading.value = true;

    // Safely read the selected advertise from home controller (it might be Rxn)
    selectedAdvertiseProduce = buyerHomeController.selectedAdvertiseProduce;

    if (selectedAdvertiseProduce == null) {
      isLoading.value = false;
      return;
    }

    try {
      final res = await BuyerBidsService.fetchBuyerAdDetail(
        id: selectedAdvertiseProduce?.id ?? '',
        groupID: selectedAdvertiseProduce?.groupID ?? '',
      );

      if (res != null) {
        adsDetail.value = res;
      } else {
        // Schedule snackbar after frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          agSnackbar(title: "Error", msg: "Unable to load advertise details");
        });
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        agSnackbar(title: "Error", msg: "Something went wrong");
      });
    } finally {
      isLoading.value = false;
    }
  }
}
