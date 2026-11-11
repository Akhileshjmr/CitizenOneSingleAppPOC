import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/app_snackbar.dart';
import 'package:citizenone_app/modules/loans_module/app/data/local/store/user_provider.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/limit/CustomerLimitDataResp.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/limit/limit_fna_sub_resp.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/user/documents/Documents.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/user/documents/UploadDocumentResp.dart';
import 'package:citizenone_app/modules/loans_module/app/modules/profile/ProfileStatusResp.dart';
import 'package:citizenone_app/modules/loans_module/app/modules/profile/UserProfViewResp.dart';
import 'package:citizenone_app/modules/loans_module/app/modules/profile/UserProfileView/UserFormsResp.dart';

import '../../../utils/static_value_constant.dart';
import '../api_service/ApiEndPoints.dart';
import '../api_service/init_api_service.dart';

class ProfileService {
  static Future<ProfileStatusResp?> getProfileStatus() async {
    // CourseSubsResp resp = CourseSubsResp.fromJson(res?.data ?? <String, dynamic>{});;
    try {
      dynamic response = await APIService.postAuth(
        path: 'customer/profile/get-prof-status',
        data: {"filterVal": UserProvider.currentUser?.addiParams![0]},
      );
      final jsonData = ProfileStatusResp.fromJson(response.data);
      debugPrint("Stat:" + jsonData.toString());
      return jsonData;
    } catch (e) {
      print("Error " + e.toString());
      rethrow;
    }
  }

  static Future<UserProfViewResp?> getProfileView(String docId) async {
    // CourseSubsResp resp = CourseSubsResp.fromJson(res?.data ?? <String, dynamic>{});;
    try {
      dynamic response = await APIService.postAuth(
        path: 'customer/profile/get-prof-view',
        data: {
          "filterVal":
              ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0)
                  ? (UserProvider.currentUser?.addiParams?[0] ?? '')
                  : '',
          'addiParams': [docId],
        },
      );
      final jsonData = UserProfViewResp.fromJson(
        response?.data ?? <String, dynamic>{},
      );
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  // static Future<RewardResp?> getRewardPoint(String pnumber) async {
  //   // CourseSubsResp resp = CourseSubsResp.fromJson(res?.data ?? <String, dynamic>{});;
  //   try {
  //     dynamic response = await APIService.getAuth(
  //         path: 'customer/reg/get-reward-balance/' + (UserProvider.currentUser!.value ?? ''),
  //        );
  //     final jsonData = RewardResp.fromJson(response?.data ?? <String, dynamic>{});
  //     return jsonData;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // static Future<RewardPointResp?> getRewardPointList(String pnumber,String pgno) async {
  //   // CourseSubsResp resp = CourseSubsResp.fromJson(res?.data ?? <String, dynamic>{});;
  //   try {
  //     dynamic response = await APIService.getAuth(
  //       path: 'api/rewards/get-cust-txn/' + (UserProvider.currentUser!.value ?? '') + '/' + pgno
  //     );
  //     final jsonData = RewardPointResp.fromJson(response?.data ?? <String, dynamic>{});
  //     return jsonData;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  static Future<UserFormsResp?> getProfileForms(String docId) async {
    // CourseSubsResp resp = CourseSubsResp.fromJson(res?.data ?? <String, dynamic>{});;
    try {
      dynamic response = await APIService.postAuth(
        path: ApiEndPoints.getProfileForms,
        data: {
          "reqSecureKey": StaticValueConstant.UserFilterVal,
          "addiParams": ["PERSONAL_DETAILS"],
          "filterVal": "PROFILE",
        },
      );
      final jsonData = UserFormsResp.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  // static Future<CredezeCustLoginResp?> uploadUserImage(Map<String, Object> jsonBody) async {
  //   try {
  //     final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
  //         path: 'customer/profile/update-prof-pic',
  //         data: jsonBody);
  //     final CredezeCustLoginResp jsonData = CredezeCustLoginResp.fromJson(res?.data ?? <String, dynamic>{});
  //     // print("Got Response");
  //     return jsonData;
  //   } catch (e) {
  //     print("Error "+e.toString());
  //     rethrow;
  //   }
  // }

  static Future<List<Documents>?> getUserDocuments(
    String url,
    Map<String, Object> jsonBody,
  ) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: url,
      data: jsonBody,
    );

    if (res?.statusCode == 200) {
      if (res?.data!['documents'] != null) {
        return res?.data!['documents'] == null
            ? null
            : List<Documents>.from(
              res?.data!['documents'].map<dynamic>(
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

  static Future<List<Documents>?> getLimitDocuments(String url) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: url,
      data: {
        "reqSecureKey":
            ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0)
                ? (UserProvider.currentUser?.addiParams?[0] ?? '')
                : '',
        "addiParams": ["FNA"],
      },
    );
    if (res?.statusCode == 200) {
      if (res?.data!['documents'] != null) {
        return res?.data!['documents'] == null
            ? null
            : List<Documents>.from(
              res?.data!['documents'].map<dynamic>(
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

  static Future<List<Documents>?> getCGUserDocuments(
    String url, {
    required Map<String, dynamic> formData,
  }) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: url,
      data: formData,
    );

    if (res?.statusCode == 200) {
      if (res?.data!['documents'] != null) {
        return res?.data!['documents'] == null
            ? null
            : List<Documents>.from(
              res?.data!['documents'].map<dynamic>(
                (dynamic e) => Documents.fromJson(e),
              ),
            );
      } else {
        appSnackbar(
          message: 'No document found',
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

  static Future<UploadDocumentResp?> uploadDocuments() async {
    try {
      dynamic response = await APIService.postAuth(
        path: 'customer/profile/cust-doc-upload-limit',
      );
      final jsonData = UploadDocumentResp.fromJson(response);
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
        path: 'customer/profile/cust-doc-upload',
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

  static Future<UploadDocumentResp?> uploadLimitListDocuments(
    Map<String, Object> jsonBody,
  ) async {
    try {
      dynamic response = await APIService.postAuth(
        path: 'customer/profile/cust-doc-upload-limit',
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

  static Future<UploadDocumentResp?> uploadREDocuments(
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

  static Future<LimitFnaSubResp> documentSubmit({
    required Map<String, dynamic> formData,
  }) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'customer/profile/submit-fna-limit',
      data: formData,
    );

    if (res?.statusCode == 200) {
      final LimitFnaSubResp apiRes = LimitFnaSubResp.fromJson(
        res?.data ?? <String, dynamic>{},
      );

      if (!(apiRes.chMessage?.isError ?? false)) {
        return LimitFnaSubResp.fromJson(res?.data ?? <String, dynamic>{});
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
    return LimitFnaSubResp();
  }

  // static Future<CredezeCustLoginResp?> uploadUserImageLimit(Map<String, Object> jsonBody) async {
  //   try {
  //     dynamic response = await APIService.postAuth(
  //         path: 'customer/profile/cust-doc-upload-limit',
  //         data: jsonBody);
  //     final jsonData = CredezeCustLoginResp.fromJson(response);
  //     // print("Got Response");
  //     return jsonData;
  //   } catch (e) {
  //     print("Error "+e.toString());
  //     rethrow;
  //   }
  // }

  ///To get docs listLink
  static Future<bool> LinkCGDocument({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'customer/profile/link-doc-with-proc',
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

  static Future<CustomerLimitDataResp?> getCGUserData(
    String url, {
    required Map<String, dynamic> formData,
  }) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: url,
      data: formData,
    );

    if (res?.statusCode == 200) {
      final CustomerLimitDataResp apiRes = CustomerLimitDataResp.fromJson(
        res?.data ?? <String, dynamic>{},
      );

      if (!(apiRes.chMessage?.isError ?? false)) {
        final jsonData = CustomerLimitDataResp.fromJson(res?.data);
        // print("Got Response");
        return jsonData;
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
    return CustomerLimitDataResp();
  }

  // /// To get tickets list
  // static Future<List<ServiceTickets?>> getTicketsList(String txt, int pageNum) async {
  //   final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
  //     path: 'customer/profile/cust-service-req-list',
  //     data: <String, dynamic>{
  //       'reqSecureKey': ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0) ? (UserProvider.currentUser?.addiParams?[0] ?? '') : '',
  //       'filterVal':txt,
  //       'paging': {
  //         'pageNum': pageNum,
  //         'paginationRecords': 0,
  //         'recsPerPage': 10,
  //         'sortByType': 'ASC',
  //         'totalPages': 0,
  //         'totalRecs': 0
  //       }
  //     },
  //   );
  //   if (res?.statusCode == 200) {
  //     final TicketsList apiRes =
  //     TicketsList.fromJson(res?.data ?? <String, dynamic>{});

  //     if (apiRes.chMessage?.type == 'SUCCESS') {
  //       return List<ServiceTickets>.from(
  //         res?.data!['serviceTickets'].map<dynamic>(
  //               (dynamic e) => ServiceTickets.fromJson(e),
  //         ),
  //       );
  //     } else {
  //       appSnackbar(
  //         message: apiRes.chMessage?.message ?? '',
  //         snackbarState: SnackbarState.warning,
  //       );
  //     }
  //   } else {
  //     appSnackbar(
  //       message: 'Something went wrong',
  //       snackbarState: SnackbarState.warning,
  //     );
  //   }
  //   return <ServiceTickets>[];
  // }

  // /// To get tickets items list
  // static Future<List<ticketProductItems?>> getItemsList(String txt) async {
  //   final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
  //     path: 'customer/reg/ser-req-orders',
  //     data: <String, dynamic>{
  //       'reqSecureKey': ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0) ? (UserProvider.currentUser?.addiParams?[0] ?? '') : '',
  //       'filterVal':txt,
  //       'paging': {
  //         'pageNum': 0,
  //         'recsPerPage': 10,
  //       }
  //     },
  //   );
  //   if (res?.statusCode == 200) {
  //     final ItemsResp apiRes =
  //     ItemsResp.fromJson(res?.data ?? <String, dynamic>{});

  //     if (apiRes.chMessage?.type == 'SUCCESS') {
  //       return List<ticketProductItems>.from(
  //         res?.data!['items'].map<dynamic>(
  //               (dynamic e) => ticketProductItems.fromJson(e),
  //         ),
  //       );
  //     } else {
  //       appSnackbar(
  //         message: apiRes.chMessage?.message ?? '',
  //         snackbarState: SnackbarState.warning,
  //       );
  //     }
  //   } else {
  //     appSnackbar(
  //       message: 'Something went wrong',
  //       snackbarState: SnackbarState.warning,
  //     );
  //   }
  //   return <ticketProductItems>[];
  // }

  // /// To get faqs list
  // static Future<List<Faqs?>> getFaqsList(String category, String searchText) async {
  //   final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
  //     path: 'customer/profile/digi-customer-faqs',
  //     data: <String, dynamic>{
  //       'filterVal': 'CUSTOMER',
  //       'category': category,
  //       'searchText': searchText,
  //       'paging': {
  //         'pageNum': 1,
  //         'paginationRecords': 0,
  //         'recsPerPage': 10,
  //         'sortByType': 'ASC',
  //         'totalPages': 0,
  //         'totalRecs': 0
  //       }
  //     },
  //   );
  //   if (res?.statusCode == 200) {
  //     final TicketsList apiRes =
  //     TicketsList.fromJson(res?.data ?? <String, dynamic>{});

  //     if (apiRes.chMessage?.type == 'SUCCESS') {
  //       return List<Faqs>.from(
  //         res?.data!['options'].map<dynamic>(
  //               (dynamic e) => Faqs.fromJson(e),
  //         ),
  //       );
  //     } else {
  //       appSnackbar(
  //         message: apiRes.chMessage?.message ?? '',
  //         snackbarState: SnackbarState.warning,
  //       );
  //     }
  //   } else {
  //     appSnackbar(
  //       message: 'Something went wrong',
  //       snackbarState: SnackbarState.warning,
  //     );
  //   }
  //   return <Faqs>[];
  // }

  // /// To get faqs list
  // static Future<List<CatList?>> getFaqsTitles() async {
  //   final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
  //     path: 'customer/profile/faq-topic-categories',
  //     data: <String, dynamic>{
  //       'filterVal': 'faq-category',
  //     },
  //   );
  //   if (res?.statusCode == 200) {
  //     final FaqTitles apiRes =
  //     FaqTitles.fromJson(res?.data ?? <String, dynamic>{});
  //     if (apiRes.chMessage?.type == 'SUCCESS') {
  //       return List<CatList>.from(
  //         res?.data!['catList'].map<dynamic>(
  //               (dynamic e) => CatList.fromJson(e),
  //         ),
  //       );
  //     } else {
  //       appSnackbar(
  //         message: apiRes.chMessage?.message ?? '',
  //         snackbarState: SnackbarState.warning,
  //       );
  //     }
  //   } else {
  //     appSnackbar(
  //       message: 'Something went wrong',
  //       snackbarState: SnackbarState.warning,
  //     );
  //   }
  //   return <CatList>[];
  // }

  // /// To create ticket
  // static Future<ChMessage> createTicket({
  //   required Map<String, dynamic> formData,
  // }) async {
  //   bool success = false;

  //   final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
  //       path: 'customer/profile/cust-service-req',
  //       data: formData
  //   );
  //   if (res?.statusCode == 200) {
  //     final CreatedTicketResp apiRes =
  //     CreatedTicketResp.fromJson(res?.data ?? <String, dynamic>{});
  //     if (apiRes.chMessage?.type == 'SUCCESS') {
  //       return ChMessage.fromJson(res?.data!['chMessage'] ?? <String, dynamic>{});
  //     } else {
  //       appSnackbar(
  //         message: apiRes.chMessage?.message ?? '',
  //         snackbarState: SnackbarState.warning,
  //       );
  //     }
  //   } else {
  //     appSnackbar(
  //       message: 'Something went wrong',
  //       snackbarState: SnackbarState.warning,
  //     );
  //   }
  //   return ChMessage();
  // }

  // static Future<TicketDetails?> getTicketDetails({
  //   required Map<String, dynamic> formData,
  // }) async {

  //   final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
  //       path: 'customer/profile/cust-service-req-view', data: formData);

  //   if (res?.statusCode == 200) {
  //     final TicketDetails apiRes =
  //     TicketDetails.fromJson(res?.data ?? <String, dynamic>{});

  //     if (apiRes.chMessage?.type == 'SUCCESS') {
  //       return TicketDetails.fromJson(res?.data ?? <String, dynamic>{});
  //     } else {
  //       appSnackbar(
  //         message: apiRes.chMessage?.message ?? '',
  //         snackbarState: SnackbarState.warning,
  //       );
  //     }
  //   } else {
  //     appSnackbar(
  //       message: 'Something went wrong',
  //       snackbarState: SnackbarState.warning,
  //     );
  //   }
  //   return TicketDetails();
  // }

  // /// To get tickets reply
  // static Future<List<TicketReply?>> getTicketsReply(String filterVal, String msg) async {
  //   final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
  //     path: 'customer/profile/cust-tickets-reply',
  //     data: <String, dynamic>{
  //         "msg": msg,
  //         "msgOn": "",
  //         "msgBy": "",
  //         "msgByType": "",
  //         "comReq": {
  //           "filterVal": filterVal,
  //           "reqSecureKey": ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0) ? (UserProvider.currentUser?.addiParams?[0] ?? '') : '',
  //           "paging": {
  //             "pageNum": 1,
  //             "paginationRecords": 0,
  //             "recsPerPage": 10,
  //             "sortByType": "ASC",
  //             "totalPages": 0,
  //             "totalRecs": 0
  //           }
  //       }
  //     },
  //   );
  //   if (res?.statusCode == 200) {
  //     final TicketSReply apiRes =
  //     TicketSReply.fromJson(res?.data ?? <String, dynamic>{});

  //     if (apiRes.chMessage?.type == 'SUCCESS') {
  //       return List<TicketReply>.from(
  //         res?.data!['ticketReply'].map<dynamic>(
  //               (dynamic e) => TicketReply.fromJson(e),
  //         ),
  //       );
  //     } else {
  //       appSnackbar(
  //         message: apiRes.chMessage?.message ?? '',
  //         snackbarState: SnackbarState.warning,
  //       );
  //     }
  //   } else {
  //     appSnackbar(
  //       message: 'Something went wrong',
  //       snackbarState: SnackbarState.warning,
  //     );
  //   }
  //   return <TicketReply>[];
  // }

  // /// To create ticket
  // static Future<ChMessage> preferences({
  //   required Map<String, dynamic> formData,
  // }) async {
  //   final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
  //       path: 'customer/sms-email-enable',
  //       data: formData
  //   );
  //   if (res?.statusCode == 200) {
  //     final PreferencesResp apiRes =
  //     PreferencesResp.fromJson(res?.data ?? <String, dynamic>{});
  //     if (apiRes.chMessage?.type == 'SUCCESS') {
  //       return ChMessage.fromJson(res?.data!['chMessage'] ?? <String, dynamic>{});
  //     } else {
  //       appSnackbar(
  //         message: apiRes.chMessage?.message ?? '',
  //         snackbarState: SnackbarState.warning,
  //       );
  //     }
  //   } else {
  //     appSnackbar(
  //       message: 'Something went wrong',
  //       snackbarState: SnackbarState.warning,
  //     );
  //   }
  //   return ChMessage();
  // }

  // /// To get tickets list
  // static Future<WalletResp> getWalletDetails() async {
  //   final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
  //     path: 'wallet/transaction-history',
  //     data: <String, dynamic>{
  //       'reqSecureKey': ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0) ? (UserProvider.currentUser?.addiParams?[0] ?? '') : '',
  //       'addiParams': ['',''],
  //       'paging': {
  //         'pageNum': 1,
  //       }
  //     },
  //   );
  //   if (res?.statusCode == 200) {
  //     final WalletResp apiRes =
  //     WalletResp.fromJson(res?.data ?? <String, dynamic>{});

  //     if (apiRes.chMessage?.type == 'SUCCESS') {
  //       return WalletResp.fromJson(res?.data ?? <String, dynamic>{});
  //     } else {
  //       appSnackbar(
  //         message: apiRes.chMessage?.message ?? '',
  //         snackbarState: SnackbarState.warning,
  //       );
  //     }
  //   } else {
  //     appSnackbar(
  //       message: 'Something went wrong',
  //       snackbarState: SnackbarState.warning,
  //     );
  //   }
  //   return WalletResp();
  // }

  // /// To create ticket
  // static Future<JwtMessage> addAmount({
  //   required Map<String, dynamic> formData,
  // }) async {
  //   final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
  //       path: 'wallet/add-money',
  //       data: formData
  //   );
  //   if (res?.statusCode == 200) {
  //     final AddAmountResp apiRes =
  //     AddAmountResp.fromJson(res?.data ?? <String, dynamic>{});
  //     if (apiRes.jwtMessage?.type == 'SUCCESS') {
  //       return JwtMessage.fromJson(res?.data!['jwtMessage'] ?? <String, dynamic>{});
  //     } else {
  //       appSnackbar(
  //         message: apiRes.jwtMessage?.message ?? '',
  //         snackbarState: SnackbarState.warning,
  //       );
  //     }
  //   } else {
  //     appSnackbar(
  //       message: 'Something went wrong',
  //       snackbarState: SnackbarState.warning,
  //     );
  //   }
  //   return JwtMessage();
  // }

  // /// To send to wallet
  // static Future<JwtMessage> sendToWallet({
  //   required Map<String, dynamic> formData,
  // }) async {
  //   final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
  //       path: 'wallet/pay-money-user',
  //       data: formData
  //   );
  //   if (res?.statusCode == 200) {
  //     final AddAmountResp apiRes =
  //     AddAmountResp.fromJson(res?.data ?? <String, dynamic>{});
  //     if (apiRes.jwtMessage?.type == 'SUCCESS') {
  //       return JwtMessage.fromJson(res?.data!['jwtMessage'] ?? <String, dynamic>{});
  //     } else {
  //       appSnackbar(
  //         message: apiRes.jwtMessage?.message ?? '',
  //         snackbarState: SnackbarState.warning,
  //       );
  //     }
  //   } else {
  //     appSnackbar(
  //       message: 'Something went wrong',
  //       snackbarState: SnackbarState.warning,
  //     );
  //   }
  //   return JwtMessage();
  // }

  // /// To send to Bank
  // static Future<WalletToBankResp> sendWalletToBank({
  //   required Map<String, dynamic> formData,
  // }) async {
  //   final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
  //       path: 'wallet/wallet-to-bank',
  //       data: formData
  //   );
  //   if (res?.statusCode == 200) {
  //     final AddAmountResp apiRes =
  //     AddAmountResp.fromJson(res?.data ?? <String, dynamic>{});
  //     // if (apiRes.jwtMessage?.type == 'SUCCESS') {
  //       return WalletToBankResp.fromJson(res?.data! ?? <String, dynamic>{});
  //     // } else {
  //     //   appSnackbar(
  //     //     message: apiRes.jwtMessage?.message ?? '',
  //     //     snackbarState: SnackbarState.warning,
  //     //   );
  //     // }
  //   } else {
  //     appSnackbar(
  //       message: 'Something went wrong',
  //       snackbarState: SnackbarState.warning,
  //     );
  //   }
  //   return WalletToBankResp();
  // }

  // /// To Add Account to wallet
  // static Future<JwtMessage> addBankAccount({
  //   required Map<String, dynamic> formData,
  // }) async {
  //   final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
  //       path: 'wallet/add-bank-account',
  //       data: formData
  //   );
  //   if (res?.statusCode == 200) {
  //     // final AddAmountResp apiRes =
  //     // AddAmountResp.fromJson(res?.data ?? <String, dynamic>{});
  //     // if (apiRes.jwtMessage?.type == 'SUCCESS') {
  //       return JwtMessage.fromJson(res?.data!['chMessage'] ?? <String, dynamic>{});
  //     // } else {
  //     //   appSnackbar(
  //     //     message: apiRes.jwtMessage?.message ?? '',
  //     //     snackbarState: SnackbarState.warning,
  //     //   );
  //     // }
  //   } else {
  //     appSnackbar(
  //       message: 'Something went wrong',
  //       snackbarState: SnackbarState.warning,
  //     );
  //   }
  //   return JwtMessage();
  // }

  // /// To Add Account to wallet
  // static Future<JwtMessage> removeBankAccount({
  //   required Map<String, dynamic> formData,
  // }) async {
  //   final Response<Map<String, dynamic>?>? res = await APIService.delete(
  //       path: 'wallet/remove-bank-account',
  //       data: formData
  //   );
  //   if (res?.statusCode == 200) {
  //     // final AddAmountResp apiRes =
  //     // AddAmountResp.fromJson(res?.data ?? <String, dynamic>{});
  //     // if (apiRes.jwtMessage?.type == 'SUCCESS') {
  //     return JwtMessage.fromJson(res?.data!['chMessage'] ?? <String, dynamic>{});
  //     // } else {
  //     //   appSnackbar(
  //     //     message: apiRes.jwtMessage?.message ?? '',
  //     //     snackbarState: SnackbarState.warning,
  //     //   );
  //     // }
  //   } else {
  //     appSnackbar(
  //       message: 'Something went wrong',
  //       snackbarState: SnackbarState.warning,
  //     );
  //   }
  //   return JwtMessage();
  // }

  // /// To Get All Added Accounts
  // static Future<WalletAccountResp> getBankAccounts() async {
  //   final Response<Map<String, dynamic>?>? res = await APIService.getAuth(
  //       path: "wallet/view-all-bank-account?customerId=${((UserProvider.currentUser?.addiParams?.length ?? 0) > 0) ? (UserProvider.currentUser?.addiParams?[0] ?? '') : ''}",
  //       // data: formData
  //   );
  //   if (res?.statusCode == 200) {
  //     // final AddAmountResp apiRes =
  //     // AddAmountResp.fromJson(res?.data ?? <String, dynamic>{});
  //     // if (apiRes.jwtMessage?.type == 'SUCCESS') {
  //     return WalletAccountResp.fromJson(res?.data ?? <String, dynamic>{});
  //     // } else {
  //     //   appSnackbar(
  //     //     message: apiRes.jwtMessage?.message ?? '',
  //     //     snackbarState: SnackbarState.warning,
  //     //   );
  //     // }
  //   } else {
  //     appSnackbar(
  //       message: 'Something went wrong',
  //       snackbarState: SnackbarState.warning,
  //     );
  //   }
  //   return WalletAccountResp();
  // }

  // /// To Get Referral Code
  // static Future<RerefCodeResp> getReferralCode() async {
  //   final Response<Map<String, dynamic>?>? res = await APIService.getAuth(
  //     path: "api/rewards/cust-referral-code/${UserProvider.currentUser?.value}",
  //   );
  //   if (res?.statusCode == 200) {
  //     return RerefCodeResp.fromJson(res?.data ?? <String, dynamic>{});
  //   } else {
  //     appSnackbar(
  //       message: 'Something went wrong',
  //       snackbarState: SnackbarState.warning,
  //     );
  //   }
  //   return RerefCodeResp();
  // }

  // /// To Get Testimonial
  // static Future<TestimonialResp> getTestimonial() async {
  //   final Response<Map<String, dynamic>?>? res = await APIService.getAuth(
  //     path: "customer/profile/view-platform-testimonials",
  //   );
  //   if (res?.statusCode == 200) {
  //     return TestimonialResp.fromJson(res?.data ?? <String, dynamic>{});
  //   } else {
  //     appSnackbar(
  //       message: 'Something went wrong',
  //       snackbarState: SnackbarState.warning,
  //     );
  //   }
  //   return TestimonialResp();
  // }
}
