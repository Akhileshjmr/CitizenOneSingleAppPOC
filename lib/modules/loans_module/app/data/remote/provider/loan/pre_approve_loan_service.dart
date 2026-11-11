import 'package:dio/dio.dart';

import '../../../../components/utils/app_snackbar.dart';
import '../../../config/logger.dart';
import '../../../local/store/user_provider.dart';
import '../../../model/limit/limit_fna_sub_resp.dart';
import '../../../model/loan/PreApprove/PreApproveCheckEligible/PRCheckEligiblaResp.dart';
import '../../../model/loan/PreApprove/PreAproveHome/PreApproveHomeResp.dart';
import '../../../model/loan/PreApprove/prEmiCalculator/PRCalculatorResp.dart';
import '../../../model/loan/PreApprove/preApproveBankList/PreBankListResp.dart';
import '../../../model/loan/PreApprove/preApproveForm/PrFormResp.dart';
import '../../../model/loan/PreApprove/preApproveHistory/PRLoanHistoryResp.dart';
import '../../../model/loan/bank_list/BankListResp.dart';
import '../../../model/select_box_model/SelectOptionList.dart';
import '../../../model/user/documents/Documents.dart';
import '../../../model/user/documents/UploadDocumentResp.dart';
import '../../api_service/init_api_service.dart';

class PreApproveLoanService {
  /// To get PL loan details

  static Future<PreApproveHomeResp> getPreApproveHome() async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: 'pl/pre-approved-loan/pre-approved-loans',
        data: {
          'filterVal': "/loan-products",
          "reqSecureKey":
              ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0)
                  ? (UserProvider.currentUser?.addiParams?[0] ?? '')
                  : '',
        },
      );
      if (response != null && response.data != null) {
        return PreApproveHomeResp.fromJson(response.data!);
      }
    } on Exception catch (e) {
      logE(e);
    }
    return PreApproveHomeResp();
  }

  static Future<PreBankListResp> getPreApproveFinance(String filterval) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: 'pl/pre-approved-loan/bank-list-for-loan',
        data: {
          'filterVal': filterval,
          "reqSecureKey":
              ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0)
                  ? (UserProvider.currentUser?.addiParams?[0] ?? '')
                  : '',
        },
      );
      if (response != null && response.data != null) {
        return PreBankListResp.fromJson(response.data!);
      }
    } on Exception catch (e) {
      logE(e);
    }
    return PreBankListResp();
  }

  static Future<List<SelectOptionList>> getListView() async {
    try {
      final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
        path: 'pl/select-box-values',
        data: <String, dynamic>{"reqSecureKey": ""},
      );

      if (res?.statusCode == 200) {
        if (res?.data?['selectOptionList'] != null) {
          return List<SelectOptionList>.from(
            res?.data?['selectOptionList'].map<dynamic>(
              (dynamic e) => SelectOptionList.fromJson(e),
            ),
          );
        } else {
          appSnackbar(
            message: 'No data found',
            snackbarState: SnackbarState.warning,
          );
        }
      }
    } on Exception catch (e) {
      logE(e);
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }

    return <SelectOptionList>[];
  }

  static Future<PrFormResp> getPreApproveForm() async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: 'pl/pre-approved-loan/online-application/view',
        data: {
          "reqSecureKey":
              ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0)
                  ? (UserProvider.currentUser?.addiParams?[0] ?? '')
                  : '',
        },
      );
      if (response != null && response.data != null) {
        return PrFormResp.fromJson(response.data!);
      }
    } on Exception catch (e) {
      logE(e);
    }
    return PrFormResp();
  }

  static Future<LimitFnaSubResp> PrsubmitPersonal(
    String url, {
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: url,
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

  static Future<PrCheckEligiblaResp> PrCheckElig(
    String url, {
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: url,
      data: formData,
    );

    if (res?.statusCode == 200) {
      return PrCheckEligiblaResp.fromJson(res?.data ?? <String, dynamic>{});
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return PrCheckEligiblaResp();
  }

  static Future<BankListResp> PrCheckEmiList(
    String url, {
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: url,
      data: formData,
    );

    if (res?.statusCode == 200) {
      return BankListResp.fromJson(res?.data ?? <String, dynamic>{});
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return BankListResp();
  }

  static Future<LimitFnaSubResp> PrSubmitEmi(
    String url, {
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: url,
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

  static Future<List<Documents>?> getPRUserDocuments(
    Map<String, dynamic> jsonBody,
  ) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'pl/pre-approved-loan/process-view-documents',
      data: jsonBody,
    );

    if (res?.statusCode == 200) {
      if (res?.data?['documents'] != null) {
        return List<Documents>.from(
          res?.data?['documents'].map<dynamic>(
            (dynamic e) => Documents.fromJson(e),
          ),
        );
      } else {
        appSnackbar(
          message: 'No data found',
          snackbarState: SnackbarState.warning,
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

  static Future<LimitFnaSubResp?> savePRFinanceEMI({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'pl/pre-approved-loan/bank-loan-submit',
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

  ///To get docs listLink
  static Future<bool> LinkPRDocument({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'pl/pre-approved-loan/link-doc-with-proc',
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

  static Future<UploadDocumentResp?> uploadPRListDocuments(
    Map<String, Object> jsonBody,
  ) async {
    try {
      dynamic response = await APIService.postAuth(
        path: 'pl/cust-doc-upload',
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

  static Future<PrLoanHistoryResp> getPreApproveLoan(
    String bankid,
    String filterval,
  ) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: 'pl/pre-approved-loan/loan-history-status',
        data: {
          'addiParams': [bankid],
          'filterVal':
              (filterval == '/vehicleloan') ? 'CAR_LOAN' : 'HOUSE_LOAN',
          "reqSecureKey":
              ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0)
                  ? (UserProvider.currentUser?.addiParams?[0] ?? '')
                  : '',
        },
      );
      if (response != null && response.data != null) {
        return PrLoanHistoryResp.fromJson(response.data!);
      }
    } on Exception catch (e) {
      logE(e);
    }
    return PrLoanHistoryResp();
  }

  ///
  static Future<PrCalculatorResp> prCalculator({
    required Map<String, dynamic> data,
  }) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: 'realestate/home/mortgage-eligibility-calculator',
        data: data,
      );
      if (response != null && response.data != null) {
        return PrCalculatorResp.fromJson(response.data!);
      }
    } on Exception catch (e) {
      logE(e);
    }
    return PrCalculatorResp();
  }
}
