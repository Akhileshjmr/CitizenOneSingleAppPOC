import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.remote});
  final AuthRemoteDatasource remote;

  @override
  Future<Either<Failure, AuthSession>> signIn({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      final session = await remote.signIn(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );
      return Right(session);
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return const Left(AuthFailure());
    }
  }
}
