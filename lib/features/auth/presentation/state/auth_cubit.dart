import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/core/error/failures.dart';
import 'package:citizenone_app/features/auth/domain/entities/session_entity.dart';
import 'package:citizenone_app/features/auth/domain/entities/user_role.dart';
import 'package:citizenone_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:citizenone_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:citizenone_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:citizenone_app/features/auth/presentation/state/auth_state.dart';
import 'package:dartz/dartz.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final AuthRepository _repository;

  /// Notified whenever this cubit clears its session (logout). Used to
  /// reset the global [SessionCubit] without `features/auth` depending
  /// on `core/session` — DI wires this to `SessionCubit.endSession`.
  final void Function()? onSessionCleared;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    AuthRepository? repository,
    this.onSessionCleared,
  }) : _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       _repository = repository ?? _MissingAuthRepository(),
       super(const AuthState());

  void setRole(UserRole role) {
    emit(state.copyWith(selectedRole: role));
  }

  void setWorkContext(String context) {
    emit(state.copyWith(workContext: context));
  }

  void setPartner(String? name, IconData? icon, String? type) {
    emit(
      state.copyWith(
        selectedPartner: name,
        partnerIcon: icon,
        partnerType: type,
        workContext: 'Partner', // Keep 'Partner' context to keep toggle active
      ),
    );
  }

  void clearPartner() {
    emit(
      state.copyWith(
        selectedPartner: null,
        partnerIcon: null,
        partnerType: null,
        workContext: 'Partner',
      ),
    );
  }

  /// Performs the agent login. Emits [AuthLoginStatus.loading] while in
  /// flight and [AuthLoginStatus.success] / [AuthLoginStatus.failure]
  /// when finished. Prevents concurrent submissions.
  ///
  /// `isAuthenticated` is only set to `true` when the API returns a
  /// real session token. For the `mustChangePassword: true` case,
  /// the cubit still emits `success` (the API reported a successful
  /// business outcome) but `isAuthenticated` stays `false` and
  /// `mustChangePassword` is propagated so the LoginScreen can
  /// route the agent to the change-password flow.
  Future<void> login({
    required String mobileNumber,
    required String password,
  }) async {
    if (state.loginStatus == AuthLoginStatus.loading) {
      return; // Block re-entrant calls.
    }

    emit(
      state.copyWith(
        loginStatus: AuthLoginStatus.loading,
        loginErrorMessage: null,
        mustChangePassword: false,
      ),
    );

    final result = await _loginUseCase(
      mobileNumber: mobileNumber,
      password: password,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          loginStatus: AuthLoginStatus.failure,
          loginErrorMessage: failure.message,
          isAuthenticated: false,
          mustChangePassword: false,
          session: null,
        ),
      ),
      (session) => emit(
        state.copyWith(
          loginStatus: AuthLoginStatus.success,
          loginErrorMessage: null,
          // `isAuthenticated` is only true when the API actually
          // issued a session token.
          isAuthenticated: session.hasToken,
          // Preserve `mustChangePassword` so the LoginScreen can
          // route the agent to the change-password flow. The flag
          // is also available on `session.mustChangePassword`; we
          // surface it at the state level for convenient access.
          mustChangePassword: session.mustChangePassword,
          session: session,
        ),
      ),
    );
  }

  /// Clears any transient login error (used when the user edits the
  /// form so the previous error message is dismissed).
  void clearLoginError() {
    if (state.loginErrorMessage == null &&
        state.loginStatus != AuthLoginStatus.loading) {
      return;
    }
    emit(
      state.copyWith(
        loginStatus: AuthLoginStatus.initial,
        loginErrorMessage: null,
      ),
    );
  }

  /// Fallback for simple login without credentials in some test scenarios.
  void loginBypass() {
    emit(
      state.copyWith(
        isAuthenticated: true,
        loginStatus: AuthLoginStatus.success,
        mustChangePassword: false,
      ),
    );
  }

  /// Hydrate the active session from local storage (if any). Used at
  /// app start so the user does not have to log in on every cold start.
  Future<void> bootstrapSession() async {
    final session = await _repository.readSession();
    if (session == null) return;
    emit(
      state.copyWith(
        isAuthenticated: session.hasToken,
        session: session,
        mustChangePassword: session.mustChangePassword,
      ),
    );
  }

  Future<void> logout() async {
    await _logoutUseCase();
    onSessionCleared?.call();
    emit(
      state.copyWith(
        isAuthenticated: false,
        loginStatus: AuthLoginStatus.initial,
        loginErrorMessage: null,
        session: null,
        mustChangePassword: false,
        workContext: 'CitizenOne',
        selectedPartner: null,
        partnerIcon: null,
        partnerType: null,
      ),
    );
  }
}

/// Sentinel used when the cubit is constructed without an explicit
/// [AuthRepository] (e.g. in unit tests that mock the use case).
/// Calling [readSession] on it throws — tests should never reach that
/// path because the use case is mocked.
class _MissingAuthRepository implements AuthRepository {
  @override
  Future<Either<Failure, SessionEntity>> login({
    required String mobileNumber,
    required String password,
  }) => throw UnsupportedError('AuthRepository not provided');

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String mobileNumber,
    required String currentPassword,
    required String newPassword,
  }) => throw UnsupportedError('AuthRepository not provided');

  @override
  Future<Either<Failure, ForgotPasswordStart>> forgotPassword({
    required String mobileNumber,
  }) => throw UnsupportedError('AuthRepository not provided');

  @override
  Future<Either<Failure, Unit>> verifyOtp({
    required String mobileNumber,
    required String otp,
  }) => throw UnsupportedError('AuthRepository not provided');

  @override
  Future<Either<Failure, ResendOtpResult>> resendOtp({
    required String mobileNumber,
  }) => throw UnsupportedError('AuthRepository not provided');

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String mobileNumber,
    required String newPassword,
  }) => throw UnsupportedError('AuthRepository not provided');

  @override
  Future<bool> isAuthenticated() async => false;

  @override
  Future<void> logout() async {}

  @override
  Future<SessionEntity?> readSession() =>
      throw UnsupportedError('AuthRepository not provided');

  @override
  Future<bool> saveSession(SessionEntity session) =>
      throw UnsupportedError('AuthRepository not provided');

  @override
  Future<void> clearSession() async {}
}
