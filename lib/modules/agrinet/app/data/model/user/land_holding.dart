import '../common/option.dart';

class LandHolding {
  String? village;
  Option? landType;
  double? area;
  double? irrigatedPerc;
  Option? sourceOfIrrigation;
  double? farmValue;
  Option? season;
  String? cropName;
  double? saleValue;

  LandHolding({
    this.village,
    this.landType,
    this.area,
    this.irrigatedPerc,
    this.sourceOfIrrigation,
    this.farmValue,
    this.season,
    this.cropName,
    this.saleValue,
  });

  factory LandHolding.fromJson(Map<String, dynamic> json) {
    return LandHolding(
      village: json['village'],
      landType:
          json['landType'] != null ? Option.fromJson(json['landType']) : null,
      area: (json['area'] as num?)?.toDouble(),
      irrigatedPerc: (json['irrigatedPerc'] as num?)?.toDouble(),
      sourceOfIrrigation:
          json['sourceOfIrrigation'] != null
              ? Option.fromJson(json['sourceOfIrrigation'])
              : null,
      farmValue: (json['farmValue'] as num?)?.toDouble(),
      season: json['season'] != null ? Option.fromJson(json['season']) : null,
      cropName: json['cropName'],
      saleValue: (json['saleValue'] as num?)?.toDouble(),
    );
  }
}
