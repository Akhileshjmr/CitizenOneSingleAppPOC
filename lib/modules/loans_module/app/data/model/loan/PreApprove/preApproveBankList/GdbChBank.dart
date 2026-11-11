import '../../bank_list/GdbChMediaAction.dart';

class GdbChBank {
  GdbChBank({
    this.key,
    this.productKey,
    this.name,
    this.urlAction,
    this.gdbChMediaAction,
  });

  GdbChBank.fromJson(dynamic json) {
    key = json['key'];
    productKey = json['productKey'];
    name = json['name'];
    urlAction = json['urlAction'];
    gdbChMediaAction =
        json['gdbChMediaAction'] != null
            ? GdbChMediaAction.fromJson(json['gdbChMediaAction'])
            : null;
  }
  String? key;
  dynamic productKey;
  String? name;
  dynamic urlAction;
  GdbChMediaAction? gdbChMediaAction;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['productKey'] = productKey;
    map['name'] = name;
    map['urlAction'] = urlAction;
    if (gdbChMediaAction != null) {
      map['gdbChMediaAction'] = gdbChMediaAction?.toJson();
    }
    return map;
  }
}
