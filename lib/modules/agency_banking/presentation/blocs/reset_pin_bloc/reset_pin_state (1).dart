abstract class ResetPinState {}

class ResetPinInitial extends ResetPinState {}

class ResetPinLoading extends ResetPinState {}

class ResetPinSuccess extends ResetPinState {
  final String message;
  ResetPinSuccess(this.message);
}

class ResetPinFailure extends ResetPinState {
  final String error;
  ResetPinFailure(this.error);
}
