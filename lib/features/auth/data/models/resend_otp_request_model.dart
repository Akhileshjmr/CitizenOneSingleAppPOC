/// Request DTO for the agent user service `POST /password/resend-otp`
/// endpoint.
class ResendOtpRequestModel {
  final String mobileNumber;

  const ResendOtpRequestModel({required this.mobileNumber});

  Map<String, dynamic> toJson() => {'mobileNumber': mobileNumber};
}
