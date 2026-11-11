import '../../../data/models/CommRequestList.dart';
import '../../../data/models/CommRequestMoney.dart';

abstract class ReceiveRequestEvent {}

class ReceiveRequestSubmitted extends ReceiveRequestEvent {
  final CommRequestList requestList;
  ReceiveRequestSubmitted(this.requestList);
}
