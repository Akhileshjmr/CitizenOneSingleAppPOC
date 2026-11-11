import 'package:equatable/equatable.dart';

abstract class OtpVerificationEvent extends Equatable {
  const OtpVerificationEvent();

  @override
  List<Object?> get props => [];
}

/// Fired after every keystroke in any OTP box — clears a previously
/// shown error and recomputes whether all boxes are now filled (so the
/// UI can enable/disable the Verify button).
class OtpFieldEdited extends OtpVerificationEvent {
  const OtpFieldEdited();
}

/// Fired when the user taps "Verify". [onVerify] is the actual API call,
/// injected from outside so this Bloc stays free of networking concerns
/// and is easy to unit test. It receives the entered OTP and returns the
/// raw response body — that response is carried into
/// [OtpVerificationState.response] so the screen can hand it back to
/// whichever transaction triggered this OTP step.
class OtpSubmitted extends OtpVerificationEvent {
  final Future<Map<String, dynamic>> Function(String otp) onVerify;

  const OtpSubmitted({required this.onVerify});

  @override
  List<Object?> get props => [onVerify];
}

/// Fired when the user taps "Resend OTP" (only reachable once the
/// cooldown hits zero). [onResend] triggers the actual resend API call.
class OtpResendRequested extends OtpVerificationEvent {
  final Future<void> Function() onResend;

  const OtpResendRequested({required this.onResend});

  @override
  List<Object?> get props => [onResend];
}

/// Internal — one tick of the resend-cooldown countdown.
class OtpTimerTicked extends OtpVerificationEvent {
  const OtpTimerTicked();
}

/// Clears all boxes and resets status back to idle (e.g. if this screen
/// is reused/reopened for a second OTP attempt).
class OtpReset extends OtpVerificationEvent {
  const OtpReset();
}
