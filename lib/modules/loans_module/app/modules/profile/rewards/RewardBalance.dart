import 'package:citizenone_app/modules/loans_module/app/modules/profile/rewards/Data.dart';

class RewardBalance {
  RewardBalance({
      this.status, 
      this.data, 
      this.errorcode, 
      this.errordesc,});

  RewardBalance.fromJson(dynamic json) {
    status = json['status'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    errorcode = json['errorcode'];
    errordesc = json['errordesc'];
  }
  String? status;
  List<Data>? data;
  dynamic errorcode;
  dynamic errordesc;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['errorcode'] = errorcode;
    map['errordesc'] = errordesc;
    return map;
  }

}