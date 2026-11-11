import 'package:dio/dio.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/app_snackbar.dart';
import 'package:citizenone_app/modules/loans_module/app/data/local/store/local_store.dart';
import 'package:citizenone_app/modules/loans_module/app/data/local/store/user_provider.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/CreditCard/CCStatusResp.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/CreditCard/CreditCardAssociationsList.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/CreditCard/CreditCardBanksList.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/CreditCard/CreditCardBenefitOptionsList.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/CreditCard/CreditCardComparisionsList.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/CreditCard/CreditCardReqList.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/CreditCard/CreditCardsList.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/user/documents/Documents.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/user/documents/UploadDocumentResp.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/CreditCard/FinalCCFormSumbitResp.dart';
import '../../model/limit/limit_fna_sub_resp.dart';
import '../../model/loan/PersonalLoan/PLSubmitResp.dart';
import '../api_service/ApiEndPoints.dart';
import '../api_service/init_api_service.dart';

///Credit Card Service
class CreditCardService {
  ///To get docs listLink
  static Future<bool> LinkCGDocument({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'creditcard/link-doc-with-proc',
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

  /// To get card history
  static Future<List<CreditCardReqList?>> getCardsHistory() async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'creditcard/credit-card-req',
      data: <String, dynamic>{
        'reqSecureKey':
            ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0)
                ? (UserProvider.currentUser?.addiParams?[0] ?? '')
                : '',
      },
    );
    if (res?.statusCode == 200) {
      if (res?.data?['creditCardReqList'] != null) {
        return List<CreditCardReqList>.from(
          res?.data!['creditCardReqList'].map<dynamic>(
            (dynamic e) => CreditCardReqList.fromJson(e),
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
    return <CreditCardReqList>[];
  }

  static Future<CcStatusResp?> getCCStatus(String orderId) async {
    // CourseSubsResp resp = CourseSubsResp.fromJson(res?.data ?? <String, dynamic>{});;
    try {
      dynamic response = await APIService.postAuth(
        path: 'creditcard/credit-card-status',
        data: {
          'filterVal': orderId,
          'reqSecureKey': UserProvider.currentUser?.addiParams![0],
        },
      );
      final jsonData = CcStatusResp.fromJson(response.data);
      return jsonData;
    } catch (e) {
      print("Error " + e.toString());
      rethrow;
    }
  }

  static Future<LimitFnaSubResp?> getApplyCC(
    String cardname,
    String bkName,
    String bkID,
    String bkurl,
    String rmark,
    String action,
  ) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'creditcard/update-credit-card-req-progress',
      data: <String, dynamic>{
        "custId":
            ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0)
                ? (UserProvider.currentUser?.addiParams?[0] ?? '')
                : '',
        "action": action,
        "remarks": rmark,
        "cardName": cardname,
        "bankName": bkName,
        "bankId": bkID,
        "bankImgUrl": bkurl,
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

  static Future<List<CreditCardBenefitOptionsList?>> getBenefitList() async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'creditcard/home/credit-card-benefit-options',
      data: <String, dynamic>{
        "reqSecureKey":
            ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0)
                ? (UserProvider.currentUser?.addiParams?[0] ?? '')
                : '',
        "filterVal": "",
        "addiParams": [""],
      },
    );
    if (res?.statusCode == 200) {
      if (res?.data?['creditCardBenefitOptionsList'] != null) {
        return List<CreditCardBenefitOptionsList>.from(
          res?.data!['creditCardBenefitOptionsList'].map<dynamic>(
            (dynamic e) => CreditCardBenefitOptionsList.fromJson(e),
          ),
        );
      }
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return <CreditCardBenefitOptionsList>[];
  }

  /// To get home card list
  static Future<List<CreditCardsList?>> getHomeCardList(
    bool cashBack,
    bool saveMoney,
    bool earnPoint,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? associators = prefs.getStringList('associations');
    final List<String>? providers = prefs.getStringList('providers');

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'creditcard/home/filtered-credit-cards-list',
      data: <String, dynamic>{
        "reqSecureKey":
            ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0)
                ? (UserProvider.currentUser?.addiParams?[0] ?? '')
                : '',
        "filterVal": "CREDIT_CARDS",
        "hKey": 0,
        "filterHashKey": 0,
        "cashBack": cashBack,
        "saveMoney": saveMoney,
        "earnPoint": earnPoint,
        "cardVarient": associators,
        "minimumIncome": LocalStore.salary(),
        "bankId": providers,
        "categoryId": "",
        "paging": {
          "pageNum": 1,
          "paginationRecords": 0,
          "recsPerPage": 10,
          "sortByType": "ASC",
          "totalPages": 0,
          "totalRecs": 0,
        },
      },
    );
    if (res?.statusCode == 200) {
      if (res?.data?['creditCardsList'] != null) {
        return List<CreditCardsList>.from(
          res?.data!['creditCardsList'].map<dynamic>(
            (dynamic e) => CreditCardsList.fromJson(e),
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
    return <CreditCardsList>[];
  }

  /// To get PL home screen banners
  static Future<List<CreditCardComparisionsList>?> getCompareDate(
    String bank1,
    String bank2,
  ) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'creditcard/credit-card-compare-list',
      data: <String, dynamic>{
        'addiParams': [bank1, bank2],
        "filterVal": "",
        "reqSecureKey": '',
      },
    );
    if (res?.statusCode == 200) {
      if (res?.data?['creditCardComparisionsList'] != null) {
        return List<CreditCardComparisionsList>.from(
          res?.data!['creditCardComparisionsList'].map<dynamic>(
            (dynamic e) => CreditCardComparisionsList.fromJson(e),
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
    return <CreditCardComparisionsList>[];
  }

  /// To get association list
  static Future<List<CreditCardAssociationsList?>> getAssociationList() async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'creditcard/home/credit-card-association-list',
      data: <String, dynamic>{
        "reqSecureKey":
            ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0)
                ? (UserProvider.currentUser?.addiParams?[0] ?? '')
                : '',
        "filterVal": "",
        "addiParams": [""],
      },
    );
    if (res?.statusCode == 200) {
      if (res?.data?['creditCardAssociationsList'] != null) {
        return List<CreditCardAssociationsList>.from(
          res?.data!['creditCardAssociationsList'].map<dynamic>(
            (dynamic e) => CreditCardAssociationsList.fromJson(e),
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
    return <CreditCardAssociationsList>[];
  }

  /// To get provider list
  static Future<List<CreditCardBanksList?>> getProviderList() async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'creditcard/home/credit-card-banks-list',
      data: <String, dynamic>{
        "reqSecureKey":
            ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0)
                ? (UserProvider.currentUser?.addiParams?[0] ?? '')
                : '',
        "filterVal": "",
        "addiParams": [""],
      },
    );
    if (res?.statusCode == 200) {
      if (res?.data?['creditCardBanksList'] != null) {
        return List<CreditCardBanksList>.from(
          res?.data!['creditCardBanksList'].map<dynamic>(
            (dynamic e) => CreditCardBanksList.fromJson(e),
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
    return <CreditCardBanksList>[];
  }

  ///To get docs list
  static Future<List<Documents>?> getUserDocuments(
    Map<String, dynamic> jsonBody,
  ) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.processViewDocuments,
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

  ///Upload doc
  static Future<UploadDocumentResp?> uploadListDocuments(
    Map<String, Object> jsonBody,
  ) async {
    try {
      dynamic response = await APIService.postAuth(
        path: 'creditcard/cust-doc-upload',
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

  static Future<PlSubmitResp?> acceptForms() async {
    try {
      dynamic response = await APIService.postAuth(
        path: 'creditcard/credit-card-application',
        data: <String, dynamic>{
          "reqSecureKey":
              ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0)
                  ? (UserProvider.currentUser?.addiParams?[0] ?? '')
                  : '',
          "filterVal": "CREDIT_CARD",
          "productCode": LocalStore.productCode(),
          "productName": LocalStore.productName(),
          "cardType": LocalStore.creditCardType(),
          "bankId": LocalStore.bankId(),
        },
      );
      final jsonData = PlSubmitResp.fromJson(
        response?.data ?? <String, dynamic>{},
      );
      return jsonData;
    } catch (e) {
      print("Error " + e.toString());
      rethrow;
    }
  }

  static Future<FinalCcFormSumbitResp?> finalLoanSumbit() async {
    try {
      dynamic response = await APIService.postAuth(
        path: 'creditcard/credit-card-status',
        data: <String, dynamic>{
          'filterVal': LocalStore.productCode(),
          'reqSecureKey':
              ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0)
                  ? (UserProvider.currentUser?.addiParams?[0] ?? '')
                  : '',
        },
      );
      final jsonData = FinalCcFormSumbitResp.fromJson(
        response?.data ?? <String, dynamic>{},
      );
      return jsonData;
    } catch (e) {
      print("Error " + e.toString());
      rethrow;
    }
  }
}
