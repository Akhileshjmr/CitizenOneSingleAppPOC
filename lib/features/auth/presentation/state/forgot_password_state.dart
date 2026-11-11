import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_state.freezed.dart';

/// Distinct UI phases for each step in the forgot-password flow.
///
/// The flow runs:
///   Forgot → Verify OTP → (Resend OTP) → Reset Password → Success
///
/// `status` reflects the *current* in-flight step so the UI can
/// disable the right button / show the right loading spinner without
/// juggling four booleans.
enum ForgotPasswordStatus {
  /// Initial idle state (no request in flight).
  initial,

  /// Forgot-Password API in flight.
  forgotLoading,

  /// Forgot-Password API succeeded.
  forgotSuccess,

  /// Forgot-Password API failed.
  forgotFailure,

  /// Verify-OTP API in flight.
  verifyLoading,

  /// Verify-OTP API succeeded.
  verifySuccess,

  /// Verify-OTP API failed.
  verifyFailure,

  /// Resend-OTP API in flight.
  resendLoading,

  /// Resend-OTP API succeeded.
  resendSuccess,

  /// Resend-OTP API failed.
  resendFailure,

  /// Reset-Password API in flight.
  resetLoading,

  /// Reset-Password API succeeded.
  resetSuccess,

  /// Reset-Password API failed.
  resetFailure,
}

@freezed
class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    /// Mobile number carried from the Forgot-Password screen and
    /// re-used by the Verify-OTP, Resend-OTP and Reset-Password calls.
    @Default('') String mobileNumber,

    /// 6-digit OTP the user typed. Mirrored from the Pinput controller
    /// so the cubit knows when the field is complete.
    @Default('') String otp,

    /// Resend-OTP cooldown (seconds remaining). Counts down every
    /// second while > 0. When this hits 0 the resend button is
    /// enabled. Distinct from [otpExpiresInSeconds] — this only gates
    /// the "Resend OTP" button.
    @Default(0) int resendCooldown,

    /// OTP/session expiration countdown (seconds remaining), seeded
    /// from the API's `otpExpiresInSeconds`. Displayed as the timer on
    /// the OTP screen. Counts down independently of [resendCooldown].
    @Default(0) int otpExpiresInSeconds,

    /// Attempts remaining for the current OTP. The API may return this
    /// on the resend response.
    @Default(5) int attemptsRemaining,

    /// Maximum attempts allowed (reported by the API when available).
    @Default(5) int maxAttempts,

    /// Latest human-readable error message.
    String? errorMessage,

    /// The active flow phase.
    @Default(ForgotPasswordStatus.initial) ForgotPasswordStatus status,
  }) = _ForgotPasswordState;
}
