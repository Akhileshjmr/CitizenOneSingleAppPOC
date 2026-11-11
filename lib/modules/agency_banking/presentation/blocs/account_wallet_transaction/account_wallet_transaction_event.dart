import '../../../data/models/CommWalletTransaction.dart';

abstract class AccountWalletTransactionEvent {}

class AccountWalletTransactionSubmitted extends AccountWalletTransactionEvent {
  final CommWalletTransaction commWalletTransaction;
  AccountWalletTransactionSubmitted(this.commWalletTransaction);
}
