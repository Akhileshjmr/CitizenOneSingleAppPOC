
class GdbProductGroup {
  String? productGroupName;
  String? productGroupDescription;
  double? loanAmountMin;
  double? loanAmountMax;
  int? loanTermMin;
  int? loanTermMax;
  double? intrstRateMin;
  double? intrstRateMax;

  GdbProductGroup({
    this.productGroupName,
    this.productGroupDescription,
    this.loanAmountMin,
    this.loanAmountMax,
    this.loanTermMin,
    this.loanTermMax,
    this.intrstRateMin,
    this.intrstRateMax,
  });

  factory GdbProductGroup.fromJson(Map<String, dynamic> json) {
    return GdbProductGroup(
      productGroupName: json['productGroupName'],
      productGroupDescription: json['productGroupDescription'],
      loanAmountMin: (json['loanAmountMin'] as num?)?.toDouble(),
      loanAmountMax: (json['loanAmountMax'] as num?)?.toDouble(),
      loanTermMin: json['loanTermMin'],
      loanTermMax: json['loanTermMax'],
      intrstRateMin: (json['intrstRateMin'] as num?)?.toDouble(),
      intrstRateMax: (json['intrstRateMax'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productGroupName': productGroupName,
      'productGroupDescription': productGroupDescription,
      'loanAmountMin': loanAmountMin,
      'loanAmountMax': loanAmountMax,
      'loanTermMin': loanTermMin,
      'loanTermMax': loanTermMax,
      'intrstRateMin': intrstRateMin,
      'intrstRateMax': intrstRateMax,
    };
  }
}
