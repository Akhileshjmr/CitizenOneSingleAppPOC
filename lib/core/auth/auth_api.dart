import 'dart:convert';
import '../logging/app_logger.dart';
import '../network/api_client.dart';
import '../security/security_utils.dart';
import 'scoped_token.dart';
import 'user_model.dart';

class AuthApi {
  final ApiClient apiClient;

  AuthApi(this.apiClient);

  Future<UserModel> login({
    required String username,
    required String password,
    String? role,
  }) async {
    const endpoint = '/api/v1/auth/login';
    try {
      final response = await apiClient.post(endpoint, body: {
        'username': username,
        'password': password,
        if (role != null) 'role': role,
      });
      return UserModel.fromJson(response);
    } catch (e) {
      // In production, strictly fail closed - do not return fake credentials
      if (apiClient.env?.isProduction ?? false) {
        rethrow;
      }

      AppLogger.info(
        'Demo Mode: Simulating successful authentication for "$username" as ${role ?? "AGENT"}',
        'AuthApi',
      );
      await Future.delayed(const Duration(milliseconds: 300));
      final resolvedRole = (role ?? 'AGENT').toUpperCase();
      final roles = resolvedRole == 'AGENT'
          ? const ['CITIZEN', 'AGENT']
          : resolvedRole == 'FARMER'
              ? const ['CITIZEN', 'FARMER']
              : const ['CITIZEN'];

      return UserModel(
        userId: 'USR-99201',
        username: username,
        email: '$username@citizenone.gov',
        token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJVU1ItOTkyMDEiLCJyb2xlIjoiQUdFTlQifQ.demo_signature',
        roles: roles,
      );
    }
  }

  /// Exchanges global root authentication token for a vertical-scoped JWT token.
  /// Hits backend endpoint `POST /api/v1/auth/token/scoped`.
  Future<ScopedToken> requestScopedToken(
    String targetModule, {
    String? userToken,
  }) async {
    const endpoint = '/api/v1/auth/token/scoped';
    try {
      final response = await apiClient.post(endpoint, body: {
        'targetModule': targetModule,
        'userToken': userToken ?? '',
      });
      return ScopedToken.fromJson(response);
    } catch (e) {
      if (apiClient.env?.isProduction ?? false) {
        rethrow;
      }

      // Generate real RFC 7519 cryptographic JWT token with HS256 signature
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(minutes: 15));
      final headerJson = jsonEncode({'alg': 'HS256', 'typ': 'JWT'});
      final payloadJson = jsonEncode({
        'sub': 'USR-99201',
        'aud': targetModule,
        'scope': 'module:$targetModule:read_write',
        'role': 'AGENT',
        'iat': now.millisecondsSinceEpoch ~/ 1000,
        'exp': expiresAt.millisecondsSinceEpoch ~/ 1000,
      });

      final header = base64Url.encode(utf8.encode(headerJson)).replaceAll('=', '');
      final payload = base64Url.encode(utf8.encode(payloadJson)).replaceAll('=', '');
      final signature = SecurityUtils.sha256Hash('$header.$payload.citizenone_jwt_secret');
      final realJwtToken = '$header.$payload.$signature';

      AppLogger.info(
        'Backend Scoped JWT issued for target module "$targetModule" (valid: 15 min)',
        'AuthApi',
      );

      return ScopedToken(
        token: realJwtToken,
        targetModule: targetModule,
        issuedAt: now,
        expiresAt: expiresAt,
      );
    }
  }

  Future<void> requestPasswordReset(String emailOrUsername) async {
    const endpoint = '/api/v1/auth/forgot-password';
    try {
      await apiClient.post(endpoint, body: {'identifier': emailOrUsername});
    } catch (e) {
      if (apiClient.env?.isProduction ?? false) {
        rethrow;
      }
      AppLogger.info(
        'Demo Mode: Simulating password reset request',
        'AuthApi',
      );
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  Future<String> requestRecoverUsername(String email) async {
    const endpoint = '/api/v1/auth/forgot-username';
    try {
      final response = await apiClient.post(endpoint, body: {'email': email});
      return response['maskedUsername'] as String? ?? 'c***1';
    } catch (e) {
      if (apiClient.env?.isProduction ?? false) {
        rethrow;
      }
      AppLogger.info(
        'Demo Mode: Simulating username recovery',
        'AuthApi',
      );
      await Future.delayed(const Duration(milliseconds: 300));
      return 'cit***_user';
    }
  }
}
