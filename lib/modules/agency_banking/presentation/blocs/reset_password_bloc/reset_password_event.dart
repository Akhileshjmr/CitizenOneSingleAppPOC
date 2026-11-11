import '../../../data/models/login_models/AbAgentForgotChangePwd.dart';

abstract class ResetPasswordEvent {}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  final AbAgentForgetChangePwd resetPasswordRequest;
  ResetPasswordSubmitted(this.resetPasswordRequest);
}
