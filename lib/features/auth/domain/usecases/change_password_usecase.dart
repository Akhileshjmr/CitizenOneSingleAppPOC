import 'package:citizenone_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';

import '../repositories/auth_repository.dart';

/// Single-responsibility use case for the first-time agent password
/// change. Wraps the repository call so the cubit does not need to
/// know about the `Either<Failure, T>` shape.
class ChangePasswordUseCase {
  final AuthRepository _repository;

  ChangePasswordUseCase(this._repository);

  Future<Either<Failure, Unit>> call({
    required String mobileNumber,
    required String currentPassword,
    required String newPassword,
  }) {
    return _repository.changePassword(
      mobileNumber: mobileNumber,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
