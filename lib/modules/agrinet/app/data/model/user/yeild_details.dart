import '../common/option.dart';

class YieldDetails {
  Option? year;
  Option? season;
  String? corpName;
  double? yieldQty;
  double? yieldValue;

  YieldDetails({
    this.year,
    this.season,
    this.corpName,
    this.yieldQty,
    this.yieldValue,
  });

  factory YieldDetails.fromJson(Map<String, dynamic> json) {
    return YieldDetails(
      year: json['year'] != null ? Option.fromJson(json['year']) : null,
      season: json['season'] != null ? Option.fromJson(json['season']) : null,
      corpName: json['corpName'],
      yieldQty: (json['yield'] as num?)?.toDouble(),
      yieldValue: (json['yieldValue'] as num?)?.toDouble(),
    );
  }
}
