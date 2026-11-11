import 'package:citizenone_app/modules/agency_banking/data/models/CommTransactionDetails.dart';

abstract class TransactionReceiptState {}

class TransactionReceiptInitial extends TransactionReceiptState {}

class TransactionReceiptLoading extends TransactionReceiptState {}

class TransactionReceiptSuccess extends TransactionReceiptState {
  final String message;
  final CommTransactionDetails transactionDetails;
  TransactionReceiptSuccess(this.message, this.transactionDetails);
}

class TransactionReceiptFailure extends TransactionReceiptState {
  final String error;
  TransactionReceiptFailure(this.error);
}
