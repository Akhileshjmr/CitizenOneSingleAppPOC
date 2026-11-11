import '../../domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  TransactionModel({
    required super.id,
    required super.title,
    required super.merchant,
    required super.amount,
    required super.currency,
    required super.date,
    required String category,
    required String status,
    required super.isCredit,
    required super.accountId,
    super.reference,
    super.notes,
  }) : super(
          category: _categoryFromString(category),
          status: _statusFromString(status),
        );

  static TransactionCategory _categoryFromString(String s) {
    return TransactionCategory.values.firstWhere(
      (c) => c.name == s,
      orElse: () => TransactionCategory.other,
    );
  }

  static TransactionStatus _statusFromString(String s) {
    return TransactionStatus.values.firstWhere(
      (st) => st.name == s,
      orElse: () => TransactionStatus.settled,
    );
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json['id'] as String,
        title: json['title'] as String,
        merchant: json['merchant'] as String,
        amount: (json['amount'] as num).toDouble(),
        currency: json['currency'] as String,
        date: DateTime.parse(json['date'] as String),
        category: json['category'] as String,
        status: json['status'] as String,
        isCredit: json['isCredit'] as bool,
        accountId: json['accountId'] as String,
        reference: json['reference'] as String?,
        notes: json['notes'] as String?,
      );
}
