import 'package:flutter_bloc/flutter_bloc.dart';
import '../module/app_module.dart';
import '../storage/local_storage.dart';
import 'auth_repository.dart';
import 'auth_state.dart';
import 'scoped_token.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;
  final List<AppModule>? modules;
  final LocalStorage? storage;

  AuthCubit(
    this.repository, {
    this.modules,
    this.storage,
  }) : super(const AuthUnauthenticated());

  Future<void> login({
    required String username,
    required String password,
  }) async {
    if (username.trim().isEmpty || password.trim().isEmpty) {
      emit(const AuthError('Username and password are required.'));
      return;
    }

    emit(const AuthLoading());

    try {
      final user = await repository.login(
        username: username,
        password: password,
      );
      if (isClosed) return;

      // Save token artifact to storage if available
      if (storage != null && user.token.isNotEmpty) {
        await storage!.setString('auth_token', user.token);
      }

      // Notify registered modules of session activation
      if (modules != null) {
        for (final module in modules!) {
          module.onSessionStateChanged(true, user);
        }
      }

      emit(AuthAuthenticated(user));
    } catch (e) {
      if (isClosed) return;
      emit(AuthError('Login failed: $e'));
    }
  }

  /// Exchanges global credentials for a short-lived scoped token for a target module.
  Future<ScopedToken> getScopedToken(String targetModule) {
    return repository.getScopedToken(targetModule);
  }

  Future<void> forgotPassword(String identifier) async {
    if (identifier.trim().isEmpty) {
      emit(const AuthError('Enter your username or email address.'));
      return;
    }

    emit(const AuthLoading());

    try {
      await repository.requestPasswordReset(identifier);
      if (isClosed) return;
      emit(ForgotPasswordSuccess(identifier));
    } catch (e) {
      if (isClosed) return;
      emit(AuthError('Failed to process reset request: $e'));
    }
  }

  Future<void> forgotUsername(String email) async {
    if (email.trim().isEmpty) {
      emit(const AuthError('Enter registered email address.'));
      return;
    }

    emit(const AuthLoading());

    try {
      final masked = await repository.requestRecoverUsername(email);
      if (isClosed) return;
      emit(ForgotUsernameSuccess(masked));
    } catch (e) {
      if (isClosed) return;
      emit(AuthError('Failed to recover username: $e'));
    }
  }

  /// Symmetrical session termination:
  /// Clears in-memory/local storage, notifies modules, and calls dispose() on all active modules.
  Future<void> logout() async {
    if (storage != null) {
      await storage!.clear();
    }

    if (modules != null) {
      for (final module in modules!) {
        module.onSessionStateChanged(false, null);
        await module.dispose();
      }
    }

    emit(const AuthUnauthenticated(message: 'Logged out successfully.'));
  }

  void resetState() {
    emit(const AuthUnauthenticated());
  }
}
