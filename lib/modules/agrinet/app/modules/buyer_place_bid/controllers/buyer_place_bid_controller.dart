import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_alert_dialogue.dart';
import '../../../data/model/buyer_ads_bids/buyer_ads_detail.dart';
import '../../../data/provider/buyer_bids_services.dart';
import '../../buyer_ads_detail/controllers/buyer_ads_detail_controller.dart';

class BuyerPlaceBidController extends GetxController {
  final priceController = TextEditingController();

  final isLoading = true.obs;
  final isSubmitting = false.obs;

  BuyerAdsBidDetailRes? data;

  @override
  void onInit() {
    super.onInit();

    /// 🔥 Fetch selected ad details from BuyerAdsDetailController
    final detailCtrl = Get.find<BuyerAdsDetailController>();

    data = detailCtrl.adsDetail.value;

    if (data == null) {
      isLoading.value = false;
      AgAlertDialog.show(
        title: "Error",
        message: "No advertisement details found.",
      );
      return;
    }

    isLoading.value = false;
  }

  /// ------------------ Safe Getters ---------------------
  String get adId => data?.id ?? "";
  String get cropName => data?.cropName.first.cropName ?? "-";

  String get minPrice => data?.minPrice?.replaceAll("\$", "") ?? "0";
  String get quantity => data?.totalQuantity ?? "0";

  /// ------------------ Validation ----------------------
  bool validatePrice() {
    final entered = double.tryParse(priceController.text.trim()) ?? 0;
    final min = double.tryParse(minPrice) ?? 0;

    return entered >= min;
  }

  /// ------------------ Submit Bid ----------------------
  Future<void> submitBid() async {
    if (!validatePrice()) {
      AgAlertDialog.show(
        title: "Alert",
        message: "Min. price should be \$$minPrice or higher.",
      );
      return;
    }

    isSubmitting.value = true;

    await BuyerBidsService.placeBid(
      adId: adId,
      cropName: cropName,
      price: priceController.text.trim(),
      quantity: quantity,
    );

    isSubmitting.value = false;
  }
}
