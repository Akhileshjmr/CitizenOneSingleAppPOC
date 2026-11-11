import 'package:equatable/equatable.dart';

enum AccountType { checking, savings, credit }

class BankAccount extends Equatable {
  const BankAccount({
    required this.id,
    required this.label,
    required this.accountNumber,
    required this.type,
    required this.balance,
    required this.currency,
  });

  final String id;
  final String label;
  final String accountNumber;
  final AccountType type;
  final double balance;
  final String currency;

  @override
  List<Object?> get props => [id, label, accountNumber, type, balance, currency];
}
