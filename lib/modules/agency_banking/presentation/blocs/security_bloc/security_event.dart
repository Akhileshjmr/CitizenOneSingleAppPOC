import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';

abstract class SecurityEvent {}

class ChangePasswordSubmitted extends SecurityEvent {
  final String currentPassword;
  final String newPassword;
  final LoginUserReqResInfo loginResponse;

  ChangePasswordSubmitted({
    required this.currentPassword,
    required this.newPassword,
    required this.loginResponse,
  });
}
