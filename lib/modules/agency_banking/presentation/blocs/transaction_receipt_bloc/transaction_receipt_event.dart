import 'package:citizenone_app/modules/agency_banking/data/models/CommTransactionDetails.dart';

abstract class TransactionReceiptEvent {}

class TransactionReceiptSubmitted extends TransactionReceiptEvent {
  final CommTransactionDetails transactionDetails;
  TransactionReceiptSubmitted(this.transactionDetails);
}