import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/session_entity.dart';

/// Local storage for the active agent session.
///
/// The session token/metadata is sensitive and lives in
/// [FlutterSecureStorage]. The legacy `loginResponse` mobile-number
/// cache stays in [SharedPreferences] for consistency with the
/// existing [KycLocalDataSource], which already reads that key from
/// the same store.
abstract class AuthLocalDataSource {
  Future<bool> saveSession(SessionEntity session);
  Future<SessionEntity?> readSession();
  Future<void> clearSession();

  /// Persists the logged-in agent's mobile number in the legacy
  /// `loginResponse` shape that [KycLocalDataSourceImpl] (and, by
  /// extension, [GetAgentMobileUseCase]) already reads. This is the
  /// single write site for that key — before this, nothing populated
  /// it and every reader silently fell back to a hardcoded stub number.
  Future<void> saveAgentMobileNumber(String mobileNumber);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _sessionKey = 'agentSession';

  /// Legacy key shared with `KycLocalDataSourceImpl.getAgentMobileNumber()`
  /// — kept in sync here so every feature that needs the logged-in
  /// agent's mobile number (KYC, Insurance, Change Password) reads the
  /// same source of truth via the existing `GetAgentMobileUseCase`.
  static const String _loginResponseKey = 'loginResponse';

  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({
    required this.secureStorage,
    required this.sharedPreferences,
  });

  @override
  Future<void> saveAgentMobileNumber(String mobileNumber) async {
    final trimmed = mobileNumber.trim();
    if (trimmed.isEmpty) return;
    await sharedPreferences.setString(
      _loginResponseKey,
      jsonEncode({
        'loginUserInfo': {'mobileno': trimmed},
      }),
    );
  }

  @override
  Future<bool> saveSession(SessionEntity session) async {
    final payload = jsonEncode({
      'sessionToken': session.sessionToken,
      'issuedAt': session.issuedAt?.toIso8601String(),
      'expiresAt': session.expiresAt?.toIso8601String(),
      'validitySeconds': session.validitySeconds,
      'mustChangePassword': session.mustChangePassword,
      'userType': session.userType,
    });
    try {
      await secureStorage.write(key: _sessionKey, value: payload);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<SessionEntity?> readSession() async {
    final raw = await secureStorage.read(key: _sessionKey);
    if (raw == null || raw.isEmpty) return null;

    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final token = data['sessionToken'] as String?;
      if (token == null || token.isEmpty) return null;

      return SessionEntity(
        sessionToken: token,
        issuedAt: data['issuedAt'] == null
            ? null
            : DateTime.tryParse(data['issuedAt'] as String),
        expiresAt: data['expiresAt'] == null
            ? null
            : DateTime.tryParse(data['expiresAt'] as String),
        validitySeconds: data['validitySeconds'] as int?,
        mustChangePassword: data['mustChangePassword'] as bool? ?? false,
        userType: data['userType'] as String?,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearSession() async {
    await secureStorage.delete(key: _sessionKey);
    // Prevent the signed-out agent's mobile number from leaking into
    // whichever agent logs in next on this device.
    await sharedPreferences.remove(_loginResponseKey);
  }
}
