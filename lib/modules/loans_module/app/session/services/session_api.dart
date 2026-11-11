import 'package:dio/dio.dart';

import '../../data/remote/api_service/init_api_service.dart';

class SessionApi {
  // Existing methods remain unchanged
  // New method to refresh session token
  Future<Response<Map<String, dynamic>>> refreshSession({
    String? sessionToken,
  }) async {
    final response = await _buildDio(
      sessionToken: sessionToken,
    ).post<Map<String, dynamic>>(
      'loan-service/customer/refresh-session',
      data: <String, dynamic>{},
      options: Options(
        headers: const <String, dynamic>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ),
    );
    return response;
  }

  static String sessionSecureKey = '';
  static const String _createSessionPath =
      'loan-service/customer/create-session';
  static const String _deleteSessionPath =
      'loan-service/customer/delete-session';

  Dio _buildDio({String? sessionToken}) {
    return Dio(
      BaseOptions(
        baseUrl: APIService.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: <String, dynamic>{
          'x-api-key': 'x-api-key',
          if (sessionToken != null && sessionToken.isNotEmpty)
            'X-Session-Token': sessionToken,
        },
      ),
    );
  }

  Future<Response<Map<String, dynamic>>> createSession() async {
    final response = await _buildDio().post<Map<String, dynamic>>(
      _createSessionPath,
      data: <String, dynamic>{'reqSecureKey': sessionSecureKey},
      options: Options(
        headers: const <String, dynamic>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ),
    );

    return response;
  }

  /// Deletes the current session.
  ///
  /// The API expects only the session token to be sent via the
  /// `X-Session-Token` header. No request body is required.
  Future<void> deleteSession({String? sessionToken}) async {
    await _buildDio(sessionToken: sessionToken).delete<void>(
      _deleteSessionPath,
      options: Options(
        headers: const <String, dynamic>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ),
    );
  }
}
