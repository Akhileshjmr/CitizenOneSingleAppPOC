import '../../../data/models/login_models/LoginUserReqResInfo.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginUserReqResInfo user;
  final String responseMessage;
  final String responseCode;

  LoginSuccess(this.user, this.responseMessage, this.responseCode);
}

class LoginFailure extends LoginState {
  final String error;
  final LoginUserReqResInfo user;

  LoginFailure(this.error, this.user);
}
