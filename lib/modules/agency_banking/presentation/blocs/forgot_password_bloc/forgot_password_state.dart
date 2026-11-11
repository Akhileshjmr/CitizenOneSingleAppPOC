import '../../../data/models/login_models/UserOtpValidationInfo.dart';

abstract class ForgotPasswordState {}
class ForgotPasswordInitial extends ForgotPasswordState {}
class ForgotPasswordLoading extends ForgotPasswordState {}
class ForgotPasswordSuccess extends ForgotPasswordState
{
  final UserOTPValidationInfo userOtp;
  final String responseMessage;
  final String responseCode;
  ForgotPasswordSuccess(this.userOtp, this.responseMessage, this.responseCode);
}
class ForgotPasswordFailure extends ForgotPasswordState
{
  final String error;
  ForgotPasswordFailure(this.error);
}
class OtpValidationSuccess extends ForgotPasswordState {
  final UserOTPValidationInfo userOtp;
  final String responseMessage;
  OtpValidationSuccess(this.responseMessage, this.userOtp);
}

class OtpValidationFailure extends ForgotPasswordState {
  final String error;
  OtpValidationFailure(this.error);
}
