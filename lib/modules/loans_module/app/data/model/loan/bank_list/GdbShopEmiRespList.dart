import '../PreApprove/preApproveBankList/GdbChBank.dart';
import 'EmiInfoDetails.dart';

class GdbShopEmiRespList {
  GdbShopEmiRespList({this.gdbChBank, this.emiInfoDetails});

  GdbShopEmiRespList.fromJson(dynamic json) {
    gdbChBank =
        json['gdbChBank'] != null
            ? GdbChBank.fromJson(json['gdbChBank'])
            : null;
    if (json['emiInfoDetails'] != null) {
      emiInfoDetails = [];
      json['emiInfoDetails'].forEach((v) {
        emiInfoDetails?.add(EmiInfoDetails.fromJson(v));
      });
    }
  }
  GdbChBank? gdbChBank;
  List<EmiInfoDetails>? emiInfoDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (gdbChBank != null) {
      map['gdbChBank'] = gdbChBank?.toJson();
    }
    if (emiInfoDetails != null) {
      map['emiInfoDetails'] = emiInfoDetails?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
