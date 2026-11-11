import '../../../data/models/CommCustomerPin.dart';

abstract class ChangePinEvent {}

class ChangePinSubmitted extends ChangePinEvent {
  final CommCustomerPin changePin;
  ChangePinSubmitted(this.changePin);
}
