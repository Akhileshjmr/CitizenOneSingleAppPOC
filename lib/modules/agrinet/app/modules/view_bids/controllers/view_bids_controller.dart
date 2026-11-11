import 'package:citizenone_app/modules/agrinet/app/components/utils/user_prefs.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/view_bids/adverise_history_list.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/view_bids/one_advertise_history.dart';
import 'package:citizenone_app/modules/agrinet/app/data/provider/view_bids_service.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/view_bids/controllers/view_bids_variables.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/ui/ag_snackbar.dart';
import '../../../data/model/common/ch_message.dart';
import '../../../routes/app_pages.dart';

class ViewBidsController extends GetxController with ViewBidsVariables {
  @override
  void onInit() async {
    super.onInit();
    await fetchAdvertiseHistoryList();
  }

  /// -------------------------------
  /// Fetch Advertise History List
  /// -------------------------------
  Future<void> fetchAdvertiseHistoryList() async {
    try {
      isLoading(true);

      AdvertiseProductResponse? response =
          await ViewBidsService.fetchAdvertiseHistoryList();

      if (response != null) {
        // Store original list
        allAdvertiseHistoryList.assignAll(response.advertiseProduce ?? []);

        // Store filtered list (UI list)
        advertiseHistoryList.assignAll(response.advertiseProduce ?? []);
      }

      isLoading(false);
    } catch (e) {
      isLoading(false);
    }
  }

  /// -------------------------------
  /// Fetch Single Advertise History
  /// -------------------------------
  Future<void> fetchOneAdvertiseHisory(AdvertiseProduce advertiseData) async {
    try {
      selectedAdvertiseProduce = advertiseData;

      isLoading(true);

      dynamic requestBody = {
        "filterVal": advertiseData.id,
        "reqSecureKey": UserPrefs.user?.userId ?? '',
      };

      final OneAdvertiseHistory? response =
          await ViewBidsService.fetchIndividualAdvertiseHistoryList(
            requestBody: requestBody,
          );

      bidList(response?.bidPlanList ?? []);

      isLoading(false);
    } catch (e) {
      isLoading(false);
    }
  }

  /// -------------------------------
  /// Search / Filter Function
  /// -------------------------------
  void filterAdvertiseHistory(String query) {
    if (query.isEmpty) {
      // Reset list
      advertiseHistoryList.assignAll(allAdvertiseHistoryList);
      return;
    }

    final search = query.toLowerCase();

    final filtered =
        allAdvertiseHistoryList.where((item) {
          return (item.id ?? '').toLowerCase().contains(search) ||
              (item.username ?? '').toLowerCase().contains(search) ||
              (item.totalQuantity ?? '').toString().contains(search);
        }).toList();

    advertiseHistoryList.assignAll(filtered);
  }

  /// -------------------------------
  /// Format Date
  /// -------------------------------
  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> acceptBidPlan({
    required String bidId,
    required String advertiseId,
  }) async {
    try {
      if (bidId.isEmpty || advertiseId.isEmpty) {
        return agSnackbar(
          title: "Missing Information",
          msg: "Bid ID or Advertise ID is missing",
        );
      }

      isLoading(true);

      /// Request Body
      final requestBody = {
        "addiParams": [bidId],
        "filterVal": advertiseId,
        "reqSecureKey": UserPrefs.user?.userId ?? '',
      };

      final response = await ViewBidsService.acceptBidPlan(
        requestBody: requestBody,
      );

      if (response.data['chMessage'] != null) {
        ChMessage message = ChMessage.fromJson(response.data['chMessage']);

        if (!(message.isError ?? false)) {
          agSnackbar(
            title: "Success",
            msg: message.message ?? "Bid accepted success",
          );

          await fetchAdvertiseHistoryList();
          isLoading(false);
          Get.until((route) => Get.currentRoute == Routes.VIEW_BIDS);
        }
      }

      return;
    } catch (e) {
      agSnackbar(
        title: "Error",
        msg: "Something went wrong. Please try again.",
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> rejectBidPlan({
    required String bidId,
    required String advertiseId,
  }) async {
    try {
      if (bidId.isEmpty || advertiseId.isEmpty) {
        return agSnackbar(
          title: "Missing Information",
          msg: "Bid ID or Advertise ID is missing",
        );
      }

      isLoading(true);

      /// Request Body
      final requestBody = {
        "addiParams": [bidId],
        "filterVal": advertiseId,
        "reqSecureKey": UserPrefs.user?.userId ?? '',
      };

      final response = await ViewBidsService.rejectBidPlan(
        requestBody: requestBody,
      );

      if (response.data['chMessage'] != null) {
        ChMessage message = ChMessage.fromJson(response.data['chMessage']);

        if (!(message.isError ?? false)) {
          agSnackbar(
            title: "Success",
            msg: message.message ?? "Bit rejected successfully",
          );

          await fetchAdvertiseHistoryList();
          Get.until((route) => Get.currentRoute == Routes.VIEW_BIDS);
        }
      }
    } catch (e) {
      agSnackbar(
        title: "Error",
        msg: "Something went wrong. Please try again.",
      );
    } finally {
      isLoading(false);
    }
  }
}
