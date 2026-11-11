class Data {
  Data({
      this.crbLoyaltyId, 
      this.crbMerchantNo, 
      this.crbRewardCurrency, 
      this.crbRewardBalance, 
      this.rwdCurrencyName, 
      this.rwdCashbackValue, 
      this.rwdRatioDeno, 
      this.drawChance, 
      this.links,});

  Data.fromJson(dynamic json) {
    crbLoyaltyId = json['crbLoyaltyId'];
    crbMerchantNo = json['crbMerchantNo'];
    crbRewardCurrency = json['crbRewardCurrency'];
    crbRewardBalance = json['crbRewardBalance'];
    rwdCurrencyName = json['rwdCurrencyName'];
    rwdCashbackValue = json['rwdCashbackValue'];
    rwdRatioDeno = json['rwdRatioDeno'];
    drawChance = json['drawChance'];
    links = json['links'].cast<String>();
  }
  String? crbLoyaltyId;
  String? crbMerchantNo;
  String? crbRewardCurrency;
  String? crbRewardBalance;
  String? rwdCurrencyName;
  String? rwdCashbackValue;
  String? rwdRatioDeno;
  String? drawChance;
  List<String>? links;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['crbLoyaltyId'] = crbLoyaltyId;
    map['crbMerchantNo'] = crbMerchantNo;
    map['crbRewardCurrency'] = crbRewardCurrency;
    map['crbRewardBalance'] = crbRewardBalance;
    map['rwdCurrencyName'] = rwdCurrencyName;
    map['rwdCashbackValue'] = rwdCashbackValue;
    map['rwdRatioDeno'] = rwdRatioDeno;
    map['drawChance'] = drawChance;
    map['links'] = this.links;
    return map;
  }

}