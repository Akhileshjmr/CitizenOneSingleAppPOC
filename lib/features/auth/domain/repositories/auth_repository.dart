import 'package:citizenone_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';

import '../entities/session_entity.dart';

/// Abstract auth repository interface per SKILL.md DIP.
///
/// Returns [SessionEntity] on success, [Failure] on failure — mirrors
/// the `Either<Failure, T>` contract already used by the KYC feature.
abstract class AuthRepository {
  Future<Either<Failure, SessionEntity>> login({
    required String mobileNumber,
    required String password,
  });

  /// Forces a first-time password change for the agent.
  ///
  /// Returns `Right(unit)` on success; `Left(ServerFailure)` when the
  /// API reports a business failure (e.g. incorrect current password
  /// or a weak new password); `Left(NetworkFailure)` on transport
  /// errors.
  Future<Either<Failure, Unit>> changePassword({
    required String mobileNumber,
    required String currentPassword,
    required String newPassword,
  });

  /// Sends the user's mobile number to start the forgot-password flow.
  /// Returns `Right(ForgotPasswordStart)` on success so the caller can
  /// seed the OTP timer / cooldown / attempts counters from the API
  /// response. The OTP delivery itself is reported via the API's
  /// `chMessage`.
  Future<Either<Failure, ForgotPasswordStart>> forgotPassword({
    required String mobileNumber,
  });

  /// Verifies the 6-digit OTP the user entered.
  Future<Either<Failure, Unit>> verifyOtp({
    required String mobileNumber,
    required String otp,
  });

  /// Resends the OTP. The full response (including cooldown / attempts
  /// data) is returned so the cubit can drive the timer UI.
  Future<Either<Failure, ResendOtpResult>> resendOtp({
    required String mobileNumber,
  });

  /// Resets the password after the OTP has been verified.
  ///
  /// IMPORTANT: The Reset Password API does not require the OTP — the
  /// OTP has already been verified through [verifyOtp] in the same
  /// session. We only send the new password and the mobile number.
  Future<Either<Failure, Unit>> resetPassword({
    required String mobileNumber,
    required String newPassword,
  });

  Future<void> logout();

  Future<bool> isAuthenticated();

  /// Persist the active session locally. Returns true on success.
  Future<bool> saveSession(SessionEntity session);

  /// Returns the currently stored session, or null if no active session.
  Future<SessionEntity?> readSession();

  /// Clears the stored session.
  Future<void> clearSession();
}

/// Result of a successful resend-OTP call. Carries the timer / cooldown
/// values reported by the API so the UI can drive the resend button.
class ResendOtpResult {
  final int? otpExpiresInSeconds;
  final int? resendCooldownSeconds;
  final int? maxAttempts;
  final int? attemptsRemaining;

  const ResendOtpResult({
    this.otpExpiresInSeconds,
    this.resendCooldownSeconds,
    this.maxAttempts,
    this.attemptsRemaining,
  });
}

/// Result of a successful forgot-password call. Carries the timer /
/// cooldown values reported by the API so the UI can initialise the
/// OTP screen directly from the response.
class ForgotPasswordStart {
  final int? otpExpiresInSeconds;
  final int? resendCooldownSeconds;
  final int? maxAttempts;
  final int? attemptsRemaining;

  const ForgotPasswordStart({
    this.otpExpiresInSeconds,
    this.resendCooldownSeconds,
    this.maxAttempts,
    this.attemptsRemaining,
  });
}
