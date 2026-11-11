/// Request DTO for the agent user service `POST /password/reset`
/// endpoint. The OTP is verified separately via `/password/verify-otp`,
/// so the request only carries the new password + mobile number.
class ResetPasswordRequestModel {
  final String mobileNumber;
  final String newPassword;

  const ResetPasswordRequestModel({
    required this.mobileNumber,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
    'mobileNumber': mobileNumber,
    'newPassword': newPassword,
  };
}
