import 'dart:async';

import 'package:citizenone_app/core/error/failures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import 'forgot_password_state.dart';

/// Cubit that drives the complete forgot-password flow:
///   Forgot → Verify OTP → (Resend OTP) → Reset Password → Success
///
/// A single cubit is used (rather than one per screen) so the mobile
/// number, OTP, and resend-timer state flow naturally between screens
/// and the OTP never has to be re-typed.
///
/// Each public method emits a dedicated `*Loading` state on entry and
/// a `*Success` / `*Failure` state on completion. The UI `BlocListener`
/// reacts to these state changes to drive navigation, loading spinners
/// and snackbars.
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository _repository;

  /// 1-second timer that ticks down the resend cooldown.
  Timer? _cooldownTimer;

  /// 1-second timer that ticks down the OTP/session expiration.
  Timer? _otpExpiryTimer;

  ForgotPasswordCubit({required AuthRepository repository})
    : _repository = repository,
      super(const ForgotPasswordState());

  // ---------------------------------------------------------------------------
  // Mobile number / OTP setters (called by the screens as the user types).
  // ---------------------------------------------------------------------------

  /// Stores the mobile number. The OTP screen will read this back to
  /// make sure the user never has to re-type it.
  void setMobileNumber(String value) {
    if (value == state.mobileNumber) return;
    emit(state.copyWith(mobileNumber: value, errorMessage: null));
  }

  /// Stores the 6-digit OTP. Used by the OTP screen to drive the
  /// "Verify OTP" button enable state.
  void setOtp(String value) {
    if (value == state.otp) return;
    emit(state.copyWith(otp: value, errorMessage: null));
  }

  // ---------------------------------------------------------------------------
  // Forgot password
  // ---------------------------------------------------------------------------

  /// Calls `POST /password/forgot`. On success, starts a 90s resend
  /// cooldown so the user can't spam the API.
  Future<void> submitForgot() async {
    if (state.status == ForgotPasswordStatus.forgotLoading) return;
    if (state.mobileNumber.trim().isEmpty) return;

    emit(
      state.copyWith(
        status: ForgotPasswordStatus.forgotLoading,
        errorMessage: null,
      ),
    );

    final result = await _repository.forgotPassword(
      mobileNumber: state.mobileNumber,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ForgotPasswordStatus.forgotFailure,
          errorMessage: failure.message,
        ),
      ),
      (info) {
        final resolved = _resolveTimerData(
          otpExpiresInSeconds: info.otpExpiresInSeconds,
          resendCooldownSeconds: info.resendCooldownSeconds,
          maxAttempts: info.maxAttempts,
          attemptsRemaining: info.attemptsRemaining,
        );

        _startOtpExpiryTimer(resolved.otpExpiresInSeconds);
        _startCooldownTimer(resolved.resendCooldownSeconds);
        emit(
          state.copyWith(
            status: ForgotPasswordStatus.forgotSuccess,
            errorMessage: null,
            otpExpiresInSeconds: resolved.otpExpiresInSeconds,
            maxAttempts: resolved.maxAttempts,
            attemptsRemaining: resolved.attemptsRemaining,
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Verify OTP
  // ---------------------------------------------------------------------------

  /// Calls `POST /password/verify-otp` with the stored mobile + OTP.
  Future<void> verifyOtp() async {
    if (state.status == ForgotPasswordStatus.verifyLoading) return;
    if (state.otp.length != 6) return;

    emit(
      state.copyWith(
        status: ForgotPasswordStatus.verifyLoading,
        errorMessage: null,
      ),
    );

    final result = await _repository.verifyOtp(
      mobileNumber: state.mobileNumber,
      otp: state.otp,
    );

    result.fold(
      (failure) {
        // Prefer the attempts count reported by the API. Fall back to
        // a local decrement only when the API doesn't surface it.
        final apiAttempts = failure is ServerFailure
            ? failure.attemptsRemaining
            : null;
        emit(
          state.copyWith(
            status: ForgotPasswordStatus.verifyFailure,
            errorMessage: failure.message,
            attemptsRemaining:
                apiAttempts ?? (state.attemptsRemaining - 1).clamp(0, 99),
          ),
        );
      },
      (_) {
        _cooldownTimer?.cancel();
        _otpExpiryTimer?.cancel();
        emit(
          state.copyWith(
            status: ForgotPasswordStatus.verifySuccess,
            errorMessage: null,
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Resend OTP
  // ---------------------------------------------------------------------------

  /// Calls `POST /password/resend-otp`. Uses the timer / attempts data
  /// returned by the API to drive the UI. Falls back to a 90s cooldown
  /// and 5 remaining attempts when the API doesn't supply them.
  Future<void> resendOtp() async {
    if (state.status == ForgotPasswordStatus.resendLoading) return;
    if (state.resendCooldown > 0) return;

    emit(
      state.copyWith(
        status: ForgotPasswordStatus.resendLoading,
        errorMessage: null,
        // Clear the OTP so the user types the new one.
        otp: '',
      ),
    );

    final result = await _repository.resendOtp(
      mobileNumber: state.mobileNumber,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ForgotPasswordStatus.resendFailure,
          errorMessage: failure.message,
        ),
      ),
      (info) {
        final resolved = _resolveTimerData(
          otpExpiresInSeconds: info.otpExpiresInSeconds,
          resendCooldownSeconds: info.resendCooldownSeconds,
          maxAttempts: info.maxAttempts,
          attemptsRemaining: info.attemptsRemaining,
        );

        // A resend issues a fresh OTP, so both the expiry countdown
        // and the resend cooldown restart from the API's new values.
        _startOtpExpiryTimer(resolved.otpExpiresInSeconds);
        _startCooldownTimer(resolved.resendCooldownSeconds);

        emit(
          state.copyWith(
            status: ForgotPasswordStatus.resendSuccess,
            errorMessage: null,
            otpExpiresInSeconds: resolved.otpExpiresInSeconds,
            maxAttempts: resolved.maxAttempts,
            attemptsRemaining: resolved.attemptsRemaining,
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Reset password
  // ---------------------------------------------------------------------------

  /// Calls `POST /password/reset` with the stored mobile + new password.
  /// The OTP is NOT sent — it was already verified via `verifyOtp`.
  Future<void> resetPassword({required String newPassword}) async {
    if (state.status == ForgotPasswordStatus.resetLoading) return;
    if (state.mobileNumber.trim().isEmpty) return;
    if (newPassword.isEmpty) return;

    emit(
      state.copyWith(
        status: ForgotPasswordStatus.resetLoading,
        errorMessage: null,
      ),
    );

    final result = await _repository.resetPassword(
      mobileNumber: state.mobileNumber,
      newPassword: newPassword,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ForgotPasswordStatus.resetFailure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: ForgotPasswordStatus.resetSuccess,
          errorMessage: null,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // OTP session seeding (navigation entry point)
  // ---------------------------------------------------------------------------

  /// Seeds the OTP-expiry countdown, resend cooldown and attempts
  /// counters carried over from the Forgot-Password screen's
  /// successful response (the OTP screen gets a fresh cubit instance,
  /// so these values are passed forward via navigation `extra:` and
  /// re-applied here rather than being hardcoded).
  void seedOtpSession({
    int? otpExpiresInSeconds,
    int? resendCooldownSeconds,
    int? maxAttempts,
    int? attemptsRemaining,
  }) {
    final resolved = _resolveTimerData(
      otpExpiresInSeconds: otpExpiresInSeconds,
      resendCooldownSeconds: resendCooldownSeconds,
      maxAttempts: maxAttempts,
      attemptsRemaining: attemptsRemaining,
    );

    _startOtpExpiryTimer(resolved.otpExpiresInSeconds);
    _startCooldownTimer(resolved.resendCooldownSeconds);
    emit(
      state.copyWith(
        otpExpiresInSeconds: resolved.otpExpiresInSeconds,
        maxAttempts: resolved.maxAttempts,
        attemptsRemaining: resolved.attemptsRemaining,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Timer / attempts resolution
  // ---------------------------------------------------------------------------

  /// Fills in the API's timer/attempts values, falling back to sane
  /// defaults only where the API omitted a field (never overriding an
  /// explicit `0`).
  ({
    int otpExpiresInSeconds,
    int resendCooldownSeconds,
    int maxAttempts,
    int attemptsRemaining,
  })
  _resolveTimerData({
    int? otpExpiresInSeconds,
    int? resendCooldownSeconds,
    int? maxAttempts,
    int? attemptsRemaining,
  }) {
    final resolvedMaxAttempts = maxAttempts ?? state.maxAttempts;
    return (
      otpExpiresInSeconds: otpExpiresInSeconds ?? 600,
      resendCooldownSeconds: resendCooldownSeconds ?? 90,
      maxAttempts: resolvedMaxAttempts,
      attemptsRemaining: attemptsRemaining ?? resolvedMaxAttempts,
    );
  }

  // ---------------------------------------------------------------------------
  // Resend cooldown timer
  // ---------------------------------------------------------------------------

  void _startCooldownTimer(int seconds) {
    _cooldownTimer?.cancel();
    if (seconds <= 0) {
      emit(state.copyWith(resendCooldown: 0));
      return;
    }
    emit(state.copyWith(resendCooldown: seconds));
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final next = state.resendCooldown - 1;
      if (next <= 0) {
        timer.cancel();
        emit(state.copyWith(resendCooldown: 0));
      } else {
        emit(state.copyWith(resendCooldown: next));
      }
    });
  }

  // ---------------------------------------------------------------------------
  // OTP expiration timer
  // ---------------------------------------------------------------------------

  void _startOtpExpiryTimer(int seconds) {
    _otpExpiryTimer?.cancel();
    if (seconds <= 0) {
      emit(state.copyWith(otpExpiresInSeconds: 0));
      return;
    }
    emit(state.copyWith(otpExpiresInSeconds: seconds));
    _otpExpiryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final next = state.otpExpiresInSeconds - 1;
      if (next <= 0) {
        timer.cancel();
        emit(state.copyWith(otpExpiresInSeconds: 0));
      } else {
        emit(state.copyWith(otpExpiresInSeconds: next));
      }
    });
  }

  /// Clears the latest error so the UI doesn't show stale errors
  /// after the user edits the form.
  void clearError() {
    if (state.errorMessage == null) return;
    emit(state.copyWith(errorMessage: null));
  }

  @override
  Future<void> close() {
    _cooldownTimer?.cancel();
    _otpExpiryTimer?.cancel();
    return super.close();
  }
}
