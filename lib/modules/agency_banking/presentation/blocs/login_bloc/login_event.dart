import '../../../data/models/login_models/LoginUserReqResInfo.dart';

abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {

  final LoginUserReqResInfo loginRequest;

  /// Overrides the endpoint the request is posted to (defaults to
  /// [ApiEndpoints.login] inside [AuthService.login]). Used by the
  /// Citizen One auto-login path to hit [ApiEndpoints.citizenUserLogin]
  /// instead, without duplicating any login logic.
  final String? endpointOverride;

  LoginSubmitted(this.loginRequest, {this.endpointOverride});
}
