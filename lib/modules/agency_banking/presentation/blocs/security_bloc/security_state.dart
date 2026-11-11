abstract class SecurityState {}

class SecurityInitial extends SecurityState {}

class SecurityLoading extends SecurityState {}

class ChangePasswordSuccess extends SecurityState {
  final String message;
  ChangePasswordSuccess(this.message);
}

class ChangePasswordFailure extends SecurityState {
  final String error;
  ChangePasswordFailure(this.error);
}
