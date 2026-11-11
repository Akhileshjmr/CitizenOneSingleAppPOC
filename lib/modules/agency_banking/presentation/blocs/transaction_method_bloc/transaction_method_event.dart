import 'package:citizenone_app/modules/agency_banking/data/models/AbTransactionName.dart';

abstract class TransactionMethodEvent {}

class ClearTransactionMethod extends TransactionMethodEvent {}

class TransactionMethodSubmitted extends TransactionMethodEvent {
  final AbTransactionName transactionName;
  TransactionMethodSubmitted(this.transactionName);
}
