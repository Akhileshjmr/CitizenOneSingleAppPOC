/// Request DTO for the agent user service `POST /password/change`
/// endpoint.
class ChangePasswordRequestModel {
  final String mobileNumber;
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequestModel({
    required this.mobileNumber,
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
    'mobileNumber': mobileNumber,
    'currentPassword': currentPassword,
    'newPassword': newPassword,
  };
}
