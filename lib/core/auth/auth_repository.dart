import 'auth_api.dart';
import 'scoped_token.dart';
import 'user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login({
    required String username,
    required String password,
  });

  Future<void> requestPasswordReset(String emailOrUsername);

  Future<String> requestRecoverUsername(String email);

  /// Exchanges root authentication credentials for a short-lived token scoped to a specific module.
  Future<ScopedToken> getScopedToken(String targetModule);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi api;

  AuthRepositoryImpl(this.api);

  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) {
    return api.login(username: username, password: password);
  }

  @override
  Future<void> requestPasswordReset(String emailOrUsername) {
    return api.requestPasswordReset(emailOrUsername);
  }

  @override
  Future<String> requestRecoverUsername(String email) {
    return api.requestRecoverUsername(email);
  }

  @override
  Future<ScopedToken> getScopedToken(String targetModule) async {
    final now = DateTime.now();
    return ScopedToken(
      token: 'scoped-jwt-$targetModule-${now.millisecondsSinceEpoch}',
      targetModule: targetModule,
      issuedAt: now,
      expiresAt: now.add(const Duration(minutes: 15)),
    );
  }
}
