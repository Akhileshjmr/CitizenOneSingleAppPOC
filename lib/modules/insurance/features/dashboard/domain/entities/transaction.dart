import 'package:equatable/equatable.dart';

enum TransactionCategory {
  groceries,
  restaurant,
  transport,
  utilities,
  payroll,
  refund,
  transfer,
  shopping,
  subscription,
  other,
}

enum TransactionStatus { pending, settled, failed, reversed }

class Transaction extends Equatable {
  const Transaction({
    required this.id,
    required this.title,
    required this.merchant,
    required this.amount,
    required this.currency,
    required this.date,
    required this.category,
    required this.status,
    required this.isCredit,
    required this.accountId,
    this.reference,
    this.notes,
  });

  final String id;
  final String title;
  final String merchant;
  final double amount;
  final String currency;
  final DateTime date;
  final TransactionCategory category;
  final TransactionStatus status;
  final bool isCredit;
  final String accountId;
  final String? reference;
  final String? notes;

  @override
  List<Object?> get props => [
        id,
        title,
        merchant,
        amount,
        currency,
        date,
        category,
        status,
        isCredit,
        accountId,
        reference,
        notes,
      ];
}
