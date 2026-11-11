import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_session.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthSession>> signIn({
    required String email,
    required String password,
    required bool rememberMe,
  });
}
