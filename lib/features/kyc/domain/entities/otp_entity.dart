// features/kyc/domain/entities/otp_entity.dart

class OtpResponseEntity {
  final String otpId;
  final String otp;
  final bool isDefaultOtp;
  final int attemptRemaining;
  final int validityTime;
  final String status;
  final String channel;
  final bool isLocked;

  const OtpResponseEntity({
    required this.otpId,
    required this.otp,
    required this.isDefaultOtp,
    required this.attemptRemaining,
    required this.validityTime,
    required this.status,
    required this.channel,
    required this.isLocked,
  });
}

class OtpVerifyResultEntity {
  final bool isVerified;
  final String status;

  const OtpVerifyResultEntity({
    required this.isVerified,
    required this.status,
  });
}
