import 'package:citizenone_app/modules/agency_banking/data/models/CommTransaction.dart';

abstract class PinValidationState {}

class PinValidationInitial extends PinValidationState {}

class PinValidationLoading extends PinValidationState {}

class PinValidationSuccess extends PinValidationState {
  final String message;
  final CommTransaction commTransaction;
  PinValidationSuccess(this.message,this.commTransaction);
}

class PinValidationFailure extends PinValidationState {
  final String error;
  PinValidationFailure(this.error);
}
