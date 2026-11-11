import '../../../data/models/CommRequestMoney.dart';

abstract class RequestMoneyState {}

class RequestMoneyInitial extends RequestMoneyState {}

class RequestMoneyLoading extends RequestMoneyState {}

class RequestMoneySuccess extends RequestMoneyState {
  final String message;
  final CommRequestMoney requestMoney;
  RequestMoneySuccess(this.message,this.requestMoney);
}

class RequestMoneyFailure extends RequestMoneyState {
  final String error;
  RequestMoneyFailure(this.error);
}
