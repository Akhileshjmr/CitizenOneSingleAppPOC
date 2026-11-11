import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/usecases/sign_in.dart';

part 'auth_event.dart';
part '../states/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required SignIn signIn})
      : _signIn = signIn,
        super(const AuthState()) {
    on<AuthSignInRequested>(_onSignIn);
    on<AuthErrorCleared>(
        (_, emit) => emit(state.copyWith(clearError: true)));
  }

  final SignIn _signIn;

  Future<void> _onSignIn(
      AuthSignInRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.submitting, clearError: true));
    final result = await _signIn(SignInParams(
      email: event.email,
      password: event.password,
      rememberMe: event.rememberMe,
    ));
    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: failure.message,
      )),
      (session) => emit(state.copyWith(
        status: AuthStatus.success,
        session: session,
      )),
    );
  }
}
