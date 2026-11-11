import 'dart:developer';

import 'package:citizenone_app/modules/agrinet/app/data/config/api_res_ext.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide Response;

import '../../components/utils/user_prefs.dart';
import '../../models/HomeResp/HomeImageResp.dart';
import '../../modules/success_info/views/success_info_view.dart';
import '../../routes/app_pages.dart';
import '../model/common/ch_message.dart';
import '../model/user/main_response.dart';
import '../model/user/otp_response.dart';
import '../model/user/pal_res.dart';
import '../remote/api_service/ApiEndPoints.dart';
import '../remote/api_service/init_api_service.dart';

class ProfileService {
  static Future<MainResponse?> userRegister({
    required Map<String, dynamic> request,
  }) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.userRegistration,
        data: request,
      );

      if (response == null || response.data == null) {
        debugPrint("❌ userRegister: Null response from API");
        return null;
      }

      if (response.data is! Map<String, dynamic>) {
        debugPrint(
          "❌ userRegister: Invalid response format -> ${response.data}",
        );
        return null;
      }

      final Map<String, dynamic> json = response.data as Map<String, dynamic>;

      return MainResponse.fromJson(json);
    } catch (err, stacktrace) {
      debugPrint("❌ Error in userRegister: $err");
      debugPrint("Stacktrace: $stacktrace");
      return null;
    }
  }

  static Future<OtpResponse?> getOtp({
    required Map<String, dynamic> request,
  }) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.getRegistrationOtp,
        data: request,
      );

      if (response == null || response.data == null) {
        debugPrint("❌ getOtp: Null response from API");
        return null;
      }

      if (response.data is! Map<String, dynamic>) {
        debugPrint("❌ getOtp: Invalid response format -> ${response.data}");
        return null;
      }

      final Map<String, dynamic> json = response.data as Map<String, dynamic>;

      return OtpResponse.fromJson(json);
    } catch (err, stacktrace) {
      debugPrint("❌ Error in getOtp: $err");
      debugPrint("Stacktrace: $stacktrace");
      return null;
    }
  }

  static Future<List<Slideimages>> fetchSliderImages() async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: ApiEndPoints.homeImage,
        data: <String, dynamic>{'filterVal': UserPrefs.user?.userId ?? ''},
      );

      if (response != null && response.isOk) {
        final model = homeViewResp.fromJson(response.data!);
        final images = model.slideimages ?? <Slideimages>[];

        if (images.isEmpty) {
          log('WARNING: No slider images found in response');
        }

        return images;
      } else {
        log('ERROR: Response not OK. Status: ${response?.statusCode}');
      }
    } catch (e) {
      log('ERROR fetching slider images: $e');
    }
    return <Slideimages>[];
  }

  Future<bool> updateProfile({
    required String firstName,
    required String email,
    String? imageBase64,
  }) async {
    try {
      final data = {
        "reqSecureKey": UserPrefs.user?.userId,
        "palRes": {
          "firstName": firstName,
          "email": email,
          "documents": {"fileBytes": imageBase64},
        },
      };

      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: ApiEndPoints.updatePalProfile,
        data: data,
      );

      if (response != null && response.isOk) {
        final resp = response.data!;

        /// Parse chMessage using model
        final ch = ChMessage.fromJson(resp["chMessage"]);
        final bool isError = ch.isError ?? true;
        final String message = ch.message ?? "Something went wrong";

        if (!isError) {
          /// SUCCESS
          final updatedPal = PalRes.fromJson(resp["palRes"]);
          UserPrefs.user?.palRes = updatedPal;

          await UserPrefs.updateUser(UserPrefs.user!);

          await SuccessInfoView.show(
            title: "Success",
            message: message,
            onOk: () async {
              Get.offAllNamed(Routes.HOME);
            },
          );

          return true;
        } else {
          /// ERROR from API
          await SuccessInfoView.show(
            title: "Failed",
            message: message,
            onOk: () => Get.back(),
          );
          return false;
        }
      }
    } catch (e) {
      log("ERROR updating profile: $e");

      await SuccessInfoView.show(
        title: "Error",
        message: "An unexpected error occurred.",
        onOk: () => Get.back(),
      );
    }

    return false;
  }
}
