import 'package:equatable/equatable.dart';
import 'user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthUnauthenticated extends AuthState {
  final String? message;

  const AuthUnauthenticated({this.message});

  @override
  List<Object?> get props => [message];
}

class AuthAuthenticated extends AuthState {
  final UserModel user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthError extends AuthState {
  final String errorMessage;

  const AuthError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class ForgotPasswordSuccess extends AuthState {
  final String email;

  const ForgotPasswordSuccess(this.email);

  @override
  List<Object?> get props => [email];
}

class ForgotUsernameSuccess extends AuthState {
  final String maskedUsername;

  const ForgotUsernameSuccess(this.maskedUsername);

  @override
  List<Object?> get props => [maskedUsername];
}
