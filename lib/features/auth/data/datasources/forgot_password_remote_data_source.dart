import 'package:citizenone_app/app/env/app_env.dart';
import 'package:citizenone_app/core/error/exception.dart';
import 'package:citizenone_app/core/network/dio_client.dart';
import 'package:dio/dio.dart';

import '../models/forgot_password_request_model.dart';
import '../models/forgot_password_response_model.dart';
import '../models/resend_otp_request_model.dart';
import '../models/resend_otp_response_model.dart';
import '../models/reset_password_request_model.dart';
import '../models/reset_password_response_model.dart';
import '../models/verify_otp_request_model.dart';
import '../models/verify_otp_response_model.dart';

/// Remote data source for the agent user service
/// `POST /password/forgot`, `POST /password/verify-otp`,
/// `POST /password/resend-otp` and `POST /password/reset` endpoints.
///
/// Uses a private Dio instance configured for the agent API, mirroring
/// the pattern already established by [AuthRemoteDataSource] and
/// [ChangePasswordRemoteDataSource]. Throws [ServerException] (or a
/// plain [Exception] wrapping a user-friendly message) on failure.
abstract class ForgotPasswordRemoteDataSource {
  Future<ForgotPasswordResponseModel> forgotPassword({
    required String mobileNumber,
  });

  Future<VerifyOtpResponseModel> verifyOtp({
    required String mobileNumber,
    required String otp,
  });

  Future<ResendOtpResponseModel> resendOtp({required String mobileNumber});

  Future<ResetPasswordResponseModel> resetPassword({
    required String mobileNumber,
    required String newPassword,
  });
}

class ForgotPasswordRemoteDataSourceImpl
    implements ForgotPasswordRemoteDataSource {
  static const String _forgotPath = '/password/forgot';
  static const String _verifyOtpPath = '/password/verify-otp';
  static const String _resendOtpPath = '/password/resend-otp';
  static const String _resetPath = '/password/reset';

  final DioClient apiClient;
  final AppEnv env;
  final Dio? _agentDioOverride;

  ForgotPasswordRemoteDataSourceImpl({
    required this.apiClient,
    required this.env,
    Dio? agentDioOverride,
  }) : _agentDioOverride = agentDioOverride;

  @override
  Future<ForgotPasswordResponseModel> forgotPassword({
    required String mobileNumber,
  }) async {
    return _post<ForgotPasswordResponseModel>(
      path: _forgotPath,
      body: ForgotPasswordRequestModel(
        mobileNumber: mobileNumber.trim(),
      ).toJson(),
      fromJson: ForgotPasswordResponseModel.fromJson,
    );
  }

  @override
  Future<VerifyOtpResponseModel> verifyOtp({
    required String mobileNumber,
    required String otp,
  }) async {
    return _post<VerifyOtpResponseModel>(
      path: _verifyOtpPath,
      body: VerifyOtpRequestModel(
        mobileNumber: mobileNumber.trim(),
        otp: otp,
      ).toJson(),
      fromJson: VerifyOtpResponseModel.fromJson,
    );
  }

  @override
  Future<ResendOtpResponseModel> resendOtp({
    required String mobileNumber,
  }) async {
    return _post<ResendOtpResponseModel>(
      path: _resendOtpPath,
      body: ResendOtpRequestModel(mobileNumber: mobileNumber.trim()).toJson(),
      fromJson: ResendOtpResponseModel.fromJson,
    );
  }

  @override
  Future<ResetPasswordResponseModel> resetPassword({
    required String mobileNumber,
    required String newPassword,
  }) async {
    return _post<ResetPasswordResponseModel>(
      path: _resetPath,
      body: ResetPasswordRequestModel(
        mobileNumber: mobileNumber.trim(),
        newPassword: newPassword,
      ).toJson(),
      fromJson: ResetPasswordResponseModel.fromJson,
    );
  }

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  Future<T> _post<T>({
    required String path,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final agentDio = _agentDioOverride ?? _buildAgentDio();
      final response = await agentDio.post<Map<String, dynamic>>(
        path,
        data: body,
      );

      final data = response.data;
      if (data == null) {
        throw ServerException(
          dioException: DioException(
            requestOptions: RequestOptions(path: path),
            message: 'Empty response body',
          ),
          message: 'Malformed server response',
        );
      }

      return fromJson(data);
    } on DioException catch (e) {
      final apiMessage = _extractApiMessage(e.response?.data);
      throw ServerException(
        dioException: e,
        message: apiMessage ?? _dioMessageFor(e),
      );
    }
  }

  Dio _buildAgentDio() {
    return Dio(
      BaseOptions(
        baseUrl: env.agentApiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }

  String? _extractApiMessage(dynamic data) {
    if (data is Map && data['chMessage'] is Map) {
      final message = (data['chMessage'] as Map)['message'];
      if (message is String && message.isNotEmpty) return message;
    }
    return null;
  }

  String _dioMessageFor(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return 'Request timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'Network error. Please check your connection.';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.badResponse:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return 'Something went wrong. Please try again.';
    }
  }
}
