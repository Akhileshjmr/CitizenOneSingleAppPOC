part of '../bloc/auth_bloc.dart';

enum AuthStatus { idle, submitting, success, failure }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.idle,
    this.session,
    this.errorMessage,
  });

  final AuthStatus status;
  final AuthSession? session;
  final String? errorMessage;

  bool get isSubmitting => status == AuthStatus.submitting;

  AuthState copyWith({
    AuthStatus? status,
    AuthSession? session,
    String? errorMessage,
    bool clearError = false,
  }) =>
      AuthState(
        status: status ?? this.status,
        session: session ?? this.session,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [status, session, errorMessage];
}
