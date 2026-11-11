import '../../../data/models/CommAccountRequest.dart';

abstract class AccountBalanceEvent {}

class AccountBalanceSubmitted extends AccountBalanceEvent {
  final CommAccountRequest accountBalance;
  AccountBalanceSubmitted(this.accountBalance);
}
