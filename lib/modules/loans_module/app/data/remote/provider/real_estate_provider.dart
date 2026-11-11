// ignore_for_file: always_specify_types

import 'package:dio/dio.dart';
import 'package:dio/src/response.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/app_snackbar.dart';
import 'package:citizenone_app/modules/loans_module/app/data/local/store/user_provider.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/loan/auto_loan/AutoLoanHistoryResp.dart';
import 'package:citizenone_app/modules/loans_module/app/data/remote/api_service/init_api_service.dart';

///
class RealEstateProvider {
  ///
  // static Future<RealEstateDetailsResp> getDetailedRealEstate(
  //     String filterVal,
  //     ) async {
  //   try {
  //     final Response<Map<String, dynamic>?>? response = await APIService.post(
  //         path: 'realestate/home/native-mortgage-prd-view',
  //         data: {
  //           'reqSecureKey': '',
  //           'addiParams': ['REAL_ESTATE'],
  //           'filterVal': filterVal,
  //         });
  //     if (response != null && response.statusCode==200 && response.data != null) {
  //       return RealEstateDetailsResp.fromJson(response.data!);
  //     }
  //   } on Exception catch (e) {
  //     logE(e);
  //   }
  //   return RealEstateDetailsResp();
  // }

  // ///
  // static Future<EligibilityEntity> mortgageCalculator(
  //     {required Map<String, dynamic> data}) async {
  //   try {
  //     final Response<Map<String, dynamic>?>? response = await APIService.post(
  //         path: 'realestate/home/mortgage-eligibility-calculator', data: data);
  //     if (response != null && response.isOk && response.data != null) {
  //       return EligibilityEntity.fromJson(response.data!);
  //     }
  //   } on Exception catch (e) {
  //     logE(e);
  //   }
  //   return EligibilityEntity();
  // }

  // static Future<EligibilityEntity> newMortgageCalculator({
  //   required Map<String, dynamic> data,
  // }) async {
  //   const String endpoint =
  //       'realestate/home/new-mortgage-eligibility-calculator';

  //   try {
  //     /// ----------------------------------------------------------
  //     /// API REQUEST LOG
  //     /// ----------------------------------------------------------
  //     logI(
  //       'POST $endpoint\n'
  //           'Request Body: ${jsonEncode(data)}',
  //     );

  //     final Response<Map<String, dynamic>?>? response =
  //     await APIService.post(path: endpoint, data: data);

  //     /// ----------------------------------------------------------
  //     /// API RESPONSE LOG
  //     /// ----------------------------------------------------------
  //     if (response != null) {
  //       logI(
  //         'Response (${response.statusCode})\n'
  //             'Success: ${response.isOk}\n'
  //             'Body: ${jsonEncode(response.data)}',
  //       );
  //     } else {
  //       logE('Response: NULL');
  //     }

  //     /// Validate and return
  //     if (response != null && response.isOk && response.data != null) {
  //       return EligibilityEntity.fromJson(response.data!);
  //     }
  //   } catch (e, stackTrace) {
  //     /// ----------------------------------------------------------
  //     /// ERROR LOG
  //     /// ----------------------------------------------------------
  //     logE('Exception in newMortgageCalculator: $e\n$stackTrace');
  //   }

  //   return EligibilityEntity();
  // }

  // static Future<LimitFnaSubResp> mortgageFormFOnline(
  //     {required Map<String, dynamic> data}) async {
  //   try {
  //     final Response<Map<String, dynamic>?>? response = await APIService.post(
  //         path: 'realestate/home/orders/mortgage-cheque-details', data: data);
  //     if (response != null && response.isOk && response.data != null) {
  //       return LimitFnaSubResp.fromJson(response.data!);
  //     }
  //   } on Exception catch (e) {
  //     logE(e);
  //   }
  //   return LimitFnaSubResp();
  // }

  // static Future<LimitFnaSubResp> mortgageFormFOfline(
  //     {required Map<String, dynamic> data}) async {
  //   try {
  //     final Response<Map<String, dynamic>?>? response = await APIService.post(
  //         path: 'realestate/home/orders/cheque-address-details', data: data);
  //     if (response != null && response.isOk && response.data != null) {
  //       return LimitFnaSubResp.fromJson(response.data!);
  //     }
  //   } on Exception catch (e) {
  //     logE(e);
  //   }
  //   return LimitFnaSubResp();
  // }

  // ///
  // static Future<AutoEligibilityResp> autoCalculator(
  //     {required Map<String, dynamic> data}) async {
  //   try {
  //     final Response<Map<String, dynamic>?>? response =
  //     await APIService.post(path: 'auto/home/emi-calculator', data: data);
  //     if (response != null && response.isOk && response.data != null) {
  //       return AutoEligibilityResp.fromJson(response.data!);
  //     }
  //   } on Exception catch (e) {
  //     logE(e);
  //   }
  //   return AutoEligibilityResp();
  // }

  // ///
  // static Future<AutoEligibilityResp> newAutoCalculator({
  //   required Map<String, dynamic> data,
  // }) async {
  //   const String endPoint = 'auto/home/new-emi-calculator';

  //   // 🔹 PRINT REQUEST
  //   log("🔻 API REQUEST");
  //   log("URL: $endPoint");
  //   log("BODY: ${jsonEncode(data)}");

  //   try {
  //     final Response<Map<String, dynamic>?>? response =
  //     await APIService.post(path: endPoint, data: data);

  //     // 🔹 PRINT RESPONSE
  //     log("🔺 API RESPONSE");
  //     log("STATUS: ${response?.statusCode}");
  //     log("BODY: ${jsonEncode(response?.data)}");

  //     if (response != null && response.isOk && response.data != null) {
  //       return AutoEligibilityResp.fromJson(response.data!);
  //     }
  //   } catch (e, stack) {
  //     log("❌ API ERROR", error: e, stackTrace: stack);
  //   }

  //   return AutoEligibilityResp();
  // }

  // ///
  // static Future<List<Propertie>> filterProperties({
  //   int? minValue,
  //   int? maxValue,
  //   List<String>? bedRoom,
  //   List<String>? propertyType,
  //   List<String>? locations,
  //   int? pageNum
  // }) async {
  //   try {
  //     final Response<Map<String, dynamic>?>? response = await APIService.post(
  //         path: 'realestate/home/mortgage-search-products',
  //         data: {
  //           'reqSecureKey': UserProvider.currentUser?.addiParams![0],
  //           'paging': {
  //             'pageNum': pageNum,
  //             'paginationRecords': 0,
  //             'recsPerPage': 0,
  //             'sortByType': 'ASC',
  //             'totalPages': 0,
  //             'totalRecs': 0
  //           },
  //           'minValue': minValue,
  //           'maxValue': maxValue,
  //           'bedrooms': bedRoom,
  //           'propertyType': propertyType,
  //           'locations': locations,
  //         });

  //     if (response != null &&
  //         response.isOk &&
  //         (response.data?.containsKey('products') ?? false)) {
  //       if (response.data?['products'] != null){
  //         return List.from(
  //           response.data?['products']?.map(
  //                 (e) => Propertie.fromJson(e),
  //           ),
  //         );
  //       } else {
  //         appSnackbar(
  //           message: 'No Properties Found',
  //           snackbarState: SnackbarState.warning,
  //         );
  //       }
  //     }
  //     logE(response);
  //   } on DioError catch (e) {
  //     logE(e);
  //   } on Exception catch (e) {
  //     logE(e);
  //   }
  //   return <Propertie>[];
  // }

  // ///
  // static Future<RentVsBuyEntity> rentVsBuy({
  //   required Map<String, dynamic> data,
  // }) async {
  //   try {
  //     final Response<Map<String, dynamic>?>? response = await APIService.post(
  //       path: 'realestate/home/mortgage-rent-buy-calc',
  //       data: data,
  //     );

  //     if (response != null && response.allIzzWell) {
  //       return RentVsBuyEntity.fromJson(response.data!);
  //     }
  //     logE(response);
  //   } on DioError catch (e) {
  //     logE(e);
  //   } on Exception catch (e) {
  //     logE(e);
  //   }
  //   return RentVsBuyEntity();
  // }

  // ///
  // static Future<bool> addSiteVisitEvent({
  //   required Map<String, dynamic> data,
  // }) async {
  //   try {
  //     final Response<Map<String, dynamic>?>? response = await APIService.post(
  //       path: 'realestate/home/add-site-visit-event',
  //       data: data,
  //     );
  //     if (response != null && response.allIzzWell) {
  //       return response.data!['chMessage']['type'] == 'SUCCESS';
  //     }
  //     logE(response);
  //   } on DioError catch (e) {
  //     logE(e);
  //   } on Exception catch (e) {
  //     logE(e);
  //   }
  //   return false;
  // }

  // ///
  // static Future<LimitFnaSubResp> submitInterest(
  //     String filterval, String skuID) async {
  //   try {
  //     final Response<Map<String, dynamic>?>? response =
  //     await APIService.postAuth(
  //       path: 'realestate/home/buy-now',
  //       data: <String, dynamic>{
  //         'reqSecureKey': ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0) ? (UserProvider.currentUser?.addiParams?[0] ?? '') : '',
  //         'filterVal': filterval,
  //         'filterHashKey': skuID
  //       },
  //     );
  //     if (response != null && response.isOk) {
  //       return LimitFnaSubResp.fromJson(response?.data ?? <String, dynamic>{});
  //     }
  //   } on Exception catch (e) {
  //     logE(e);
  //   }
  //   return LimitFnaSubResp();
  // }

  // static Future<MortgageProductListResp> getRealEstateProduct(int pageNumber) async {
  //   try {
  //     final Response<Map<String, dynamic>?>? response = await APIService.post(
  //         path: 'realestate/home/mortgage-featured-homes',
  //         data: {
  //           "paging": {
  //             "pageNum": pageNumber,
  //             "paginationRecords": 0,
  //             "recsPerPage": 10,
  //             "sortByType": "ASC",
  //             "totalPages": 0,
  //             "totalRecs": 0
  //           },
  //           "filterHashKey": 0,
  //           "filterVal": "/realestate",
  //           "hKey": 0,
  //           "reqSecureKey": ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0) ? (UserProvider.currentUser?.addiParams?[0] ?? "") : "",
  //         });
  //     if (response != null && response.isOk && response.data != null) {
  //       return MortgageProductListResp.fromJson(response.data!);
  //     }
  //   } on Exception catch (e) {
  //     logE(e);
  //   }
  //   return MortgageProductListResp();
  // }

  // static Future<RealEstaeFilterResp> getRealEstateFilter() async {
  //   try {
  //     final Response<Map<String, dynamic>?>? response = await APIService.post(
  //         path: 'realestate/home/mortgage-search-filters',
  //         data: {'reqSecureKey': ''});
  //     if (response != null && response.isOk && response.data != null) {
  //       return RealEstaeFilterResp.fromJson(response.data!);
  //     }
  //   } on Exception catch (e) {
  //     logE(e);
  //   }
  //   return RealEstaeFilterResp();
  // }

  // static Future<RealEstateAmenitiesResp> getRealEstateAmenities(
  //     String filterval) async {
  //   try {
  //     final Response<Map<String, dynamic>?>? response = await APIService.post(
  //         path: 'realestate/home/real-estate-facilities',
  //         data: {
  //           'reqSecureKey': '',
  //           "addiParams": ['REAL_ESTATE'],
  //           "filterVal": filterval
  //         });
  //     if (response != null && response.isOk && response.data != null) {
  //       return RealEstateAmenitiesResp.fromJson(response.data!);
  //     }
  //   } on Exception catch (e) {
  //     logE(e);
  //   }
  //   return RealEstateAmenitiesResp();
  // }

  // static Future<AmenitiesResp> getRealAmenities(
  //     String filterval, String parm) async {
  //   try {
  //     final Response<Map<String, dynamic>?>? response = await APIService.post(
  //         path: 'realestate/home/mortgage-amenities',
  //         data: {
  //           'reqSecureKey': '',
  //           "addiParams": [parm],
  //           "filterVal": filterval
  //         });
  //     if (response != null && response.isOk && response.data != null) {
  //       return AmenitiesResp.fromJson(response.data!);
  //     }
  //   } on Exception catch (e) {
  //     logE(e);
  //   }
  //   return AmenitiesResp();
  // }

  // static Future<ReImageListRep> getRealImages(
  //     String filterval, String parm) async {
  //   try {
  //     final Response<Map<String, dynamic>?>? response =
  //     await APIService.postAuth(path: 'realestate/home/product-images', data: {
  //       "url": filterval,
  //       "appType": "WEB",
  //       "imageType": parm,
  //       "filterHashKey": 0,
  //       "hKey": 0,
  //       "reqSecureKey": ""
  //     });
  //     if (response != null && response.isOk && response.data != null) {
  //       return ReImageListRep.fromJson(response.data!);
  //     }
  //   } on Exception catch (e) {
  //     logE(e);
  //   }
  //   return ReImageListRep();
  // }

  // static Future<LimitFnaSubResp> getRealEstateFinanceCheque(
  //     String filterval) async {
  //   try {
  //     final Response<Map<String, dynamic>?>? response = await APIService.post(
  //         path: 'realestate/home/orders/mortgage-finance-check',
  //         data: {
  //           'reqSecureKey': ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0) ? (UserProvider.currentUser?.addiParams?[0] ?? '') : '',
  //           "filterVal": filterval
  //         });
  //     if (response != null && response.isOk && response.data != null) {
  //       return LimitFnaSubResp.fromJson(response.data!);
  //     }
  //   } on Exception catch (e) {
  //     logE(e);
  //   }
  //   return LimitFnaSubResp();
  // }

  // static Future<ViewTestDriveResp> getRealEstateViewSiteVisit(
  //     String filterval, String vendorid) async {
  //   try {
  //     final Response<Map<String, dynamic>?>? response = await APIService.post(
  //         path: 'realestate/home/view-site-visit-event',
  //         data: {
  //           "comReq": {"filterVal": filterval},
  //           "vendorId": vendorid
  //         });
  //     if (response != null && response.isOk && response.data != null) {
  //       return ViewTestDriveResp.fromJson(response.data!);
  //     }
  //   } on Exception catch (e) {
  //     logE(e);
  //   }
  //   return ViewTestDriveResp();
  // }

  // static Future<BankListResp?> fetchNGBankList(String filterval) async {
  //   try {
  //     final Response<Map<String, dynamic>?>? response =
  //     await APIService.postAuth(
  //       path: 'auto/orders/bank-list-negotiation',
  //       data: <String, dynamic>{
  //         'filterVal': filterval,
  //         'reqSecureKey': ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0) ? (UserProvider.currentUser?.addiParams?[0] ?? '') : '',
  //       },
  //     );
  //     if (response != null && response.isOk) {
  //       return BankListResp.fromJson(response.data!);
  //     }
  //   } on Exception catch (e) {
  //     logE(e);
  //   }
  //   return null;
  // }

  // static Future<BankListResp?> realEstateNGBankList(String filterval) async {
  //   try {
  //     final Response<Map<String, dynamic>?>? response =
  //     await APIService.postAuth(
  //       path: 'realestate/home/bank-list-negotiation',
  //       data: <String, dynamic>{
  //         'filterVal': filterval,
  //         'reqSecureKey': ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0) ? (UserProvider.currentUser?.addiParams?[0] ?? '') : '',
  //       },
  //     );
  //     if (response != null && response.isOk) {
  //       return BankListResp.fromJson(response.data!);
  //     }
  //   } on Exception catch (e) {
  //     logE(e);
  //   }
  //   return null;
  // }

  // static Future<VendorNegotiateListResp?> fetchDealerList(
  //     String productid) async {
  //   try {
  //     final Response<Map<String, dynamic>?>? response =
  //     await APIService.postAuth(
  //       path: 'auto/orders/vdr-stores-list',
  //       data: <String, dynamic>{
  //         'filterVal': productid,
  //         'reqSecureKey': ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0) ? (UserProvider.currentUser?.addiParams?[0] ?? '') : '',
  //       },
  //     );
  //     if (response != null && response.isOk) {
  //       return VendorNegotiateListResp.fromJson(response.data!);
  //     }
  //   } on Exception catch (e) {
  //     logE(e);
  //   }
  //   return null;
  // }

  // static Future<VendorNegotiateListResp?> fetchREDealerList(
  //     String productid) async {
  //   try {
  //     final Response<Map<String, dynamic>?>? response =
  //     await APIService.postAuth(
  //       path: 'realestate/home/vdr-stores-list',
  //       data: <String, dynamic>{
  //         'filterVal': productid,
  //         'reqSecureKey': ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0) ? (UserProvider.currentUser?.addiParams?[0] ?? '') : '',
  //       },
  //     );
  //     if (response != null && response.isOk) {
  //       return VendorNegotiateListResp.fromJson(response.data!);
  //     }
  //   } on Exception catch (e) {
  //     logE(e);
  //   }
  //   return null;
  // }

  // static Future<LimitFnaSubResp?> autoStartChat({
  //   required Map<String, dynamic> formData,
  // }) async {
  //   bool success = false;

  //   final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
  //       path: 'realestate/home/start-deal-chat', data: formData);

  //   if (res?.statusCode == 200) {
  //     return LimitFnaSubResp.fromJson(res?.data ?? <String, dynamic>{});
  //   } else {
  //     appSnackbar(
  //       message: 'Something went wrong',
  //       snackbarState: SnackbarState.warning,
  //     );
  //   }
  //   return LimitFnaSubResp();
  // }

  // static Future<BankChatResp?> autoAllChat({
  //   required Map<String, dynamic> formData,
  // }) async {
  //   bool success = false;

  //   final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
  //       path: 'realestate/home/get-deal-chat-msg', data: formData);

  //   if (res?.statusCode == 200) {
  //     return BankChatResp.fromJson(res?.data ?? <String, dynamic>{});
  //   } else {
  //     appSnackbar(
  //       message: 'Something went wrong',
  //       snackbarState: SnackbarState.warning,
  //     );
  //   }
  //   return BankChatResp();
  // }

  // static Future<DealChatListResp?> autoDealChat({
  //   required Map<String, dynamic> formData,
  // }) async {
  //   bool success = false;

  //   final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
  //       path: 'realestate/home/deal-chat-list', data: formData);

  //   if (res?.statusCode == 200) {
  //     return DealChatListResp.fromJson(res?.data ?? <String, dynamic>{});
  //   } else {
  //     appSnackbar(
  //       message: 'Something went wrong',
  //       snackbarState: SnackbarState.warning,
  //     );
  //   }
  //   return DealChatListResp();
  // }

  // static Future<LimitFnaSubResp?> sendChat({
  //   required Map<String, dynamic> formData,
  // }) async {
  //   bool success = false;

  //   final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
  //       path: 'realestate/home/send-deal-chat-msg', data: formData);

  //   if (res?.statusCode == 200) {
  //     return LimitFnaSubResp.fromJson(res?.data ?? <String, dynamic>{});
  //   } else {
  //     appSnackbar(
  //       message: 'Something went wrong',
  //       snackbarState: SnackbarState.warning,
  //     );
  //   }
  //   return LimitFnaSubResp();
  // }

  // static Future<LimitFnaSubResp?> fetchREBookingAmt() async {
  //   try {
  //     final Response<Map<String, dynamic>?>? response =
  //     await APIService.postAuth(
  //       path: 'realestate/home/orders/mortgage-booking-amount',
  //       data: <String, dynamic>{
  //         'filterVal': LocalStore.buyNowFilterVal,
  //         'reqSecureKey': ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0) ? (UserProvider.currentUser?.addiParams?[0] ?? '') : '',
  //       },
  //     );
  //     if (response != null && response.isOk) {
  //       return LimitFnaSubResp.fromJson(response.data!);
  //     }
  //   } on Exception catch (e) {
  //     logE(e);
  //   }
  //   return LimitFnaSubResp();
  // }

  /// To get Home Loan History
  static Future<AutoLoanHistoryResp?> getHomeLoanHistory() async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'realestate/home/orders/order-history-loan',
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
}
