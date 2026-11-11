class MarketItem {
  final String? arrivalDate;
  final String? timestamp;
  final String? minPrice;
  final String? market;
  final String? commodity;
  final String? state;
  final String? modalPrice;
  final String? maxPrice;
  final String? district;
  final String? variety;
  final String? message;

  MarketItem({
    this.arrivalDate,
    this.timestamp,
    this.minPrice,
    this.market,
    this.commodity,
    this.state,
    this.modalPrice,
    this.maxPrice,
    this.district,
    this.variety,
    this.message,
  });

  factory MarketItem.fromJson(Map<String, dynamic> json) {
    return MarketItem(
      arrivalDate: json['arrival_date'],
      timestamp: json['timestamp'],
      minPrice: json['min_price'],
      market: json['market'],
      commodity: json['commodity'],
      state: json['state'],
      modalPrice: json['modal_price'],
      maxPrice: json['max_price'],
      district: json['district'],
      variety: json['variety'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => {
    'arrival_date': arrivalDate,
    'timestamp': timestamp,
    'min_price': minPrice,
    'market': market,
    'commodity': commodity,
    'state': state,
    'modal_price': modalPrice,
    'max_price': maxPrice,
    'district': district,
    'variety': variety,
    'message': message,
  };
}
