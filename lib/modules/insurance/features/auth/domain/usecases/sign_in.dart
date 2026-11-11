import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/shared/usecase.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class SignInParams extends Equatable {
  const SignInParams({
    required this.email,
    required this.password,
    required this.rememberMe,
  });
  final String email;
  final String password;
  final bool rememberMe;

  @override
  List<Object?> get props => [email, password, rememberMe];
}

class SignIn implements UseCase<AuthSession, SignInParams> {
  SignIn(this._repo);
  final AuthRepository _repo;

  @override
  Future<Either<Failure, AuthSession>> call(SignInParams params) =>
      _repo.signIn(
        email: params.email,
        password: params.password,
        rememberMe: params.rememberMe,
      );
}
