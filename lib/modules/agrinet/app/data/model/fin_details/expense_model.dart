import '../common/option.dart';

class ExpenseModel {
  Option? type;
  double amount;

  ExpenseModel({this.type, required this.amount});

  Map<String, dynamic> toJson() => {
    "expenseType": type?.toJson(),
    "expenseValue": amount,
  };
}
