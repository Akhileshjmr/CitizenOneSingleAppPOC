import '../PersonalLoan/Features.dart';

class Items {
  Items({
    this.key,
    this.name,
    this.imageUrl,
    this.price,
    this.offerPrice,
    this.isIncart,
    this.isInWishList,
    this.targetUrl,
    this.mortgage,
    this.rating,
    this.file,
    this.productDetails,
    this.vendorDetails,
    this.isAddedToWishList,
  });

  Items.fromJson(dynamic json) {
    key = json['key'];
    name = json['name'];
    imageUrl = json['imageUrl'];
    price = json['price'];
    offerPrice = json['offerPrice'];
    isIncart = json['isIncart'];
    isInWishList = json['isInWishList'];
    targetUrl = json['targetUrl'];
    mortgage =
        json['mortgage'] == null ? null : Features.fromJson(json['mortgage']);
    rating = json['rating'];
    file = json['file'];
    productDetails = json['productDetails'];
    vendorDetails = json['vendorDetails'];
    isAddedToWishList = json['isAddedToWishList'];
  }
  dynamic key;
  dynamic name;
  String? imageUrl;
  dynamic price;
  dynamic offerPrice;
  dynamic isIncart;
  dynamic isInWishList;
  dynamic targetUrl;
  Features? mortgage;
  dynamic rating;
  dynamic file;
  dynamic productDetails;
  dynamic vendorDetails;
  bool? isAddedToWishList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['name'] = name;
    map['imageUrl'] = imageUrl;
    map['price'] = price;
    map['offerPrice'] = offerPrice;
    map['isIncart'] = isIncart;
    map['isInWishList'] = isInWishList;
    map['targetUrl'] = targetUrl;
    if (mortgage != null) {
      map['mortgage'] = mortgage!.toJson();
    }
    map['rating'] = rating;
    map['file'] = file;
    map['productDetails'] = productDetails;
    map['vendorDetails'] = vendorDetails;
    map['isAddedToWishList'] = isAddedToWishList;
    return map;
  }
}
