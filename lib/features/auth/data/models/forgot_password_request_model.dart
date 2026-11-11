/// Request DTO for the agent user service `POST /password/forgot` endpoint.
class ForgotPasswordRequestModel {
  final String mobileNumber;

  const ForgotPasswordRequestModel({required this.mobileNumber});

  Map<String, dynamic> toJson() => {'mobileNumber': mobileNumber};
}
