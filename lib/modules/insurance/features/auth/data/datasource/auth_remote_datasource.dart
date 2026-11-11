// =============================================================================
// AuthRemoteDatasource  —  DATA LAYER
// -----------------------------------------------------------------------------
// Mocked sign-in. Accepts any well-formed email + 8+ char password,
// rejects 'fail@bank.com' to demonstrate the failure path.
// =============================================================================

import '../../../../core/error/exceptions.dart';
import '../models/auth_session_model.dart';

abstract class AuthRemoteDatasource {
  Future<AuthSessionModel> signIn({
    required String email,
    required String password,
    required bool rememberMe,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  const AuthRemoteDatasourceImpl();

  @override
  Future<AuthSessionModel> signIn({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (email.toLowerCase() == 'fail@bank.com') {
      throw ServerException('Invalid email or password');
    }
    return AuthSessionModel(
      userId: 'usr_001',
      token: 'mock-jwt-${DateTime.now().millisecondsSinceEpoch}',
      issuedAt: DateTime.now(),
      rememberMe: rememberMe,
    );
  }
}
