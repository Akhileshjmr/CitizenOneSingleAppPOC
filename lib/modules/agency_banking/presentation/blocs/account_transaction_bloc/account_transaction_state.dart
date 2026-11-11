
import '../../../data/models/CommTransaction.dart';

abstract class AccountTransactionState {}

class AccountTransactionInitial extends AccountTransactionState {}

class AccountTransactionLoading extends AccountTransactionState {}

class AccountTransactionSuccess extends AccountTransactionState {
  final String message;
  final CommTransaction commTransaction;
  AccountTransactionSuccess(this.message,this.commTransaction);
}

class AccountTransactionFailure extends AccountTransactionState {
  final String error;
  AccountTransactionFailure(this.error);
}