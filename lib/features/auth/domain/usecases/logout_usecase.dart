import '../repositories/auth_repository.dart';

/// Single-responsibility use case for logout action per SKILL.md ISP.
class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<void> call() {
    return _repository.logout();
  }
}
