import 'package:citizenone_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';

import '../entities/session_entity.dart';
import '../repositories/auth_repository.dart';

/// Single-responsibility use case for the agent login action.
/// Per SKILL.md ISP, this wraps the repository call so the cubit does
/// not have to know about the repository's `Either<Failure, T>` shape.
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<Failure, SessionEntity>> call({
    required String mobileNumber,
    required String password,
  }) {
    return _repository.login(mobileNumber: mobileNumber, password: password);
  }
}
