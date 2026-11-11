import 'package:citizenone_app/modules/agrinet/app/data/model/common/option.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_constants.dart';

class ExpenseDetails {
  Option? expenseType;
  double? expenseValue;
  String currency;

  ExpenseDetails({this.expenseType, this.expenseValue, String? currency})
    : currency = currency ?? AgConstants.currency;

  factory ExpenseDetails.fromJson(Map<String, dynamic> json) {
    return ExpenseDetails(
      expenseType:
          json['expenseType'] != null
              ? Option.fromJson(json['expenseType'])
              : null,
      expenseValue: (json['expenseValue'] as num?)?.toDouble(),
      currency: /*json['currency'] ??*/ AgConstants.currency,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "expenseType": expenseType?.toJson(),
      "expenseValue": expenseValue,
      "currency": currency,
    };
  }
}
