import 'package:get/get.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../data/model/args/track_order_args.dart';
import '../../../data/model/loan/loan_status/application_submission.dart';
import '../../../data/model/loan/track/track_order_resp.dart';
import '../../../data/remote/provider/order_service.dart';

class AutoLoanTrackOrderStatusController extends GetxController {
  late TrackOrderArgs args;

  String orderKey = '';
  String categoryType = '';
  bool isLoanStatus = false;

  RxBool isLoading = true.obs;

  RxList<ApplicationSubmitted> applicationSubmitted =
      <ApplicationSubmitted>[].obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments is TrackOrderArgs) {
      args = Get.arguments;
      orderKey = args.key;
      categoryType = args.categoryType;
      isLoanStatus = args.isLoanStatus;
    }

    print('AUTO LOAN ORDER KEY => $orderKey');

    getDigiSlaTracking();
  }

  Future<void> getDigiSlaTracking() async {
    isLoading(true);

    try {
      final Map<String, dynamic> req = {"reqSecureKey": orderKey};

      print("✅ Digi SLA API BODY => $req");

      final TrackOrderResp? resp = await OrderService.digiSlaTracking(req);

      if (resp == null) {
        appSnackbar(
          message: 'No response from server',
          snackbarState: SnackbarState.warning,
        );
        return;
      }

      print("✅ Digi SLA RESPONSE => ${resp.toJson()}");

      // Check if API returned success
      if (resp.chMessage?.isError == true) {
        appSnackbar(
          message: resp.chMessage?.message ?? 'Digi SLA failed',
          snackbarState: SnackbarState.warning,
        );
      }

      // Map response to correct ApplicationSubmitted class
      applicationSubmitted.value =
          (resp.applicationSubmitted ?? [])
              .map((e) => ApplicationSubmitted.fromJson(e.toJson()))
              .toList();

      if (applicationSubmitted.isEmpty) {
        appSnackbar(
          message: 'No loan status available',
          snackbarState: SnackbarState.info,
        );
      }
    } catch (e, st) {
      print("❌ getDigiSlaTracking ERROR: $e");
      print(st);
      appSnackbar(
        message: 'Unable to fetch loan status',
        snackbarState: SnackbarState.warning,
      );
    } finally {
      isLoading(false);
    }
  }
}
