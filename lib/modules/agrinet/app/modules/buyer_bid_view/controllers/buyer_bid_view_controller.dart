import 'package:citizenone_app/modules/agrinet/app/routes/app_pages.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_alert_dialogue.dart';
import '../../../components/utils/user_prefs.dart';
import '../../../data/model/buyer_ads_bids/buyer_ads_detail.dart';
import '../../../data/provider/buyer_bids_services.dart';
import '../../buyer_my_bids/controllers/buyer_my_bids_controller.dart';

class BuyerBidViewController extends GetxController {
  final isLoading = true.obs;
  final bidDetail = Rx<BuyerAdsBidDetailRes?>(null);

  late String id;
  late String bidID;

  @override
  void onInit() {
    super.onInit();

    /// Instead of args → get data from BuyerMyBidsController
    final myBidsCtrl = Get.find<BuyerMyBidsController>();

    final selected = myBidsCtrl.selectedBid.value;

    if (selected == null) {
      isLoading.value = false;
      return;
    }

    id = UserPrefs.user?.userId.toString() ?? "";
    bidID = selected.bidId ?? "";

    fetchBidDetail();
  }

  Future<void> fetchBidDetail() async {
    isLoading.value = true;

    bidDetail.value = await BuyerBidsService.fetchBuyerBidDetail(
      id: id,
      groupID: bidID,
    );

    isLoading.value = false;
  }

  /// CANCEL BID FLOW
  void showCancelDialog() {
    AgAlertDialog.confirm(
      title: "Cancel the Bid",
      message: "Are you sure you want to cancel the bid?",
      cancelText: "No,Go back",
      okText: "Yes,Cancel the bid",
      onConfirm: () => cancelBid(),
    );
  }

  Future<void> cancelBid() async {
    final success = await BuyerBidsService.cancelBid(groupID: bidID, id: id);

    if (success) {
      AgAlertDialog.show(
        title: "Success",
        message: "Your bid has been cancelled.",
        onOk: () => Get.back(),
      );
    } else {
      AgAlertDialog.show(
        title: "Error",
        message: "Bid cancellation failed. Try again later.",
      );
    }
  }

  void openChat() {
    Get.toNamed(Routes.CHAT, arguments: {'bid_id': bidID});
  }
}
