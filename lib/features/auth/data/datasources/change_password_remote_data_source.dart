import 'package:citizenone_app/app/env/app_env.dart';
import 'package:citizenone_app/core/error/exception.dart';
import 'package:citizenone_app/core/network/dio_client.dart';
import 'package:citizenone_app/core/network/session_interceptors.dart';
import 'package:dio/dio.dart';

import '../models/change_password_request_model.dart';
import '../models/change_password_response_model.dart';

/// Remote data source for the agent user service
/// `POST /password/change` endpoint.
///
/// Attaches the active session token via the shared session
/// interceptor (see [buildSessionInterceptor]) rather than reading it
/// manually per call. Throws [ServerException] (or a plain [Exception]
/// wrapping a user-friendly message) on failure.
abstract class ChangePasswordRemoteDataSource {
  Future<ChangePasswordResponseModel> changePassword({
    required String mobileNumber,
    required String currentPassword,
    required String newPassword,
  });
}

class ChangePasswordRemoteDataSourceImpl
    implements ChangePasswordRemoteDataSource {
  static const String _path = '/password/change';

  final DioClient apiClient;
  final AppEnv env;
  final String? Function()? sessionToken;
  final Dio? _agentDioOverride;

  ChangePasswordRemoteDataSourceImpl({
    required this.apiClient,
    required this.env,
    this.sessionToken,
    Dio? agentDioOverride,
  }) : _agentDioOverride = agentDioOverride;

  @override
  Future<ChangePasswordResponseModel> changePassword({
    required String mobileNumber,
    required String currentPassword,
    required String newPassword,
  }) async {
    final request = ChangePasswordRequestModel(
      mobileNumber: mobileNumber.trim(),
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    try {
      final agentDio = _agentDioOverride ?? _buildAgentDio();
      final response = await agentDio.post<Map<String, dynamic>>(
        _path,
        data: request.toJson(),
      );

      final data = response.data;
      if (data == null) {
        throw ServerException(
          dioException: DioException(
            requestOptions: RequestOptions(path: _path),
            message: 'Empty response body',
          ),
          message: 'Malformed server response',
        );
      }

      return ChangePasswordResponseModel.fromJson(data);
    } on DioException catch (e) {
      final apiMessage = _extractApiMessage(e.response?.data);
      throw ServerException(
        dioException: e,
        message: apiMessage ?? _dioMessageFor(e),
      );
    }
  }

  Dio _buildAgentDio() {
    final dio = Dio(
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
    // No `onPossibleExpiry` here — a wrong *current* password is a
    // normal 401 for this endpoint, already handled by
    // AuthRepositoryImpl as "Incorrect current password", and must
    // never be misread as a global session expiry.
    dio.interceptors.add(buildSessionInterceptor(getToken: sessionToken));
    return dio;
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
