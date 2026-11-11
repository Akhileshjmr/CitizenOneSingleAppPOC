import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/app_snackbar.dart';

import '../../../app_environment.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/ag_constants.dart';
import '../../config/logger.dart';
import '../../local/store/user_provider.dart';
import '../../model/user/l2l_mob_message.dart';
import '../../model/user/login_response.dart';
import '../api_service/init_api_service.dart';

class AuthService {
  static Future<bool> login({required String phoneNumber}) async {
    await UserProvider.onLogout();

    if (phoneNumber.isEmpty) {
      appSnackbar(message: "Please enter secure key");
      return false;
    }

    try {
      final response = await APIService.post(
        path: 'loan-service/customer/register',
        data: {
          "reqSecureKey": phoneNumber,
          // "filterVal": AgConstants.moduleName,
        },
      );

      if (response == null ||
          response.statusCode != 200 ||
          response.data == null) {
        throw Exception("Invalid server response");
      }

      final LoginResponse loginResponse = LoginResponse.fromJson(
        response.data ?? {},
      );

      /// Handle API error
      if (loginResponse.chMessage.isError) {
        appSnackbar(
          message: loginResponse.chMessage.message ?? "Login failed",
          snackbarState: SnackbarState.warning,
        );
        return false;
      }

      /// Handle invalid secure key returned by API
      if (loginResponse.reqSecureKey == null ||
          loginResponse.reqSecureKey!.trim().isEmpty) {
        appSnackbar(
          message:
              loginResponse.chMessage.message ??
              "Failed to perform the operation.",
          snackbarState: SnackbarState.warning,
        );
        return false;
      }

      /// Save secure key
      await UserProvider.onLogin(loginResponse, "");
      await UserProvider.saveMobile(phoneNumber);

      if (AppEnvironment.isEmbeddedInHostApp) {
        Get.toNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.HOME);
      }

      return true;
    } catch (e) {
      appSnackbar(
        message: "Something went wrong",
        snackbarState: SnackbarState.warning,
      );
      return false;
    }
  }

  /// Get OTP
  static Future<String?> getOtp({
    required Map<String, dynamic> formData,
  }) async {
    try {
      final res = await APIService.post(
        path: 'customer/reg/get-otp',
        data: formData,
      );

      if (res?.statusCode == 200 && res?.data != null) {
        final otp = res?.data!['otp'] as String?;
        logI(res?.data);
        return otp;
      }
    } on DioException catch (e) {
      logE(e);
    } catch (e) {
      logE(e);
    }

    return null;
  }

  /// Login with OTP
  static Future<LoginResponse> loginWithOTP(Map<String, dynamic> data) async {
    try {
      final res = await APIService.post(
        path: 'auth/login-with-otp',
        data: data,
      );

      if (res?.statusCode == 200 && res?.data != null) {
        return LoginResponse.fromJson(res!.data!);
      }
    } on DioException catch (e) {
      logE(e);
    } catch (e) {
      logE(e);
    }

    /// Fallback error response
    return LoginResponse(chMessage: L2lMobMessage(isError: true));
  }
}
