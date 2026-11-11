import 'package:citizenone_app/core/error/exception.dart';
import 'package:citizenone_app/core/error/failures.dart';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/session_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/change_password_remote_data_source.dart';
import '../datasources/forgot_password_remote_data_source.dart';
import '../mappers/session_value_mapper.dart';

/// Concrete auth repository — orchestrates the remote and local data
/// sources per the clean-architecture layering. Maps [DioException] /
/// [ServerException] to typed [Failure]s.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final ChangePasswordRemoteDataSource changePasswordDataSource;
  final ForgotPasswordRemoteDataSource forgotPasswordDataSource;

  bool _isAuthenticated = false;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.changePasswordDataSource,
    required this.forgotPasswordDataSource,
  });

  @override
  Future<Either<Failure, SessionEntity>> login({
    required String mobileNumber,
    required String password,
  }) async {
    try {
      final response = await remoteDataSource.login(
        mobileNumber: mobileNumber,
        password: password,
      );

      // The API's authoritative business-success indicator is
      // `chMessage.code == 'SUCCESS'` and `chMessage.isError == false`.
      // The `data` payload may legitimately be absent or have a
      // null `sessionToken` (e.g. `mustChangePassword: true`).
      if (!response.isSuccess) {
        return Left(
          ServerFailure(
            response.chMessage.message.isNotEmpty
                ? response.chMessage.message
                : 'Login failed. Please try again.',
          ),
        );
      }

      final session = mapSessionValueToEntity(response.value);

      // Only persist when we actually have a real session token. For
      // the `mustChangePassword: true` case the token comes back
      // null and we leave local storage alone — the token will be
      // issued by the change-password flow.
      if (session.hasToken) {
        await localDataSource.saveSession(session);
        await localDataSource.saveAgentMobileNumber(mobileNumber);
        _isAuthenticated = true;
      } else {
        _isAuthenticated = false;
      }

      return Right(session);
    } on ServerException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } on DioException catch (e) {
      return Left(
        e.response?.statusCode == 401
            ? const ServerFailure('Incorrect mobile number or password')
            : NetworkFailure(_humanizeDioError(e)),
      );
    } catch (_) {
      return const Left(
        ServerFailure('Something went wrong. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String mobileNumber,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await changePasswordDataSource.changePassword(
        mobileNumber: mobileNumber,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (!response.isSuccess) {
        return Left(
          ServerFailure(
            response.chMessage.message.isNotEmpty
                ? response.chMessage.message
                : 'Password change failed. Please try again.',
          ),
        );
      }

      return const Right(unit);
    } on ServerException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } on DioException catch (e) {
      return Left(
        e.response?.statusCode == 401
            ? const ServerFailure('Incorrect current password')
            : NetworkFailure(_humanizeDioError(e)),
      );
    } catch (_) {
      return const Left(
        ServerFailure('Something went wrong. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, ForgotPasswordStart>> forgotPassword({
    required String mobileNumber,
  }) async {
    try {
      final response = await forgotPasswordDataSource.forgotPassword(
        mobileNumber: mobileNumber,
      );

      if (!response.isSuccess) {
        return Left(
          ServerFailure(
            response.chMessage.message.isNotEmpty
                ? response.chMessage.message
                : 'Unable to send OTP. Please try again.',
          ),
        );
      }

      // The API may return either a String (legacy) or a structured
      // timer object under `data`. We only forward the structured
      // fields; the legacy String is intentionally ignored here
      // because the cubit will fall back to its sensible defaults.
      final timer = response.timerData;
      return Right(
        ForgotPasswordStart(
          otpExpiresInSeconds: timer?.otpExpiresInSeconds,
          resendCooldownSeconds: timer?.resendCooldownSeconds,
          maxAttempts: timer?.maxAttempts,
          attemptsRemaining: timer?.attemptsRemaining,
        ),
      );
    } on ServerException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } on DioException catch (e) {
      return Left(NetworkFailure(_humanizeDioError(e)));
    } catch (_) {
      return const Left(
        ServerFailure('Something went wrong. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyOtp({
    required String mobileNumber,
    required String otp,
  }) async {
    try {
      final response = await forgotPasswordDataSource.verifyOtp(
        mobileNumber: mobileNumber,
        otp: otp,
      );

      if (!response.isSuccess) {
        return Left(
          ServerFailure(
            response.chMessage.message.isNotEmpty
                ? response.chMessage.message
                : 'Invalid OTP. Please try again.',
            attemptsRemaining: response.attemptsRemaining,
          ),
        );
      }

      return const Right(unit);
    } on ServerException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } on DioException catch (e) {
      return Left(NetworkFailure(_humanizeDioError(e)));
    } catch (_) {
      return const Left(
        ServerFailure('Something went wrong. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, ResendOtpResult>> resendOtp({
    required String mobileNumber,
  }) async {
    try {
      final response = await forgotPasswordDataSource.resendOtp(
        mobileNumber: mobileNumber,
      );

      if (!response.isSuccess) {
        return Left(
          ServerFailure(
            response.chMessage.message.isNotEmpty
                ? response.chMessage.message
                : 'Unable to resend OTP. Please try again.',
          ),
        );
      }

      final data = response.data;
      return Right(
        ResendOtpResult(
          otpExpiresInSeconds: data?.otpExpiresInSeconds,
          resendCooldownSeconds: data?.resendCooldownSeconds,
          maxAttempts: data?.maxAttempts,
          attemptsRemaining: data?.attemptsRemaining,
        ),
      );
    } on ServerException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } on DioException catch (e) {
      return Left(NetworkFailure(_humanizeDioError(e)));
    } catch (_) {
      return const Left(
        ServerFailure('Something went wrong. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String mobileNumber,
    required String newPassword,
  }) async {
    try {
      final response = await forgotPasswordDataSource.resetPassword(
        mobileNumber: mobileNumber,
        newPassword: newPassword,
      );

      if (!response.isSuccess) {
        return Left(
          ServerFailure(
            response.chMessage.message.isNotEmpty
                ? response.chMessage.message
                : 'Password reset failed. Please try again.',
          ),
        );
      }

      return const Right(unit);
    } on ServerException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } on DioException catch (e) {
      return Left(NetworkFailure(_humanizeDioError(e)));
    } catch (_) {
      return const Left(
        ServerFailure('Something went wrong. Please try again.'),
      );
    }
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearSession();
    _isAuthenticated = false;
  }

  @override
  Future<bool> isAuthenticated() async {
    if (_isAuthenticated) return true;
    final session = await localDataSource.readSession();
    _isAuthenticated = session != null;
    return _isAuthenticated;
  }

  @override
  Future<bool> saveSession(SessionEntity session) async {
    final ok = await localDataSource.saveSession(session);
    if (ok) _isAuthenticated = true;
    return ok;
  }

  @override
  Future<SessionEntity?> readSession() => localDataSource.readSession();

  @override
  Future<void> clearSession() async {
    await localDataSource.clearSession();
    _isAuthenticated = false;
  }

  // ---------------------------------------------------------------------------
  // Mappers
  // ---------------------------------------------------------------------------

  Failure _mapExceptionToFailure(ServerException e) {
    final type = e.errorType;
    final message = e.message ?? 'Request failed. Please try again.';
    if (type == ErrorType.unauthorised) {
      return ServerFailure(message);
    }
    if (type == ErrorType.nointernet) {
      return NetworkFailure(message);
    }
    return ServerFailure(message);
  }

  String _humanizeDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return 'Request timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'Network error. Please check your connection.';
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      case DioExceptionType.badResponse:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return 'Something went wrong. Please try again.';
    }
  }
}
