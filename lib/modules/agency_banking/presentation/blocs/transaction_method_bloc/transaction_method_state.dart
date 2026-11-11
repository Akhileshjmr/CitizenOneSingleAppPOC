import 'package:citizenone_app/modules/agency_banking/data/models/AbTransactionName.dart';


abstract class TransactionMethodState {}

class TransactionMethodInitial extends TransactionMethodState {}

class TransactionMethodLoading extends TransactionMethodState {}

class TransactionMethodSuccess extends TransactionMethodState {
  final String message;
  final AbTransactionName transactionName;
  TransactionMethodSuccess(this.message, this.transactionName);
}

class TransactionMethodFailure extends TransactionMethodState {
  final String error;
  TransactionMethodFailure(this.error);
}