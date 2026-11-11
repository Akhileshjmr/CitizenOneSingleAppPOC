import 'package:citizenone_app/modules/agency_banking/data/models/CommCustomerPin.dart';

abstract class ResetPinEvent {}

class ResetPinSubmitted extends ResetPinEvent {
  final CommCustomerPin resetPin;
  ResetPinSubmitted(this.resetPin);
}
