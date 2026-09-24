import 'auth_api.dart';
import 'user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login({
    required String username,
    required String password,
  });

  Future<void> requestPasswordReset(String emailOrUsername);

  Future<String> requestRecoverUsername(String email);
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
}
