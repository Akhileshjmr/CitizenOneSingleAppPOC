import 'package:citizenone_app/modules/agency_banking/data/models/AccountTransHistory.dart';

abstract class TransactionHistoryEvent {}

class TransactionHistorySubmitted extends TransactionHistoryEvent {
  final AccountTransHistory transHistory;
  TransactionHistorySubmitted(this.transHistory);
}
// transaction_history_event.dart
class TransactionHistoryReset extends TransactionHistoryEvent {}
