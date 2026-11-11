import 'package:citizenone_app/modules/agrinet/app/data/model/common/option.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_constants.dart';

class IncomeDetails {
  Option? incomeType;
  double? incomeValue;
  String? currency; // non-null with default

  IncomeDetails({this.incomeType, this.incomeValue, this.currency});

  factory IncomeDetails.fromJson(Map<String, dynamic> json) {
    return IncomeDetails(
      incomeType:
          json['incomeType'] != null
              ? Option.fromJson(json['incomeType'])
              : null,
      incomeValue: (json['incomeValue'] as num?)?.toDouble(),
      currency: /*json['currency'] ?? */ AgConstants.currency,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "incomeType": incomeType?.toJson(),
      "incomeValue": incomeValue,
      "currency": currency,
    };
  }
}
