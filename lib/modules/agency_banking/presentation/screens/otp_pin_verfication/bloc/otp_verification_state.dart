import 'package:equatable/equatable.dart';

enum OtpStatus { idle, submitting, success, failure }

class OtpVerificationState extends Equatable {
  final OtpStatus status;
  final String? errorText;
  final bool isComplete;
  final int resendSecondsRemaining;
  final bool isResending;

  /// Raw response body from the last successful [OtpSubmitted.onVerify]
  /// call. Populated only on success — the screen reads this and hands
  /// it to [OtpVerificationScreen.onVerified] so the transaction that
  /// triggered this OTP step gets its response back.
  final Map<String, dynamic>? response;

  const OtpVerificationState({
    this.status = OtpStatus.idle,
    this.errorText,
    this.isComplete = false,
    this.resendSecondsRemaining = 30,
    this.isResending = false,
    this.response,
  });

  bool get isSubmitting => status == OtpStatus.submitting;
  bool get canResend => resendSecondsRemaining <= 0 && !isResending;

  OtpVerificationState copyWith({
    OtpStatus? status,
    String? errorText,
    bool clearError = false,
    bool? isComplete,
    int? resendSecondsRemaining,
    bool? isResending,
    Map<String, dynamic>? response,
  }) {
    return OtpVerificationState(
      status: status ?? this.status,
      errorText: clearError ? null : (errorText ?? this.errorText),
      isComplete: isComplete ?? this.isComplete,
      resendSecondsRemaining:
          resendSecondsRemaining ?? this.resendSecondsRemaining,
      isResending: isResending ?? this.isResending,
      response: response ?? this.response,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorText,
        isComplete,
        resendSecondsRemaining,
        isResending,
        response,
      ];
}
