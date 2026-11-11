import 'PrimaryAddress.dart';

class CommDet {
  CommDet({
      this.primaryAddress,});

  CommDet.fromJson(dynamic json) {
    primaryAddress = json['primaryAddress'] != null ? PrimaryAddress.fromJson(json['primaryAddress']) : null;
  }
  PrimaryAddress? primaryAddress;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (primaryAddress != null) {
      map['primaryAddress'] = primaryAddress?.toJson();
    }
    return map;
  }

}