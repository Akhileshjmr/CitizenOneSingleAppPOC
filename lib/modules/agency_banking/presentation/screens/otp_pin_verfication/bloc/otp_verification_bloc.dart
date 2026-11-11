import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'otp_verification_event.dart';
import 'otp_verification_state.dart';

/// Bloc for any OTP verification screen in the app.
///
/// Reusable by design: [otpLength] and [resendCooldownSeconds] are
/// configurable, and this Bloc has zero knowledge of what triggered the
/// OTP (login, transaction, KYC, ...) — the actual verify/resend API
/// calls are injected per-event via [OtpSubmitted.onVerify] and
/// [OtpResendRequested.onResend]. Create a fresh instance per screen.
///
/// Same design choice as LoanSearchBloc: the TextEditingControllers and
/// FocusNodes live here as plain fields, not inside state, since state
/// only needs to track what the UI reacts to (status, error, resend
/// cooldown) — not raw per-keystroke text.
class OtpVerificationBloc extends Bloc<OtpVerificationEvent, OtpVerificationState> {
  final int otpLength;
  final int resendCooldownSeconds;

  late final List<TextEditingController> digitControllers;
  late final List<FocusNode> focusNodes;

  Timer? _resendTimer;

  OtpVerificationBloc({
    this.otpLength = 6,
    this.resendCooldownSeconds = 30,
  }) : super(OtpVerificationState(resendSecondsRemaining: resendCooldownSeconds)) {
    digitControllers = List.generate(otpLength, (_) => TextEditingController());
    focusNodes = List.generate(otpLength, (_) => FocusNode());

    on<OtpFieldEdited>(_onFieldEdited);
    on<OtpSubmitted>(_onSubmitted);
    on<OtpResendRequested>(_onResendRequested);
    on<OtpTimerTicked>(_onTimerTicked);
    on<OtpReset>(_onReset);

    _startResendTimer();
  }

  String get _otpValue => digitControllers.map((c) => c.text).join();

  void _onFieldEdited(OtpFieldEdited event, Emitter<OtpVerificationState> emit) {
    emit(state.copyWith(
      isComplete: _otpValue.length == otpLength,
      clearError: state.errorText != null,
    ));
  }

  Future<void> _onSubmitted(
    OtpSubmitted event,
    Emitter<OtpVerificationState> emit,
  ) async {
    final otp = _otpValue;
    if (otp.length != otpLength) {
      emit(state.copyWith(
        status: OtpStatus.failure,
        errorText: 'Please enter the complete $otpLength-digit OTP.',
      ));
      return;
    }

    emit(state.copyWith(status: OtpStatus.submitting, clearError: true));

    try {
      final response = await event.onVerify(otp);
      emit(state.copyWith(status: OtpStatus.success, response: response));
    } catch (_) {
      emit(state.copyWith(
        status: OtpStatus.failure,
        errorText: 'Incorrect OTP. Please try again.',
      ));
    }
  }

  Future<void> _onResendRequested(
    OtpResendRequested event,
    Emitter<OtpVerificationState> emit,
  ) async {
    if (!state.canResend) return;

    emit(state.copyWith(isResending: true, clearError: true));

    try {
      await event.onResend();

      for (final c in digitControllers) {
        c.clear();
      }
      if (focusNodes.isNotEmpty) {
        focusNodes.first.requestFocus();
      }

      emit(state.copyWith(
        isResending: false,
        resendSecondsRemaining: resendCooldownSeconds,
        isComplete: false,
        status: OtpStatus.idle,
        clearError: true,
      ));
      _startResendTimer();
    } catch (_) {
      emit(state.copyWith(
        isResending: false,
        errorText: 'Could not resend OTP. Please try again.',
      ));
    }
  }

  void _onTimerTicked(OtpTimerTicked event, Emitter<OtpVerificationState> emit) {
    if (state.resendSecondsRemaining <= 0) {
      _resendTimer?.cancel();
      return;
    }
    emit(state.copyWith(
        resendSecondsRemaining: state.resendSecondsRemaining - 1));
  }

  void _onReset(OtpReset event, Emitter<OtpVerificationState> emit) {
    for (final c in digitControllers) {
      c.clear();
    }
    emit(OtpVerificationState(resendSecondsRemaining: resendCooldownSeconds));
    _startResendTimer();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(const OtpTimerTicked()),
    );
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    for (final c in digitControllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    return super.close();
  }
}
