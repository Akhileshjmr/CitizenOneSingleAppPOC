import '../../../data/models/CommAccountRequest.dart';

abstract class BalanceSmsEvent {}

class BalanceSmsSubmitted extends BalanceSmsEvent {
  final CommAccountRequest accountBalance;
  BalanceSmsSubmitted(this.accountBalance);
}
