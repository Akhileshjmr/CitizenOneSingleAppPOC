/// Request DTO for the agent user service `POST /password/verify-otp`
/// endpoint.
class VerifyOtpRequestModel {
  final String mobileNumber;
  final String otp;

  const VerifyOtpRequestModel({required this.mobileNumber, required this.otp});

  Map<String, dynamic> toJson() => {'mobileNumber': mobileNumber, 'otp': otp};
}
