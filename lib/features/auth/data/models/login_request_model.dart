/// Request DTO for the agent user service `POST /session/create` endpoint.
class LoginRequestModel {
  final String mobileNumber;
  final String password;

  const LoginRequestModel({required this.mobileNumber, required this.password});

  Map<String, dynamic> toJson() => {
    'mobileNumber': mobileNumber,
    'password': password,
  };
}
