import 'package:citizenone_app/modules/agency_banking/data/models/CommTransaction.dart';

abstract class PinValidationEvent {}

class PinValidationSubmitted extends PinValidationEvent {
  final CommTransaction validatePin;
  PinValidationSubmitted(this.validatePin);
}
class ResetPinValidationState extends PinValidationEvent {}