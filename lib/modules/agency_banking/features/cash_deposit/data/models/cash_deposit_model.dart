import '../../domain/entities/cash_deposit_entity.dart';

class CashDepositModel extends CashDepositEntity {
  const CashDepositModel({
    required super.transactionId,
    required super.accountNumber,
    required super.amount,
    required super.depositorName,
    required super.timestamp,
    required super.status,
  });

  factory CashDepositModel.fromJson(Map<String, dynamic> json) {
    return CashDepositModel(
      transactionId: json['transactionId'] as String? ??
          'TXN-${DateTime.now().millisecondsSinceEpoch}',
      accountNumber: json['accountNumber'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      depositorName: json['depositorName'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      status: json['status'] as String? ?? 'COMPLETED',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'accountNumber': accountNumber,
      'amount': amount,
      'depositorName': depositorName,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }
}
