import '../../domain/entities/bank_account.dart';

class BankAccountModel extends BankAccount {
  BankAccountModel({
    required super.id,
    required super.label,
    required super.accountNumber,
    required String type,
    required super.balance,
    required super.currency,
  }) : super(type: _typeFromString(type) ?? AccountType.checking);

  static AccountType? _typeFromString(String t) {
    switch (t) {
      case 'checking':
        return AccountType.checking;
      case 'savings':
        return AccountType.savings;
      case 'credit':
        return AccountType.credit;
    }
    return null;
  }

  factory BankAccountModel.fromJson(Map<String, dynamic> json) =>
      BankAccountModel(
        id: json['id'] as String,
        label: json['label'] as String,
        accountNumber: json['accountNumber'] as String,
        type: json['type'] as String,
        balance: (json['balance'] as num).toDouble(),
        currency: json['currency'] as String,
      );
}
