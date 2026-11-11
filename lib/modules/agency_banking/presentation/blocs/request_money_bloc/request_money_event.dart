import '../../../data/models/CommRequestMoney.dart';

abstract class RequestMoneyEvent {}

class RequestMoneySubmitted extends RequestMoneyEvent {
  final CommRequestMoney requestMoney;
  RequestMoneySubmitted(this.requestMoney);
}
