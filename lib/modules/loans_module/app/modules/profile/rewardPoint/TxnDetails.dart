class TxnDetails {
  TxnDetails({
      this.txnId, 
      this.loyaltyId, 
      this.activityType, 
      this.date, 
      this.rewardPoint, 
      this.rewardAmount, 
      this.remark,});

  TxnDetails.fromJson(dynamic json) {
    txnId = json['txnId'];
    loyaltyId = json['loyaltyId'];
    activityType = json['activityType'];
    date = json['date'];
    rewardPoint = json['rewardPoint'];
    rewardAmount = json['rewardAmount'];
    remark = json['remark'];
  }
  String? txnId;
  String? loyaltyId;
  String? activityType;
  String? date;
  String? rewardPoint;
  String? rewardAmount;
  dynamic remark;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['txnId'] = txnId;
    map['loyaltyId'] = loyaltyId;
    map['activityType'] = activityType;
    map['date'] = date;
    map['rewardPoint'] = rewardPoint;
    map['rewardAmount'] = rewardAmount;
    map['remark'] = remark;
    return map;
  }

}