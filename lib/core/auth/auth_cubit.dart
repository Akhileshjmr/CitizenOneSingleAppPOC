import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;

  AuthCubit(this.repository) : super(const AuthUnauthenticated());

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
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError('Login failed: $e'));
    }
  }

  Future<void> forgotPassword(String identifier) async {
    if (identifier.trim().isEmpty) {
      emit(const AuthError('Enter your username or email address.'));
      return;
    }

    emit(const AuthLoading());

    try {
      await repository.requestPasswordReset(identifier);
      emit(ForgotPasswordSuccess(identifier));
    } catch (e) {
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
      emit(ForgotUsernameSuccess(masked));
    } catch (e) {
      emit(AuthError('Failed to recover username: $e'));
    }
  }

  void logout() {
    emit(const AuthUnauthenticated(message: 'Logged out successfully.'));
  }

  void resetState() {
    emit(const AuthUnauthenticated());
  }
}
