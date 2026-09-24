import 'package:equatable/equatable.dart';

class CashDepositEntity extends Equatable {
  final String transactionId;
  final String accountNumber;
  final double amount;
  final String depositorName;
  final DateTime timestamp;
  final String status;

  const CashDepositEntity({
    required this.transactionId,
    required this.accountNumber,
    required this.amount,
    required this.depositorName,
    required this.timestamp,
    required this.status,
  });

  @override
  List<Object?> get props => [
        transactionId,
        accountNumber,
        amount,
        depositorName,
        timestamp,
        status,
      ];
}
