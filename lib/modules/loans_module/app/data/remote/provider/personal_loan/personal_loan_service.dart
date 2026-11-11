import 'package:dio/dio.dart';
import 'package:dio/src/response.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' as getX;
import 'package:citizenone_app/modules/loans_module/app/data/remote/api_service/ApiEndPoints.dart';
import 'package:citizenone_app/modules/loans_module/app/data/remote/provider/personal_loan/personal_loan_features_list.dart';
import 'package:citizenone_app/modules/loans_module/app/data/remote/provider/personal_loan/pl_bank_detils.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/ag_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../components/utils/app_snackbar.dart';
import '../../../../modules/loan_details/controllers/loan_details_controller.dart';
import '../../../../modules/pl_home_screen/controllers/pl_home_screen_controller.dart';
import '../../../config/logger.dart';
import '../../../local/store/local_store.dart';
import '../../../local/store/user_provider.dart';
import '../../../model/common/banners.dart';
import '../../../model/common/ch_message.dart';
import '../../../model/limit/limit_fna_sub_resp.dart';
import '../../../model/loan/PersonalLoan/Banks.dart';
import '../../../model/loan/PersonalLoan/Features.dart';
import '../../../model/loan/PersonalLoan/FinalLoanSubmitResp.dart';
import '../../../model/loan/PersonalLoan/FormData/LoanDetails.dart';
import '../../../model/loan/PersonalLoan/PLCompareProductResp.dart';
import '../../../model/loan/PersonalLoan/PLSubmitResp.dart';
import '../../../model/loan/PersonalLoan/PersonalLoanList.dart';
import '../../../model/loan/PersonalLoan/pl_chat/ComResp.dart';
import '../../../model/loan/PersonalLoan/pl_chat/Pl_chat_model.dart';
import '../../../model/loan/PersonalLoan/pl_emi_calculator/EmiCalculator.dart';
import '../../../model/select_box_model/SelectOptionList.dart';
import '../../../model/user/documents/Documents.dart';
import '../../../model/user/documents/UploadDocumentResp.dart';
import '../../api_service/init_api_service.dart';
import 'fields.dart';

class PersonalLoanService {
  /// To get PL loan details
  static Future<LoanDetails?> getLoanDetails() async {
    final String mobNumber = await UserProvider.getMobileNumber();
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.getPlFinanceFields,
      data: <String, dynamic>{
        "reqSecureKey":
            ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                ? (UserProvider.currentUser?.addiParams[0] ?? '')
                : '',
        "filterVal": mobNumber,
        "addiParams": ["LOAN_DETAILS", mobNumber],
        "hKey": 0,
      },
    );
    if (res?.statusCode == 200) {
      if (res?.data!['loanDetails'] != null) {
        return LoanDetails.fromJson(
          res?.data!['loanDetails'] ?? <String, dynamic>{},
        );
      }
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return LoanDetails();
  }

  /// To save PL loan details
  static Future<ChMessage> submitLoanDetails({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.plFinanceOnlineApplication,
      data: formData,
    );

    if (res?.statusCode == 200) {
      return ChMessage.fromJson(res?.data!['chMessage'] ?? <String, dynamic>{});
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return ChMessage();
  }

  /// To save PL loan details
  static Future<ChMessage> AcceptPeroanlDetails({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.plAcceptedRejectedByUser,
      data: formData,
    );

    if (res?.statusCode == 200) {
      return ChMessage.fromJson(res?.data!['chMessage'] ?? <String, dynamic>{});
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return ChMessage();
  }

  /// To get PL personal details
  static Future<List<Fields?>> getPersonalDetails() async {
    final String mobNumber = await UserProvider.getMobileNumber();
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.getPlFinanceFields,
      data: <String, dynamic>{
        "reqSecureKey":
            ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                ? (UserProvider.currentUser?.addiParams[0] ?? '')
                : '',
        "filterVal": mobNumber,
        "addiParams": ["PERSONAL_DETAILS", AgConstants.moduleName, mobNumber],
      },
    );
    if (res?.statusCode == 200) {
      if (res?.data?['fields'] != null) {
        return List<Fields>.from(
          res?.data!['fields'].map<dynamic>((dynamic e) => Fields.fromJson(e)),
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
    return <Fields>[];
  }

  /// To get PL address and contact details
  static Future<List<Fields?>> getAddressDetails() async {
    final String mobNumber = await UserProvider.getMobileNumber();
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.getPlFinanceFields,
      data: <String, dynamic>{
        "reqSecureKey": mobNumber,
        "filterVal": "PERSONAL_LOAN",
        "addiParams": ["CONTACT_INFO", AgConstants.moduleName, mobNumber],
      },
    );
    if (res?.statusCode == 200) {
      if (res?.data?['fields'] != null) {
        return List<Fields>.from(
          res?.data!['fields'].map<dynamic>((dynamic e) => Fields.fromJson(e)),
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
    return <Fields>[];
  }

  /// To get PL employement details
  static Future<List<Fields?>> getEmployementDetails() async {
    final String mobNumber = await UserProvider.getMobileNumber();
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.getPlFinanceFields,
      data: <String, dynamic>{
        "reqSecureKey": mobNumber,
        "filterVal": "PERSONAL_LOAN",
        "addiParams": ["EMP_DATA", AgConstants.moduleName, mobNumber],
      },
    );
    if (res?.statusCode == 200) {
      if (res?.data?['fields'] != null) {
        return List<Fields>.from(
          res?.data!['fields'].map<dynamic>((dynamic e) => Fields.fromJson(e)),
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
    return <Fields>[];
  }

  /// To get PL income details
  static Future<List<Fields?>> getIncomeDetails() async {
    final String mobNumber = await UserProvider.getMobileNumber();
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.getPlFinanceFields,
      data: <String, dynamic>{
        "reqSecureKey": mobNumber,
        "filterVal": "PERSONAL_LOAN",
        "addiParams": ["APPLICATION_INFO", AgConstants.moduleName, mobNumber],
      },
    );
    if (res?.statusCode == 200) {
      if (res?.data?['fields'] != null) {
        return List<Fields>.from(
          res?.data!['fields'].map<dynamic>((dynamic e) => Fields.fromJson(e)),
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
    return <Fields>[];
  }

  /// To get PL home screen banners
  static Future<List<Banners?>> getHomeBanners() async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.homePageBanners,
      data: <String, dynamic>{
        "filterVal": "PERSONAL_LOAN_L1",
        "addiParams": ["MOBILE"],
      },
    );
    if (res?.statusCode == 200) {
      if (res?.data?['banners'] != null) {
        return List<Banners>.from(
          res?.data!['banners'].map<dynamic>(
            (dynamic e) => Banners.fromJson(e),
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
    return <Banners>[];
  }

  /// To get PL home screen banks
  static Future<List<PlBankDetils?>> getHomeBankList() async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.personalLoans,
      data: <String, dynamic>{
        'loanAmount': LocalStore.loanAmount(),
        'monthlySalary': LocalStore.monthlySalary(),
        'category': LocalStore.category(),
      },
    );
    if (res?.statusCode == 200) {
      if (res?.data?['plBankDetils'] != null) {
        return List<PlBankDetils>.from(
          res?.data!['plBankDetils'].map<dynamic>(
            (dynamic e) => PlBankDetils.fromJson(e),
          ),
        );
      }
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return <PlBankDetils>[];
  }

  /// To get PL home screen banks features
  static Future<List<PersonalLoanFeaturesList?>> getFeatures(
    String productCode,
  ) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.personalLoanFeatures,
      data: <String, dynamic>{
        'productCode': productCode,
        'loanCategory': LocalStore.category(),
      },
    );
    if (res?.statusCode == 200) {
      if (res?.data?['personalLoanFeaturesList'] != null) {
        if (res?.data!['personalLoanFeaturesList'] != null) {
          return List<PersonalLoanFeaturesList>.from(
            res?.data!['personalLoanFeaturesList'].map<dynamic>(
              (dynamic e) => PersonalLoanFeaturesList.fromJson(e),
            ),
          );
        }
        return <PersonalLoanFeaturesList>[];
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
    return <PersonalLoanFeaturesList>[];
  }

  /// To get PL home screen banners
  static Future<PlCompareProductResp> getCompareDate(
    String bank1,
    String bank2,
  ) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.plCompareProducts,
      data: <String, dynamic>{
        'addiParams': [bank1, bank2],
        'category': LocalStore.category(),
      },
    );
    if (res?.statusCode == 200) {
      return PlCompareProductResp.fromJson(res?.data);
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return PlCompareProductResp();
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

  static Future<UploadDocumentResp?> uploadListDocuments(
    Map<String, Object> jsonBody,
  ) async {
    try {
      dynamic response = await APIService.postAuth(
        path: ApiEndPoints.custDocUpload,
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

  static Future<PlSubmitResp?> plFinalSubmitData() async {
    try {
      dynamic response = await APIService.postAuth(
        path: ApiEndPoints.plReviewSubmit,
        data: <String, dynamic>{
          'addiParams': [
            "LOAN_DETAILS",
            "PERSONAL_DETAILS",
            "CONTACT_INFO",
            "EMP_DATA",
            "APPLICATION_INFO",
          ],
          'filterVal': 'PERSONAL_LOAN',
          'reqSecureKey':
              ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                  ? (UserProvider.currentUser?.addiParams[0] ?? '')
                  : '',
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

  ///Apply loan check
  static Future<PlSubmitResp?> plApplyLoanCheck() async {
    try {
      dynamic response = await APIService.postAuth(
        path: ApiEndPoints.checkApplyLoan,
        data: <String, dynamic>{
          'filterVal':
              getX.Get.find<PlHomeScreenController>().selectedBank.value.bankId,
          'reqSecureKey':
              ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                  ? (UserProvider.currentUser?.addiParams[0] ?? '')
                  : '',
        },
      );
      final jsonData = PlSubmitResp.fromJson(
        response?.data ?? <String, dynamic>{},
      );

      return jsonData;
    } catch (e) {
      debugPrint('plApplyLoanCheck Error: $e');

      appSnackbar(
        message: 'Something went wrong. Please try again later.',
        snackbarState: SnackbarState.warning,
      );
      rethrow;
    }
  }

  ///Apply loan check
  static Future<FinalLoanSubmitResp?> finalLoanSumbit(
    String tenure,
    String remark,
  ) async {
    try {
      tenure = getX.Get.find<LoanDetailsController>().tenureController.text;
      dynamic response = await APIService.postAuth(
        path: ApiEndPoints.submitPlBank,
        data: <String, dynamic>{
          'filterVal':
              getX.Get.find<PlHomeScreenController>().selectedBank.value.bankId,
          'filterHashKey':
              AgConstants.agentMobileNumber == ""
                  ? '984244138'
                  : AgConstants.agentMobileNumber,
          'reqSecureKey':
              ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                  ? (UserProvider.currentUser?.addiParams[0] ?? '')
                  : '',
          'addiParams':
              LocalStore.loanRefId()?.isNotEmpty == true
                  ? [
                    LocalStore.loanAmount(),
                    tenure,
                    LocalStore.loanRefId(),
                    remark,
                  ]
                  : [LocalStore.loanAmount(), tenure],
        },
      );
      final jsonData = FinalLoanSubmitResp.fromJson(
        response?.data ?? <String, dynamic>{},
      );
      return jsonData;
    } catch (e) {
      print("Error " + e.toString());
      rethrow;
    }
  }

  /// To get PL home screen filter banks
  static Future<List<Banks?>> getFilterBankList() async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.plFilterList,
      data: <String, dynamic>{
        'loanAmount': LocalStore.loanAmount(),
        'monthlySalary': LocalStore.monthlySalary(),
        'category': LocalStore.category(),
      },
    );
    if (res?.statusCode == 200) {
      if (res?.data?['banks'] != null) {
        return List<Banks>.from(
          res?.data!['banks'].map<dynamic>((dynamic e) => Banks.fromJson(e)),
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
    return <Banks>[];
  }

  /// To get PL home screen banks
  static Future<List<Features?>> getFilterFeaturesList() async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.plFilterList,
      data: <String, dynamic>{
        'loanAmount': LocalStore.loanAmount(),
        'monthlySalary': LocalStore.monthlySalary(),
        'category': LocalStore.category(),
      },
    );
    if (res?.statusCode == 200) {
      if (res?.data?['features'] != null) {
        return List<Features>.from(
          res?.data!['features'].map<dynamic>(
            (dynamic e) => Features.fromJson(e),
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
    return <Features>[];
  }

  /// To get PL home screen banks
  static Future<List<PlBankDetils?>> getHomeFilteredBankList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? items = prefs.getStringList('bankIds');
    final List<String>? features = prefs.getStringList('features');
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.plFilterSubmit,
      data: <String, dynamic>{
        'bankIds': items,
        'category': LocalStore.category(),
        'features': features,
      },
    );
    if (res?.statusCode == 200) {
      if (res?.data?['plBankDetils'] != null) {
        return List<PlBankDetils>.from(
          res?.data!['plBankDetils'].map<dynamic>(
            (dynamic e) => PlBankDetils.fromJson(e),
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
    return <PlBankDetils>[];
  }

  ///To get docs listLink
  static Future<bool> LinkCGDocument({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.linkDocWithProc,
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

  static Future<LimitFnaSubResp?> getApplyPL(
    String action,
    String remarks,
    int? amt,
  ) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.updatePlReqProgress,
      data: <String, dynamic>{
        "custId":
            ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                ? (UserProvider.currentUser?.addiParams[0] ?? '')
                : '',
        "action": action,
        "remarks": remarks,
        "bankName": '',
        "loanAmount": amt,
        "refNo": '',
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

  /// To get list of my sessions
  static Future<List<SelectOptionList>> getListView() async {
    try {
      final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
        path: ApiEndPoints.selectBoxValues,
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

  /// To get pl history for logged in customer
  static Future<List<PersonalLoanList?>> getPLHistory() async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.personalLoanList,
      data: <String, dynamic>{
        'reqSecureKey':
            ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                ? (UserProvider.currentUser?.addiParams[0] ?? '')
                : '',
      },
    );
    if (res?.statusCode == 200) {
      if (res?.data?['personalLoanList'] != null) {
        return List<PersonalLoanList>.from(
          res?.data!['personalLoanList'].map<dynamic>(
            (dynamic e) => PersonalLoanList.fromJson(e),
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
    return <PersonalLoanList>[];
  }

  /// To get pl history by customer phone number
  static Future<List<PersonalLoanList?>> getCustomerPLHistory(
    String customerPhoneNumber,
  ) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.customerPlList,
      data: <String, dynamic>{'reqSecureKey': customerPhoneNumber},
    );
    if (res?.statusCode == 200) {
      if (res?.data?['personalLoanList'] != null) {
        return List<PersonalLoanList>.from(
          res?.data!['personalLoanList'].map<dynamic>(
            (dynamic e) => PersonalLoanList.fromJson(e),
          ),
        );
      }
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return <PersonalLoanList>[];
  }

  /// To get pl history by agent phone number
  static Future<List<PersonalLoanList?>> getAgentPLHistory(
    String agentPhoneNumber,
  ) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.agentPlList,
      data: <String, dynamic>{'filterHashKey': agentPhoneNumber},
    );
    if (res?.statusCode == 200) {
      if (res?.data?['personalLoanList'] != null) {
        return List<PersonalLoanList>.from(
          res?.data!['personalLoanList'].map<dynamic>(
            (dynamic e) => PersonalLoanList.fromJson(e),
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
    return <PersonalLoanList>[];
  }

  /// To get pl chat history
  static Future<PlChatModel?> getPLChatHistory({
    required Map<String, dynamic> formData,
  }) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.getChatMsg,
      data: formData,
    );

    if (res?.statusCode == 200) {
      return PlChatModel.fromJson(res?.data ?? <String, dynamic>{});
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return PlChatModel();
  }

  /// Send pl chat
  static Future<ComResp?> sendChat({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.startSaveChat,
      data: formData,
    );

    if (res?.statusCode == 200) {
      ComResp response = ComResp.fromJson(res?.data ?? <String, dynamic>{});
      if (response.chMessage?.isError == false) {
        return ComResp.fromJson(res?.data ?? <String, dynamic>{});
      } else {
        return ComResp();
      }
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return ComResp();
  }

  /// Calculate emi
  static Future<EmiCalculator?> calculateEMi({
    required Map<String, dynamic> formData,
  }) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.personalLoanEmiCalculator,
      data: formData,
    );

    if (res?.statusCode == 200) {
      ComResp response = ComResp.fromJson(res?.data ?? <String, dynamic>{});
      if (response.chMessage?.isError == false) {
        return EmiCalculator.fromJson(res?.data ?? <String, dynamic>{});
      } else {
        return EmiCalculator();
      }
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return EmiCalculator();
  }

  static Future<LimitFnaSubResp?> finalSanctionAceptReject(
    String status,
    String remark,
    String leadRefId,
  ) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.saveAcceptanceStatus,
      data: <String, dynamic>{
        'status': status,
        'leadRefId': leadRefId,
        'remark': remark,
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
}
