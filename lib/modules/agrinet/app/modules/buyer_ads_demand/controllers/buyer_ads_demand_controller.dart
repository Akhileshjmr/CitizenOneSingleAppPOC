import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/utils/user_prefs.dart';
import '../../../data/model/buyer_demand/create_buyer_demand_req.dart';
import '../../../data/provider/buyer_demand_service.dart';

class BuyerAdsDemandController extends GetxController {
  final cropName = TextEditingController();
  final pricePerKg = TextEditingController();
  final totalQty = TextEditingController();
  final description = TextEditingController();

  Rxn<DateTime> requiredDate = Rxn<DateTime>();

  RxBool isSubmitting = false.obs;

  Future<void> submit() async {
    if (cropName.text.trim().isEmpty) {
      _showError("Enter Commodity");
      return;
    }

    if (pricePerKg.text.trim().isEmpty) {
      _showError("Enter Minimum Price");
      return;
    }

    final price = double.tryParse(pricePerKg.text.trim());
    if (price == null || price <= 0) {
      _showError("Enter a valid Minimum Price");
      return;
    }

    if (totalQty.text.trim().isEmpty) {
      _showError("Enter Total Quantity");
      return;
    }

    final qty = int.tryParse(totalQty.text.trim());
    if (qty == null || qty <= 0) {
      _showError("Enter a valid Quantity");
      return;
    }

    if (requiredDate.value == null) {
      _showError("Select Required On Date");
      return;
    }

    // ---- PASSED ALL VALIDATIONS ----
    isSubmitting.value = true;

    final req = CreateBuyerDemandReq(
      filterVal: UserPrefs.user?.userId.toString() ?? "",
      cropName: cropName.text.trim(),
      desc: description.text.trim(),
      pricePerKg: price,
      totalQuantity: qty,
      requestedOn: requiredDate.value!.millisecondsSinceEpoch,
    );

    await BuyerDemandService.createBuyerDemand(req);

    isSubmitting.value = false;
  }

  void updateRequiredDate(DateTime date) {
    requiredDate.value = date;
  }

  void _showError(String msg) {
    agSnackbar(title: "Missing Information", msg: msg);
  }
}
