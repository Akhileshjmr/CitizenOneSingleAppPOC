import 'package:dio/dio.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../config/logger.dart';
import '../../model/insurance/AutoProdInsuranceResponse.dart';
import '../../model/loan/auto/Orders.dart';
import '../../model/loan/offer/offer_letter_response.dart';
import '../../model/loan/order/order_basic_resp.dart';
import '../../model/loan/order/order_history_resp.dart';
import '../../model/loan/track/track_order_resp.dart';
import '../api_service/ApiEndPoints.dart';
import '../api_service/init_api_service.dart';

class OrderService {
  static Future<OrderHistoryList?> getOrderHistory(
    String url,
    Map<String, dynamic> jsonBody,
  ) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: url,
      data: jsonBody,
    );

    if (res?.statusCode == 200) {
      if (res?.data?['chMessage']['type'] == 'SUCCESS') {
        logI(res?.data);
        return OrderHistoryList.fromJson(res?.data ?? <String, dynamic>{});
      } else {
        appSnackbar(
          message: res?.data?['chMessage']['message'],
          snackbarState: SnackbarState.warning,
        );
      }
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }

    return OrderHistoryList();
  }

  static Future<List<OrderInfo>> getInProcessOrderHistory(
    String url,
    Map<String, dynamic> jsonBody,
  ) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: url,
      data: jsonBody,
    );

    if (res?.statusCode == 200) {
      if (res?.data!['orders'] != null) {
        return List<OrderInfo>.from(
          res?.data!['orders'].map<dynamic>(
            (dynamic e) => OrderInfo.fromJson(e),
          ),
        );
      } else {
        appSnackbar(
          message: 'No orders found',
          snackbarState: SnackbarState.warning,
        );
      }
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }

    return <OrderInfo>[];
  }

  static Future<AutoProdInsuranceResponse?> getInsurenceDetail(
    String url,
    Map<String, dynamic> jsonBody,
  ) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: url,
      data: jsonBody,
    );

    if (res?.statusCode == 200) {
      final AutoProdInsuranceResponse apiRes =
          AutoProdInsuranceResponse.fromJson(res?.data ?? <String, dynamic>{});

      if (!(apiRes.chMessage?.isError ?? false)) {
        return AutoProdInsuranceResponse.fromJson(
          res?.data ?? <String, dynamic>{},
        );
      } else {
        appSnackbar(
          message: apiRes.chMessage?.message ?? '',
          snackbarState: SnackbarState.warning,
        );
      }
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }

    return AutoProdInsuranceResponse();
  }

  static Future<AutoProdInsuranceResponse?> getInsurance(
    String url,
    Map<String, dynamic> jsonBody,
  ) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: url,
      data: jsonBody,
    );

    if (res?.statusCode == 200) {
      final AutoProdInsuranceResponse apiRes =
          AutoProdInsuranceResponse.fromJson(res?.data ?? <String, dynamic>{});
      if (!(apiRes.chMessage?.isError ?? false)) {
        return AutoProdInsuranceResponse.fromJson(
          res?.data ?? <String, dynamic>{},
        );
      } else {
        appSnackbar(
          message: apiRes.chMessage?.message ?? '',
          snackbarState: SnackbarState.warning,
        );
      }
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }

    return AutoProdInsuranceResponse();
  }

  static Future<OfferLetterResponse?> getOfferLetter(
    Map<String, dynamic> jsonBody,
  ) async {
    try {
      final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
        path: ApiEndPoints.offerLetterViewDownload,
        data: jsonBody,
      );

      if (res?.statusCode == 200) {
        return OfferLetterResponse.fromJson(res?.data ?? <String, dynamic>{});
      } else {
        appSnackbar(
          message: 'Failed to fetch offer letter',
          snackbarState: SnackbarState.warning,
        );
      }
    } catch (e) {
      appSnackbar(
        message: 'Error fetching offer letter: $e',
        snackbarState: SnackbarState.warning,
      );
    }
    return null;
  }

  static Future<TrackOrderResp?> digiSlaTracking(
    Map<String, dynamic> body,
  ) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.digiSlaPreApprovedTracking,
      data: body,
    );

    if (res?.statusCode == 200) {
      final TrackOrderResp resp = TrackOrderResp.fromJson(res?.data ?? {});

      if (resp.chMessage?.isError == false) {
        return resp;
      } else {
        appSnackbar(
          message: resp.chMessage?.message ?? 'Digi SLA failed',
          snackbarState: SnackbarState.warning,
        );
      }
    } else {
      appSnackbar(
        message: 'Digi SLA API error',
        snackbarState: SnackbarState.warning,
      );
    }

    return null;
  }

  static Future<List<Orders>?> getAutoOrderHistory(
    String url,
    Map<String, dynamic> jsonBody,
  ) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: url,
      data: jsonBody,
    );

    if (res?.statusCode == 200) {
      if (res?.data?['chMessage']['type'] == 'SUCCESS') {
        logI(res?.data);
        return List<Orders>.from(
          res?.data!['orders'].map<dynamic>((dynamic e) => Orders.fromJson(e)),
        );
      } else {
        appSnackbar(
          message: res?.data?['chMessage']['message'],
          snackbarState: SnackbarState.warning,
        );
      }
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }

    return [];
  }
}
