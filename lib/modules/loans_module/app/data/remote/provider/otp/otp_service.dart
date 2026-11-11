import 'package:dio/dio.dart';

import '../../../../components/utils/app_snackbar.dart';
import '../../../config/logger.dart';
import '../../../model/otp/otp_verification_response.dart';
import '../../api_service/init_api_service.dart';

/// OTP Service for handling OTP operations
class OtpService {
  static const String _otpBaseUrl = 'http://192.168.1.81:2048/';

  /// Generate/Get OTP
  static Future<OtpVerificationResponse?> getOtp({
    required String purpose,
    required String referenceType,
    required List<String> addiParams,
  }) async {
    try {
      final Response<Map<String, dynamic>?>? res = await APIService.post(
        path: 'profitto/api/otp/get-otp',
        data: <String, dynamic>{
          'purpose': purpose,
          'referenceType': referenceType,
          'addiParams': addiParams,
        },
        forcedBaseUrl: _otpBaseUrl,
      );

      if (res?.statusCode == 200 && res?.data != null) {
        return OtpVerificationResponse.fromJson(res!.data!);
      }

      // Handle error response
      if (res?.data != null && res?.data!['chMessage'] != null) {
        appSnackbar(
          message: res?.data!['chMessage']['message'] ?? 'Failed to get OTP',
          snackbarState: SnackbarState.warning,
        );
      }
    } on DioException catch (e) {
      logE(e);
      appSnackbar(
        message: 'Network error. Please try again.',
        snackbarState: SnackbarState.danger,
      );
    } catch (e) {
      logE(e);
      appSnackbar(
        message: 'Something went wrong. Please try again.',
        snackbarState: SnackbarState.danger,
      );
    }

    return null;
  }

  /// Verify OTP
  static Future<OtpVerificationResponse?> verifyOtp({
    required String channel,
    required String destination,
    required String purpose,
    required String referenceType,
    required String otp,
  }) async {
    try {
      final Response<Map<String, dynamic>?>? res = await APIService.post(
        path: 'profitto/api/otp/verify',
        data: <String, dynamic>{
          'channel': channel,
          'destination': destination,
          'purpose': purpose,
          'referenceType': referenceType,
          'otp': otp,
        },
        forcedBaseUrl: _otpBaseUrl,
      );

      if (res?.statusCode == 200 && res?.data != null) {
        return OtpVerificationResponse.fromJson(res!.data!);
      }

      // Handle error response
      if (res?.data != null && res?.data!['chMessage'] != null) {
        appSnackbar(
          message:
              res?.data!['chMessage']['message'] ?? 'OTP verification failed',
          snackbarState: SnackbarState.warning,
        );
      }
    } on DioException catch (e) {
      logE(e);
      appSnackbar(
        message: 'Network error. Please try again.',
        snackbarState: SnackbarState.danger,
      );
    } catch (e) {
      logE(e);
      appSnackbar(
        message: 'Something went wrong. Please try again.',
        snackbarState: SnackbarState.danger,
      );
    }

    return null;
  }
}
