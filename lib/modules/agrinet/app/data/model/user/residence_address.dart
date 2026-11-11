import 'package:citizenone_app/modules/agrinet/app/data/model/common/option.dart';

class ResidenceAddress {
  Option? addressType;
  String? address;
  Option? country;
  Option? state;
  Option? city;
  Option? region;

  ResidenceAddress({
    this.addressType,
    this.address,
    this.country,
    this.state,
    this.city,
    this.region,
  });

  factory ResidenceAddress.fromJson(Map<String, dynamic> json) {
    return ResidenceAddress(
      addressType:
          json['addressType'] != null
              ? Option.fromJson(json['addressType'])
              : null,
      address: json['address'],
      country:
          json['country'] != null ? Option.fromJson(json['country']) : null,
      state: json['state'] != null ? Option.fromJson(json['state']) : null,
      city: json['city'] != null ? Option.fromJson(json['city']) : null,
      region: json['region'] != null ? Option.fromJson(json['region']) : null,
    );
  }
}
