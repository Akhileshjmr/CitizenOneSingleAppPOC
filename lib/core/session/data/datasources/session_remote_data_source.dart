import 'package:citizenone_app/app/env/app_env.dart';
import 'package:citizenone_app/core/error/exception.dart';
import 'package:citizenone_app/features/auth/data/models/login_response_model.dart';
import 'package:dio/dio.dart';

/// Remote data source for the agent user service session-refresh
/// endpoint.
///
/// **No backend contract has been confirmed for this endpoint.** This
/// implements a best-guess contract — `POST /session/refresh` with the
/// current token in `X-Session-Token`, no body, response sharing the
/// same envelope as `POST /session/login` — isolated here so it is a
/// one-place fix once the real contract is confirmed.
abstract class SessionRemoteDataSource {
  Future<LoginResponseModel> refreshSession({required String sessionToken});
}

class SessionRemoteDataSourceImpl implements SessionRemoteDataSource {
  static const String _path = '/session/refresh';
  static const String _sessionHeader = 'X-Session-Token';

  final AppEnv env;
  final Dio? _agentDioOverride;

  SessionRemoteDataSourceImpl({required this.env, Dio? agentDioOverride})
    : _agentDioOverride = agentDioOverride;

  @override
  Future<LoginResponseModel> refreshSession({
    required String sessionToken,
  }) async {
    try {
      final agentDio = _agentDioOverride ?? _buildAgentDio();

      final response = await agentDio.post<Map<String, dynamic>>(
        _path,
        options: Options(headers: {_sessionHeader: sessionToken}),
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

      return LoginResponseModel.fromJson(data);
    } on DioException catch (e) {
      final apiMessage = _extractApiMessage(e.response?.data);
      throw ServerException(dioException: e, message: apiMessage ?? _dioMessageFor(e));
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
        // Treat 401 as a normal response so a failed refresh (session
        // already invalid) surfaces as a typed result rather than a
        // raw DioException — matches the login/change-password Dios.
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
