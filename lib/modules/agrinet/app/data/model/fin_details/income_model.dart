import '../common/option.dart';

class IncomeModel {
  Option? type;
  double amount;

  IncomeModel({this.type, required this.amount});

  Map<String, dynamic> toJson() => {
    "incomeType": type?.toJson(),
    "incomeValue": amount,
  };
}
