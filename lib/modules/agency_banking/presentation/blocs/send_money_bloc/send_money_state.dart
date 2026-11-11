
import '../../../data/models/CommTransaction.dart';

abstract class SendMoneyState {}

class SendMoneyInitial extends SendMoneyState {}

class SendMoneyLoading extends SendMoneyState {}

class SendMoneySuccess extends SendMoneyState {
  final String message;
  late final CommTransaction commTransaction;
  SendMoneySuccess(this.message,this.commTransaction);
}

class SendMoneyFailure extends SendMoneyState {
  final String error;
  SendMoneyFailure(this.error);
}