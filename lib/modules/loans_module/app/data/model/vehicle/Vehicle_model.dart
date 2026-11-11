import 'ChMessage.dart';
import 'VehicleInfo.dart';

class VehicleModel {
  VehicleModel({
      this.reqSecureKey, 
      this.addiParams, 
      this.chMessage, 
      this.urlDecision, 
      this.value, 
      this.vehicleInfo,});

  VehicleModel.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'] != null ? json['addiParams'].cast<String>() : [];
    chMessage = json['chMessage'] != null ? ChMessage.fromJson(json['chMessage']) : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    vehicleInfo = json['vehicleInfo'] != null ? VehicleInfo.fromJson(json['vehicleInfo']) : null;
  }
  String? reqSecureKey;
  List<String>? addiParams;
  ChMessage? chMessage;
  String? urlDecision;
  String? value;
  VehicleInfo? vehicleInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reqSecureKey'] = reqSecureKey;
    map['addiParams'] = addiParams;
    if (chMessage != null) {
      map['chMessage'] = chMessage?.toJson();
    }
    map['urlDecision'] = urlDecision;
    map['value'] = value;
    if (vehicleInfo != null) {
      map['vehicleInfo'] = vehicleInfo?.toJson();
    }
    return map;
  }

}