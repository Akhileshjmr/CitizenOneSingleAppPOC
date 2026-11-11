class CategoryViewResponse {
  final CategoryData? category;
  final dynamic categoryFacets;
  final ComResp? comResp;

  CategoryViewResponse({this.category, this.categoryFacets, this.comResp});

  factory CategoryViewResponse.fromJson(Map<String, dynamic> json) {
    return CategoryViewResponse(
      category:
          json['category'] != null
              ? CategoryData.fromJson(json['category'])
              : null,
      categoryFacets: json['categoryFacets'],
      comResp:
          json['comResp'] != null ? ComResp.fromJson(json['comResp']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'category': category?.toJson(),
    'categoryFacets': categoryFacets,
    'comResp': comResp?.toJson(),
  };
}

class CategoryData {
  final BasicDet? basicDet;
  final List<ImgSlider>? imgSliders;
  final List<Product>? products;
  final List<BasicDet>? subCategories;

  CategoryData({
    this.basicDet,
    this.imgSliders,
    this.products,
    this.subCategories,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      basicDet:
          json['basicDet'] != null ? BasicDet.fromJson(json['basicDet']) : null,
      imgSliders:
          (json['imgSliders'] as List?)
              ?.map((e) => ImgSlider.fromJson(e))
              .toList(),
      products:
          (json['products'] as List?)?.map((e) => Product.fromJson(e)).toList(),
      subCategories:
          (json['subCategories'] as List?)
              ?.map((e) => BasicDet.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'basicDet': basicDet?.toJson(),
    'imgSliders': imgSliders?.map((e) => e.toJson()).toList(),
    'products': products?.map((e) => e.toJson()).toList(),
    'subCategories': subCategories?.map((e) => e.toJson()).toList(),
  };
}

class BasicDet {
  final String? key;
  final String? name;
  final String? imgUrl;
  final String? desc;
  final String? id;
  final String? prdType;

  BasicDet({
    this.key,
    this.name,
    this.imgUrl,
    this.desc,
    this.id,
    this.prdType,
  });

  factory BasicDet.fromJson(Map<String, dynamic> json) {
    return BasicDet(
      key: json['key'],
      name: json['name'],
      imgUrl: json['imgUrl'],
      desc: json['desc'],
      id: json['id'],
      prdType: json['prdType'],
    );
  }

  Map<String, dynamic> toJson() => {
    'key': key,
    'name': name,
    'imgUrl': imgUrl,
    'desc': desc,
    'id': id,
    'prdType': prdType,
  };
}

class ImgSlider {
  final ImgAction? imgAction;

  ImgSlider({this.imgAction});

  factory ImgSlider.fromJson(Map<String, dynamic> json) {
    return ImgSlider(
      imgAction:
          json['imgAction'] != null
              ? ImgAction.fromJson(json['imgAction'])
              : null,
    );
  }

  Map<String, dynamic> toJson() => {'imgAction': imgAction?.toJson()};
}

class ImgAction {
  final String? name;
  final String? imgUrl;
  final String? targetUrl;
  final String? targetVal;
  final String? type;

  ImgAction({
    this.name,
    this.imgUrl,
    this.targetUrl,
    this.targetVal,
    this.type,
  });

  factory ImgAction.fromJson(Map<String, dynamic> json) {
    return ImgAction(
      name: json['name'],
      imgUrl: json['imgUrl'],
      targetUrl: json['targetUrl'],
      targetVal: json['targetVal'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'imgUrl': imgUrl,
    'targetUrl': targetUrl,
    'targetVal': targetVal,
    'type': type,
  };
}

class Product {
  final String? key;
  final String? name;
  final String? desc;
  final BasicDet? defCategory;
  final Vendor? vendor;
  final String? imgUrl;
  final String? retPrice;
  final String? salePrice;
  final String? offerPrice;
  final String? offerType;
  final String? offerVal;
  bool? isAddedInWish;
  final double? rating;
  final int? noOfRatings;
  final bool? isCheckoutPrd;
  final String? refundableType;
  final String? status;
  final String? productReqStatus;
  final String? id;
  final String? vendorPrice;
  final String? statusDate;

  Product({
    this.key,
    this.name,
    this.desc,
    this.defCategory,
    this.vendor,
    this.imgUrl,
    this.retPrice,
    this.salePrice,
    this.offerPrice,
    this.offerType,
    this.offerVal,
    this.isAddedInWish,
    this.rating,
    this.noOfRatings,
    this.isCheckoutPrd,
    this.refundableType,
    this.status,
    this.productReqStatus,
    this.id,
    this.vendorPrice,
    this.statusDate,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      key: json['key'],
      name: json['name'],
      desc: json['desc'],
      defCategory:
          json['defCategory'] != null
              ? BasicDet.fromJson(json['defCategory'])
              : null,
      vendor: json['vendor'] != null ? Vendor.fromJson(json['vendor']) : null,
      imgUrl: json['imgUrl'],
      retPrice: json['retPrice'],
      salePrice: json['salePrice'],
      offerPrice: json['offerPrice'],
      offerType: json['offerType'],
      offerVal: json['offerVal'],
      isAddedInWish: json['isAddedInWish'],
      rating: (json['rating'] as num?)?.toDouble(),
      noOfRatings: json['noOfRatings'],
      isCheckoutPrd: json['isCheckoutPrd'],
      refundableType: json['refundableType'],
      status: json['status'],
      productReqStatus: json['productReqStatus'],
      id: json['id'],
      vendorPrice: json['vendorPrice'],
      statusDate: json['statusDate'],
    );
  }

  Map<String, dynamic> toJson() => {
    'key': key,
    'name': name,
    'desc': desc,
    'defCategory': defCategory?.toJson(),
    'vendor': vendor?.toJson(),
    'imgUrl': imgUrl,
    'retPrice': retPrice,
    'salePrice': salePrice,
    'offerPrice': offerPrice,
    'offerType': offerType,
    'offerVal': offerVal,
    'isAddedInWish': isAddedInWish,
    'rating': rating,
    'noOfRatings': noOfRatings,
    'isCheckoutPrd': isCheckoutPrd,
    'refundableType': refundableType,
    'status': status,
    'productReqStatus': productReqStatus,
    'id': id,
    'vendorPrice': vendorPrice,
    'statusDate': statusDate,
  };
}

class Vendor {
  final String? key;
  final String? name;
  final String? logo;
  final bool? isOnline;

  Vendor({this.key, this.name, this.logo, this.isOnline});

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      key: json['key'],
      name: json['name'],
      logo: json['logo'],
      isOnline: json['isOnline'],
    );
  }

  Map<String, dynamic> toJson() => {
    'key': key,
    'name': name,
    'logo': logo,
    'isOnline': isOnline,
  };
}

class ComResp {
  final String? reqSecureKey;
  final dynamic addiParams;
  final ChMessage? chMessage;
  final dynamic urlDecision;

  ComResp({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
  });

  factory ComResp.fromJson(Map<String, dynamic> json) {
    return ComResp(
      reqSecureKey: json['reqSecureKey'],
      addiParams: json['addiParams'],
      chMessage:
          json['chMessage'] != null
              ? ChMessage.fromJson(json['chMessage'])
              : null,
      urlDecision: json['urlDecision'],
    );
  }

  Map<String, dynamic> toJson() => {
    'reqSecureKey': reqSecureKey,
    'addiParams': addiParams,
    'chMessage': chMessage?.toJson(),
    'urlDecision': urlDecision,
  };
}

class ChMessage {
  final String? code;
  final String? message;
  final String? type;
  final String? dispType;
  final bool? isError;
  final String? subject;
  final dynamic dataArr;

  ChMessage({
    this.code,
    this.message,
    this.type,
    this.dispType,
    this.isError,
    this.subject,
    this.dataArr,
  });

  factory ChMessage.fromJson(Map<String, dynamic> json) {
    return ChMessage(
      code: json['code'],
      message: json['message'],
      type: json['type'],
      dispType: json['dispType'],
      isError: json['isError'],
      subject: json['subject'],
      dataArr: json['dataArr'],
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'message': message,
    'type': type,
    'dispType': dispType,
    'isError': isError,
    'subject': subject,
    'dataArr': dataArr,
  };
}
