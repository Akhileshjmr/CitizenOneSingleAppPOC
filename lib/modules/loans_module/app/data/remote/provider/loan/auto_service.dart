import 'package:dio/dio.dart';

import '../../../../components/utils/app_snackbar.dart';
import '../../../config/logger.dart';
import '../../../local/store/local_store.dart';
import '../../../local/store/user_provider.dart';
import '../../../model/limit/limit_fna_sub_resp.dart';
import '../../../model/loan/PersonalLoan/pl_chat/ComResp.dart';
import '../../../model/loan/auto_loan/AutoLoanHistoryResp.dart';
import '../../../model/loan/bank_list/BankListResp.dart';
import '../../../model/loan/fee_charges/FeeChargesResp.dart';
import '../../../model/loan/pre_approved/PreApprovedResp.dart';
import '../../../model/loan/property_form/Property_model.dart';
import '../../../model/loan/save_emi_resp.dart';
import '../../../model/user/documents/Documents.dart';
import '../../../model/user/documents/UploadDocumentResp.dart';
import '../../../model/vehicle/Vehicle_model.dart';
import '../../api_service/init_api_service.dart';

class AutoService {
  static Future<LimitFnaSubResp?> saveProfileRetail() async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'customer/profile/save-profile-retail',
      data: <String, dynamic>{
        'reqSecureKey': UserProvider.currentUser?.addiParams?[0] ?? '',
      },
    );
    if (res?.statusCode == 200) {
      return LimitFnaSubResp.fromJson(res?.data ?? <String, dynamic>{});
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return LimitFnaSubResp();
  }

  static Future<PreApprovedResp?> fetchRealEstatePreApprovedLoans({
    String filterVal = '/Real Estate',
  }) async {
    try {
      final Response<Map<String, dynamic>?>? response =
          await APIService.postAuth(
            path: 'pl/pre-approved-loan/cust-loan-history',
            data: <String, dynamic>{
              "reqSecureKey":
                  ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                      ? (UserProvider.currentUser?.addiParams[0] ?? '')
                      : '',
              "filterVal": "HOUSE_LOAN",
              "addiParams": [],
            },
          );
      if (response != null) {
        return PreApprovedResp.fromJson(response.data!);
      }
    } on Exception catch (e) {
      // logE(e);
    }
    return null;
  }

  static Future<bool> submitFinaceFrom(String url) async {
    bool success = false;
    try {
      final String mobNumber = await UserProvider.getMobileNumber();

      final Response<Map<String, dynamic>?>? response =
          await APIService.postAuth(
            path: url,
            data: <String, dynamic>{
              "reqSecureKey": mobNumber,
              // "filterVal": "AGENCY_BANKING",
            },
          );
      if (response?.statusCode == 200) {
        final LimitFnaSubResp value = LimitFnaSubResp.fromJson(
          response?.data ?? <String, dynamic>{},
        );
        if (value.chMessage?.isError == false) {
          success = true;
        } else {
          success = false;
        }
      }
    } on Exception catch (e) {
      logE(e);
    }
    return success;
  }

  static Future<bool> realEstateSubmitPayment() async {
    try {
      final Response<Map<String, dynamic>?>? response =
          await APIService.postAuth(
            path: 'realestate/home/orders/payment-type',
            data: <String, dynamic>{
              'reqSecureKey':
                  ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                      ? (UserProvider.currentUser?.addiParams[0] ?? '')
                      : '',
              'filterVal': LocalStore.buyNowFilterVal,
              'addiParams': ['FINANCE'],
            },
          );
      if (response != null) {
        return true;
      }
    } on Exception catch (e) {
      logE(e);
    }
    return false;
  }

  ///
  static Future<VehicleModel?> fetchVehicleDetails() async {
    try {
      final Response<Map<String, dynamic>?>? response =
          await APIService.postAuth(
            path: 'auto/orders/fetch-vehicle-details',
            data: <String, dynamic>{
              'reqSecureKey':
                  ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                      ? (UserProvider.currentUser?.addiParams[0] ?? '')
                      : '',
            },
          );
      if (response != null) {
        return VehicleModel.fromJson(response.data!);
      }
    } on Exception catch (e) {
      logE(e);
    }
    return VehicleModel();
  }

  static Future<ComResp?> submitVehicleDetail({
    required Map<String, dynamic> formData,
  }) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'auto/orders/add-vehicle-details',
      data: formData,
    );

    if (res?.statusCode == 200) {
      return ComResp.fromJson(res?.data ?? <String, dynamic>{});
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return ComResp();
  }

  static Future<LimitFnaSubResp> submitPayment(
    String filterval,
    String skuID,
    String productid,
  ) async {
    try {
      final Response<Map<String, dynamic>?>? response =
          await APIService.postAuth(
            path: 'auto/orders/auto-payment-type',
            data: <String, dynamic>{
              'reqSecureKey':
                  ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                      ? (UserProvider.currentUser?.addiParams[0] ?? '')
                      : '',
              'filterVal': productid,
              'addiParams': ['FINANCE'],
            },
          );
      if (response != null) {
        return LimitFnaSubResp.fromJson(response.data ?? <String, dynamic>{});
      }
    } on Exception catch (e) {
      logE(e);
    }
    return LimitFnaSubResp();
  }

  static Future<BankListResp> fetchBankList(String filterval) async {
    try {
      final Response<Map<String, dynamic>?>? response =
          await APIService.postAuth(
            path: 'auto/orders/get-ip-emi-details',
            data: <String, dynamic>{
              'paging': {
                'pageNum': 1,
                'paginationRecords': 0,
                'recsPerPage': 10,
                'sortByType': 'ASC',
                'totalPages': 0,
                'totalRecs': 0,
              },
              'addiParams': ['FINANCE_LOAN', 'AUTO'],
              'filterHashKey': 0,
              'filterVal': filterval,
              'hKey': 0,
              'reqSecureKey':
                  ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                      ? (UserProvider.currentUser?.addiParams[0] ?? '')
                      : '',
            },
          );
      if (response != null) {
        return BankListResp.fromJson(response.data ?? <String, dynamic>{});
      }
    } on Exception catch (e) {
      logE(e);
    }
    return BankListResp();
  }

  static Future<BankListResp> fetchCGBankList(String filterval) async {
    try {
      final Response<Map<String, dynamic>?>? response =
          await APIService.postAuth(
            path: 'orders/cg/get-ip-emi-details',
            data: <String, dynamic>{
              'paging': {
                'pageNum': 1,
                'paginationRecords': 0,
                'recsPerPage': 10,
                'sortByType': 'ASC',
                'totalPages': 0,
                'totalRecs': 0,
              },
              'addiParams': ['FINANCE_LOAN', 'WHITE_GOODS'],
              'filterHashKey': 0,
              'filterVal': filterval,
              'hKey': 0,
              'reqSecureKey':
                  ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                      ? (UserProvider.currentUser?.addiParams[0] ?? '')
                      : '',
            },
          );
      if (response != null) {
        return BankListResp.fromJson(response.data ?? <String, dynamic>{});
      }
    } on Exception catch (e) {
      logE(e);
    }
    return BankListResp();
  }

  static Future<BankListResp> fetchRealEstateBankList(String filterval) async {
    try {
      final Response<Map<String, dynamic>?>? response =
          await APIService.postAuth(
            path: 'realestate/home/orders/get-ip-emi-details',
            data: <String, dynamic>{
              'paging': {
                'pageNum': 1,
                'paginationRecords': 0,
                'recsPerPage': 10,
                'sortByType': 'ASC',
                'totalPages': 0,
                'totalRecs': 0,
              },
              'addiParams': ['FINANCE_LOAN', 'REAL_ESTATE'],
              'filterHashKey': 0,
              'filterVal': filterval,
              'hKey': 0,
              'reqSecureKey':
                  ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                      ? (UserProvider.currentUser?.addiParams[0] ?? '')
                      : '',
            },
          );
      if (response != null) {
        return BankListResp.fromJson(response.data ?? <String, dynamic>{});
      }
    } on Exception catch (e) {
      logE(e);
    }
    return BankListResp();
  }

  static Future<SaveEmiResp?> saveCGEMIDetails({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'orders/cg/save-finance-emi-info',
      data: formData,
    );

    if (res?.statusCode == 200) {
      return SaveEmiResp.fromJson(res?.data ?? <String, dynamic>{});
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return SaveEmiResp();
  }

  static Future<SaveEmiResp?> saveRealEstateEMIDetails({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'realestate/home/orders/save-finance-emi-info',
      data: formData,
    );

    if (res?.statusCode == 200) {
      return SaveEmiResp.fromJson(res?.data ?? <String, dynamic>{});
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return SaveEmiResp();
  }

  static Future<SaveEmiResp?> saveEMIDetails({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'auto/orders/save-finance-emi-info',
      data: formData,
    );

    if (res?.statusCode == 200) {
      return SaveEmiResp.fromJson(res?.data ?? <String, dynamic>{});
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return SaveEmiResp();
  }

  static Future<FeeChargesResp?> getConsumerGoodsFeeCharges({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'orders/cg/finance-fees-and-charges',
      data: formData,
    );

    if (res?.statusCode == 200) {
      return FeeChargesResp.fromJson(res?.data ?? <String, dynamic>{});
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return FeeChargesResp();
  }

  static Future<FeeChargesResp?> saveRealEstateFeeCharges({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'realestate/home/orders/finance-fees-and-charges',
      data: formData,
    );

    if (res?.statusCode == 200) {
      return FeeChargesResp.fromJson(res?.data ?? <String, dynamic>{});
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return FeeChargesResp();
  }

  static Future<FeeChargesResp?> saveAutoFeeCharges({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'auto/orders/finance-fees-and-charges',
      data: formData,
    );

    if (res?.statusCode == 200) {
      return FeeChargesResp.fromJson(res?.data ?? <String, dynamic>{});
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return FeeChargesResp();
  }

  static Future<List<Documents>?> getCGUserDocuments(
    Map<String, dynamic> jsonBody,
  ) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'orders/cg/process-view-documents',
      data: jsonBody,
    );

    if (res?.statusCode == 200) {
      if (res?.data?['documents'] != null) {
        return List<Documents>.from(
          res?.data?['documents'].map<dynamic>(
            (dynamic e) => Documents.fromJson(e),
          ),
        );
      }
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return <Documents>[];
  }

  static Future<bool> LinkRealEstateDocument({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'realestate/home/orders/link-doc-with-proc',
      data: formData,
    );

    if (res?.statusCode == 200) {
      success = true;
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return success;
  }

  static Future<bool> LinkDocument({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'auto/orders/link-doc-with-proc',
      data: formData,
    );

    if (res?.statusCode == 200) {
      success = true;
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return success;
  }

  static Future<List<Documents>?> getRealEstateUserDocuments(
    Map<String, dynamic> jsonBody,
  ) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'realestate/home/orders/process-view-documents',
      data: jsonBody,
    );

    if (res?.statusCode == 200) {
      if (res?.data?['documents'] != null) {
        return List<Documents>.from(
          res?.data?['documents'].map<dynamic>(
            (dynamic e) => Documents.fromJson(e),
          ),
        );
      }
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return <Documents>[];
  }

  ///To get docs list
  static Future<List<Documents>?> getUserDocuments(
    Map<String, dynamic> jsonBody,
  ) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'auto/orders/process-view-documents',
      data: jsonBody,
    );

    if (res?.statusCode == 200) {
      if (res?.data?['documents'] != null) {
        return List<Documents>.from(
          res?.data?['documents'].map<dynamic>(
            (dynamic e) => Documents.fromJson(e),
          ),
        );
      }
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return <Documents>[];
  }

  static Future<LimitFnaSubResp?> saveCGFinanceEMI({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'orders/cg/submit-finance-order',
      data: formData,
    );

    if (res?.statusCode == 200) {
      return LimitFnaSubResp.fromJson(res?.data ?? <String, dynamic>{});
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return LimitFnaSubResp();
  }

  static Future<LimitFnaSubResp?> saveRealEstateFinanceEMI({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'realestate/home/orders/submit-finance-order',
      data: formData,
    );

    if (res?.statusCode == 200) {
      return LimitFnaSubResp.fromJson(res?.data ?? <String, dynamic>{});
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return LimitFnaSubResp();
  }

  static Future<LimitFnaSubResp?> saveFinanceEMI({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'auto/orders/submit-finance-order',
      data: formData,
    );

    if (res?.statusCode == 200) {
      return LimitFnaSubResp.fromJson(res?.data ?? <String, dynamic>{});
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return LimitFnaSubResp();
  }

  static Future<bool> LinkCGDocument({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'orders/cg/link-doc-with-proc',
      data: formData,
    );

    if (res?.statusCode == 200) {
      success = true;
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return success;
  }

  static Future<ComResp?> submitPropertyDetail({
    required Map<String, dynamic> formData,
  }) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'realestate/home/buy-with-third-party',
      data: formData,
    );

    if (res?.statusCode == 200) {
      return ComResp.fromJson(res?.data ?? <String, dynamic>{});
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return ComResp();
  }

  static Future<PropertyModel?> fetchPropertyDetails(String orderId) async {
    try {
      final Response<Map<String, dynamic>?>? response =
          await APIService.postAuth(
            path: 'realestate/home/view-third-party-order',
            data: <String, dynamic>{
              'reqSecureKey':
                  ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                      ? (UserProvider.currentUser?.addiParams[0] ?? '')
                      : '',
            },
          );
      if (response != null) {
        return PropertyModel.fromJson(response.data!);
      }
    } on Exception catch (e) {
      logE(e);
    }
    return PropertyModel();
  }

  static Future<AutoLoanHistoryResp?> getAutoLoanHistory() async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'auto/orders/order-history-loan',
      data: <String, dynamic>{
        'reqSecureKey':
            ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                ? (UserProvider.currentUser?.addiParams[0] ?? '')
                : '',
      },
    );

    if (res?.statusCode == 200) {
      return AutoLoanHistoryResp.fromJson(res?.data ?? <String, dynamic>{});
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return AutoLoanHistoryResp();
  }

  static Future<UploadDocumentResp?> uploadCGListDocuments(
    Map<String, Object> jsonBody,
  ) async {
    try {
      dynamic response = await APIService.postAuth(
        path: 'orders/cg/cust-doc-upload',
        data: jsonBody,
      );
      final jsonData = UploadDocumentResp.fromJson(
        response?.data ?? <String, dynamic>{},
      );
      // print("Got Response");
      return jsonData;
    } catch (e) {
      print("Error " + e.toString());
      rethrow;
    }
  }

  static Future<UploadDocumentResp?> uploadRealEstateListDocuments(
    Map<String, Object> jsonBody,
  ) async {
    try {
      dynamic response = await APIService.postAuth(
        path: 'realestate/home/orders/cust-doc-upload',
        data: jsonBody,
      );
      final jsonData = UploadDocumentResp.fromJson(
        response?.data ?? <String, dynamic>{},
      );
      // print("Got Response");
      return jsonData;
    } catch (e) {
      print("Error " + e.toString());
      rethrow;
    }
  }

  static Future<UploadDocumentResp?> uploadListDocuments(
    Map<String, Object> jsonBody,
  ) async {
    try {
      dynamic response = await APIService.postAuth(
        path: 'auto/orders/cust-doc-upload',
        data: jsonBody,
      );
      final jsonData = UploadDocumentResp.fromJson(
        response?.data ?? <String, dynamic>{},
      );
      // print("Got Response");
      return jsonData;
    } catch (e) {
      print("Error " + e.toString());
      rethrow;
    }
  }
}
