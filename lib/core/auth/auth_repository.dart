import 'auth_api.dart';
import 'scoped_token.dart';
import 'user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login({
    required String username,
    required String password,
    String? role,
  });

  Future<void> requestPasswordReset(String emailOrUsername);

  Future<String> requestRecoverUsername(String email);

  /// Exchanges root authentication credentials for a short-lived token scoped to a specific module.
  Future<ScopedToken> getScopedToken(String targetModule, {String? userToken});
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi api;

  AuthRepositoryImpl(this.api);

  @override
  Future<UserModel> login({
    required String username,
    required String password,
    String? role,
  }) {
    return api.login(username: username, password: password, role: role);
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
  Future<ScopedToken> getScopedToken(String targetModule, {String? userToken}) {
    return api.requestScopedToken(targetModule, userToken: userToken);
  }
}
