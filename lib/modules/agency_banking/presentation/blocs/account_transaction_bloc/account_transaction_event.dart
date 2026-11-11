import '../../../data/models/CommTransaction.dart';

abstract class AccountTransactionEvent {}

class AccountTransactionSubmitted extends AccountTransactionEvent {
  final CommTransaction accountTransaction;
  AccountTransactionSubmitted(this.accountTransaction);
}
