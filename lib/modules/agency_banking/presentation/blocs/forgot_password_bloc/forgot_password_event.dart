import '../../../data/models/login_models/UserOtpValidationInfo.dart';

abstract class ForgotPasswordEvent {}

class ForgotPasswordSubmitted extends ForgotPasswordEvent
{
   final UserOTPValidationInfo otpRequest;
   ForgotPasswordSubmitted(this.otpRequest);
}
class ValidateOtpSubmitted extends ForgotPasswordEvent {
   final UserOTPValidationInfo otpValidationRequest;
   ValidateOtpSubmitted(this.otpValidationRequest);
}
class ResetForgotPasswordState extends ForgotPasswordEvent {}