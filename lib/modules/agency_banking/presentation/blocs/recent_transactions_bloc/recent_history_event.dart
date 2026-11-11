
import '../../../data/models/AccountTransHistory.dart';

abstract class RecentHistoryEvent {}

class RecentHistorySubmitted extends RecentHistoryEvent {
  final AccountTransHistory transHistory;
  RecentHistorySubmitted(this.transHistory);
}
// transaction_history_event.dart
class RecentHistoryReset extends RecentHistoryEvent {}
