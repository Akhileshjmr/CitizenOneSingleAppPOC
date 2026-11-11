import 'package:citizenone_app/app/env/app_env.dart';
import 'package:citizenone_app/core/error/exception.dart';
import 'package:citizenone_app/core/network/dio_client.dart';
import 'package:dio/dio.dart';

import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

/// Remote data source for the agent user service authentication endpoints.
///
/// Hits the configured [AppEnv.agentApiBaseUrl] and follows the
/// `POST /session/create` contract documented in the Agent Login API
/// integration guide. Throws [ServerException] (or a plain [Exception]
/// wrapping a user-friendly message) on failure.
abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String mobileNumber,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  static const String _loginPath = '/session/login';

  final DioClient apiClient;
  final AppEnv env;
  final Dio? _agentDioOverride;

  AuthRemoteDataSourceImpl({
    required this.apiClient,
    required this.env,
    Dio? agentDioOverride,
  }) : _agentDioOverride = agentDioOverride;

  @override
  Future<LoginResponseModel> login({
    required String mobileNumber,
    required String password,
  }) async {
    try {
      final request = LoginRequestModel(
        mobileNumber: mobileNumber.trim(),
        password: password,
      );

      // Use a private Dio configured for the agent API so we don't
      // contaminate the primary app DioClient with a different base URL.
      final agentDio = _agentDioOverride ?? _buildAgentDio();

      final response = await agentDio.post<Map<String, dynamic>>(
        _loginPath,
        data: request.toJson(),
      );

      final data = response.data;
      if (data == null) {
        throw ServerException(
          dioException: DioException(
            requestOptions: RequestOptions(path: _loginPath),
            message: 'Empty response body',
          ),
          message: 'Malformed server response',
        );
      }

      return LoginResponseModel.fromJson(data);
    } on DioException catch (e) {
      final apiMessage = _extractApiMessage(e.response?.data);
      final status = e.response?.statusCode;

      if (status == 401) {
        throw ServerException(
          dioException: e,
          message: apiMessage ?? 'Incorrect mobile number or password',
        );
      }

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
        // Treat 401 as a normal response so we can surface a typed
        // error from the data layer rather than having Dio throw a
        // generic DioException without a body.
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
