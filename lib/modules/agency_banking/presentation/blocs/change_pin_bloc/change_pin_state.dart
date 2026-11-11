abstract class ChangePinState {}

class ChangePinInitial extends ChangePinState {}

class ChangePinLoading extends ChangePinState {}

class ChangePinSuccess extends ChangePinState {
  final String message;
  ChangePinSuccess(this.message);
}

class ChangePinFailure extends ChangePinState {
  final String error;
  ChangePinFailure(this.error);
}
