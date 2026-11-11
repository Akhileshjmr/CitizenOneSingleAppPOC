import 'package:citizenone_app/core/constants/api_constants.dart';
import 'package:citizenone_app/core/network/dio_client.dart';
import 'package:citizenone_app/features/kyc/data/models/kyc_otp_response_model.dart';
import 'package:citizenone_app/features/kyc/data/models/kyc_recent_history_response_model.dart';
import 'package:citizenone_app/features/kyc/data/models/kyc_user_response_model.dart';
import 'package:citizenone_app/features/kyc/data/models/kyc_verify_otp_response_model.dart';
import 'package:citizenone_app/features/kyc/data/models/submit_kyc_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart';

abstract class KycRemoteDataSource {
  Future<KycUserResponseModel?> fetchKycUser({
    required String mobileNumber,
    required String nationalId,
  });

  /// Returns the raw location payload map — repository is responsible
  /// for parsing the `selectOptionList` groups.
  Future<Map<String, dynamic>> fetchLocations();

  /// Returns [SubmitKycResponseModel] on success.
  /// Throws [Exception] with a user-readable message on failure.
  Future<SubmitKycResponseModel> submitKyc(Map<String, dynamic> req);

  /// Returns [KycRecentHistoryResponseModel] on success.
  /// Throws [Exception] on failure.
  Future<KycRecentHistoryResponseModel> fetchRecentHistory(
    Map<String, dynamic> req,
  );

  /// Downloads the file at [url] to the device's Downloads folder (mobile)
  /// or triggers a browser download (web). Returns true on success.
  /// Throws on failure.
  Future<bool> downloadFile({required String url, required String fileName});

  /// Send OTP. Throws [Exception] with message on error / locked state.
  Future<KycOtpResponseModel> sendOtp(Map<String, dynamic> req);

  /// Resend OTP. Throws [Exception] with message on error.
  Future<KycOtpResponseModel> resendOtp(Map<String, dynamic> req);

  /// Verify OTP. Throws [Exception] with message on error.
  Future<KycVerifyOtpResponseModel> verifyOtp(Map<String, dynamic> req);
}

class KycRemoteDataSourceImpl implements KycRemoteDataSource {
  final DioClient apiClient;

  KycRemoteDataSourceImpl({required this.apiClient});

 
  @override
  Future<KycUserResponseModel?> fetchKycUser({
    required String mobileNumber,
    required String nationalId,
  }) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.searchKycUser,
        data: {'mobile': mobileNumber.trim(), 'nationalId': nationalId.trim()},
      );

      if (response.statusCode == 200) {
        if (response.data['recordExists'] == true) {
          return KycUserResponseModel.fromJson(response.data);
        }
        // recordExists == false → user not found, not an error
        return null;
      }

      throw Exception('Server error');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Network error: ${e.message}',
      );
    } catch (e) {
      rethrow;
    }
  }

  // -------------------------------------------------------------------------
  // Locations
  // -------------------------------------------------------------------------

  @override
  Future<Map<String, dynamic>> fetchLocations() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.fetchLocationUrl);
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      }
      throw Exception('Unable to fetch locations');
    } catch (e) {
      throw Exception('Unable to fetch locations');
    }
  }

  // -------------------------------------------------------------------------
  // Submit / Update KYC
  // -------------------------------------------------------------------------

  @override
  Future<SubmitKycResponseModel> submitKyc(Map<String, dynamic> req) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.submitKycUrl,
        data: req,
      );

      if (response.statusCode == 200) {
        if (response.data['chMessage']['isError'] == false) {
          return SubmitKycResponseModel.fromJson(response.data);
        }
        throw Exception('${response.data['chMessage']['message']}');
      }
      throw Exception('Server error');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Network error: ${e.message}',
      );
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // -------------------------------------------------------------------------
  // Recent history
  // -------------------------------------------------------------------------

  @override
  Future<KycRecentHistoryResponseModel> fetchRecentHistory(
    Map<String, dynamic> req,
  ) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.fetchRecentHistoryUrl,
        data: req,
      );

      if (response.statusCode == 200) {
        if (response.data['chMessage']['isError'] == true) {
          throw Exception('${response.data['chMessage']['message']}');
        }
        return KycRecentHistoryResponseModel.fromJson(response.data);
      }
      throw Exception('Unable to fetch history');
    } catch (e) {
      throw Exception('Unable to fetch history');
    }
  }

  // -------------------------------------------------------------------------
  // Download
  // -------------------------------------------------------------------------

  @override
  Future<bool> downloadFile({
    required String url,
    required String fileName,
  }) async {
    // Reuses the shared, session-authenticated `apiClient.dio` (same
    // instance normal API calls use) instead of a bare `Dio()`, so this
    // download carries the `X-Session-Token` header too — a bare Dio
    // instance has none of DioClient's interceptors attached.
    final dio = apiClient.dio;
    final fullUrl = '${ApiConstants.profittoBaseUrl}$url';

    try {
      if (kIsWeb) {
        final response = await dio.get(
          fullUrl,
          options: Options(responseType: ResponseType.bytes),
        );
        final bytes = Uint8List.fromList(response.data as List<int>);
        final blob = Blob([bytes]);
        final objectUrl = Url.createObjectUrl(blob);
        AnchorElement(href: objectUrl)
          ..setAttribute('download', fileName)
          ..click();
        Url.revokeObjectUrl(objectUrl);
        return true;
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final savePath = '/storage/emulated/0/Download/$timestamp$fileName';
      await dio.download(fullUrl, savePath);
      return true;
    } catch (_) {
      return false;
    }
  }

  // -------------------------------------------------------------------------
  // OTP
  // -------------------------------------------------------------------------

  @override
  Future<KycOtpResponseModel> sendOtp(Map<String, dynamic> req) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.getOtpKycUrl,
        data: req,
      );

      if (response.statusCode == 200) {
        if (response.data['isLocked'] == true) {
          throw Exception('${response.data['chMessage']['message']}');
        }
        if (response.data['chMessage']['isError'] == false) {
          return KycOtpResponseModel.fromJson(response.data);
        }
        throw Exception('${response.data['chMessage']['message']}');
      }
      throw Exception('Server error');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Network error: ${e.message}',
      );
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<KycOtpResponseModel> resendOtp(Map<String, dynamic> req) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.resendOtpKycUrl,
        data: req,
      );

      if (response.statusCode == 200) {
        if (response.data['chMessage']['isError'] == false) {
          return KycOtpResponseModel.fromJson(response.data);
        }
        throw Exception('${response.data['chMessage']['message']}');
      }
      throw Exception('Server error');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Network error: ${e.message}',
      );
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<KycVerifyOtpResponseModel> verifyOtp(Map<String, dynamic> req) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.verifyOtpKycUrl,
        data: req,
      );

      if (response.statusCode == 200) {
        if (response.data['chMessage']['isError'] == false) {
          return KycVerifyOtpResponseModel.fromJson(response.data);
        }
        throw Exception('${response.data['chMessage']['message']}');
      }
      throw Exception('Server error');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Network error: ${e.message}',
      );
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
