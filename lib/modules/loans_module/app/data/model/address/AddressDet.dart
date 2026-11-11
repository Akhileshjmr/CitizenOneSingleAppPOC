import '../select_box_model/Options.dart';
import 'State.dart';

class AddressDet {
  String? area;
  Options? country;
  State? state;
  String? building;
  String? houseNo;
  String? postBoxNum;
  String? landMark;
  String? typeOfAddress;
  int? contactNum;
  String? cityName;
  String? stateName;
  String? personName;
  String? stateInfo;
  String? cityInfo;

  AddressDet({
    this.area,
    this.country,
    this.state,
    this.building,
    this.houseNo,
    this.postBoxNum,
    this.landMark,
    this.typeOfAddress,
    this.contactNum,
    this.cityName,
    this.stateName,
    this.personName,
    this.stateInfo,
    this.cityInfo,
  });

  /// ✅ Optimized fromJson
  factory AddressDet.fromJson(Map<String, dynamic> json) {
    return AddressDet(
      area: json['area'],
      building: json['building'],
      houseNo: json['houseNo'],
      postBoxNum: json['postBoxNum'],
      landMark: json['landMark'],
      typeOfAddress: json['typeOfAddress'],
      contactNum: json['contactNum'],
      personName: json['personName'],
      stateInfo: json['stateInfo']?.toString(),
      cityInfo: json['cityInfo']?.toString(),

      /// ✅ IMPORTANT CHANGE:
      /// Country is strictly read from `country` object
      /// NOT from cityName anymore
      country:
          json['country'] != null ? Options.fromJson(json['country']) : null,

      state: json['state'] != null ? State.fromJson(json['state']) : null,

      /// Keep cityName as-is (no misuse for country)
      cityName: json['cityName'],
      stateName: json['stateName'],
    );
  }

  /// ✅ Optimized toJson
  Map<String, dynamic> toJson() {
    return {
      'area': area,
      'building': building,
      'houseNo': houseNo,
      'postBoxNum': postBoxNum,
      'landMark': landMark,
      'typeOfAddress': typeOfAddress,
      'contactNum': contactNum,
      'cityName': cityName,
      'stateName': stateName,
      'personName': personName,
      'stateInfo': stateInfo,
      'cityInfo': cityInfo,

      if (country != null) 'country': country!.toJson(),
      if (state != null) 'state': state!.toJson(),
    };
  }
}
