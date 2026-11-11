class CreditCardBenefitOptionsList {
  CreditCardBenefitOptionsList({
      this.friendlyType, 
      this.type,});

  CreditCardBenefitOptionsList.fromJson(dynamic json) {
    friendlyType = json['friendlyType'];
    type = json['type'];
  }
  String? friendlyType;
  String? type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['friendlyType'] = friendlyType;
    map['type'] = type;
    return map;
  }

}