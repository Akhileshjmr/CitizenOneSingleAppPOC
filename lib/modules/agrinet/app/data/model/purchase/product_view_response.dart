import 'dart:convert';

ProductViewResponse productResponseFromJson(String str) =>
    ProductViewResponse.fromJson(json.decode(str));

String productResponseToJson(ProductViewResponse data) =>
    json.encode(data.toJson());

class ProductViewResponse {
  final ProductDetails? product;
  final ComResp? comResp;

  ProductViewResponse({this.product, this.comResp});

  factory ProductViewResponse.fromJson(Map<String, dynamic> json) =>
      ProductViewResponse(
        product:
            json["product"] != null
                ? ProductDetails.fromJson(json["product"])
                : null,
        comResp:
            json["comResp"] != null ? ComResp.fromJson(json["comResp"]) : null,
      );

  Map<String, dynamic> toJson() => {
    "product": product?.toJson(),
    "comResp": comResp?.toJson(),
  };
}

class ProductDetails {
  final BasicDet? basicDet;
  final bool? isAddedInCart;
  final String? moreDesc;
  final int? noOfReviews;
  final List<Option>? options;
  final dynamic attrGroups;
  final List<dynamic>? images;

  ProductDetails({
    this.basicDet,
    this.isAddedInCart,
    this.moreDesc,
    this.noOfReviews,
    this.options,
    this.attrGroups,
    this.images,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
    basicDet:
        json["basicDet"] != null ? BasicDet.fromJson(json["basicDet"]) : null,
    isAddedInCart: json["isAddedInCart"],
    moreDesc: json["moreDesc"],
    noOfReviews: json["noOfReviews"],
    options:
        json["options"] == null
            ? []
            : List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
    attrGroups: json["attrGroups"],
    images:
        json["images"] == null
            ? []
            : List<dynamic>.from(json["images"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "basicDet": basicDet?.toJson(),
    "isAddedInCart": isAddedInCart,
    "moreDesc": moreDesc,
    "noOfReviews": noOfReviews,
    "options": options?.map((x) => x.toJson()).toList(),
    "attrGroups": attrGroups,
    "images": images,
  };
}

class BasicDet {
  final String? key;
  final String? name;
  final String? desc;
  final DefCategory? defCategory;
  final Vendor? vendor;
  final String? imgUrl;
  final String? retPrice;
  final String? salePrice;
  final String? offerPrice;
  final String? offerType;
  final dynamic offerVal;
  bool? isAddedInWish;
  final dynamic rating;
  final dynamic noOfRatings;
  final bool? isCheckoutPrd;
  final dynamic refundableType;
  final dynamic status;
  final dynamic productReqStatus;
  final dynamic id;
  final dynamic vendorPrice;
  final dynamic statusDate;

  BasicDet({
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

  factory BasicDet.fromJson(Map<String, dynamic> json) => BasicDet(
    key: json["key"],
    name: json["name"],
    desc: json["desc"],
    defCategory:
        json["defCategory"] != null
            ? DefCategory.fromJson(json["defCategory"])
            : null,
    vendor: json["vendor"] != null ? Vendor.fromJson(json["vendor"]) : null,
    imgUrl: json["imgUrl"],
    retPrice: json["retPrice"],
    salePrice: json["salePrice"],
    offerPrice: json["offerPrice"],
    offerType: json["offerType"],
    offerVal: json["offerVal"],
    isAddedInWish: json["isAddedInWish"],
    rating: json["rating"],
    noOfRatings: json["noOfRatings"],
    isCheckoutPrd: json["isCheckoutPrd"],
    refundableType: json["refundableType"],
    status: json["status"],
    productReqStatus: json["productReqStatus"],
    id: json["id"],
    vendorPrice: json["vendorPrice"],
    statusDate: json["statusDate"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "name": name,
    "desc": desc,
    "defCategory": defCategory?.toJson(),
    "vendor": vendor?.toJson(),
    "imgUrl": imgUrl,
    "retPrice": retPrice,
    "salePrice": salePrice,
    "offerPrice": offerPrice,
    "offerType": offerType,
    "offerVal": offerVal,
    "isAddedInWish": isAddedInWish,
    "rating": rating,
    "noOfRatings": noOfRatings,
    "isCheckoutPrd": isCheckoutPrd,
    "refundableType": refundableType,
    "status": status,
    "productReqStatus": productReqStatus,
    "id": id,
    "vendorPrice": vendorPrice,
    "statusDate": statusDate,
  };
}

class DefCategory {
  final String? key;
  final String? name;
  final String? imgUrl;
  final String? desc;
  final String? id;
  final String? prdType;

  DefCategory({
    this.key,
    this.name,
    this.imgUrl,
    this.desc,
    this.id,
    this.prdType,
  });

  factory DefCategory.fromJson(Map<String, dynamic> json) => DefCategory(
    key: json["key"],
    name: json["name"],
    imgUrl: json["imgUrl"],
    desc: json["desc"],
    id: json["id"],
    prdType: json["prdType"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "name": name,
    "imgUrl": imgUrl,
    "desc": desc,
    "id": id,
    "prdType": prdType,
  };
}

class Vendor {
  final String? key;
  final String? name;
  final String? logo;
  final bool? isOnline;

  Vendor({this.key, this.name, this.logo, this.isOnline});

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
    key: json["key"],
    name: json["name"],
    logo: json["logo"],
    isOnline: json["isOnline"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "name": name,
    "logo": logo,
    "isOnline": isOnline,
  };
}

class Option {
  final String? name;
  final List<String>? values;
  final bool? isMandatory;
  final String? optionType;
  final dynamic id;
  final dynamic mappingId;
  final dynamic gridKey;

  Option({
    this.name,
    this.values,
    this.isMandatory,
    this.optionType,
    this.id,
    this.mappingId,
    this.gridKey,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    name: json["name"],
    values:
        json["values"] == null
            ? []
            : List<String>.from(json["values"].map((x) => x)),
    isMandatory: json["isMandatory"],
    optionType: json["optionType"],
    id: json["id"],
    mappingId: json["mappingId"],
    gridKey: json["gridKey"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "values": values,
    "isMandatory": isMandatory,
    "optionType": optionType,
    "id": id,
    "mappingId": mappingId,
    "gridKey": gridKey,
  };
}

class ComResp {
  final dynamic reqSecureKey;
  final dynamic addiParams;
  final ChMessage? chMessage;
  final dynamic urlDecision;

  ComResp({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
  });

  factory ComResp.fromJson(Map<String, dynamic> json) => ComResp(
    reqSecureKey: json["reqSecureKey"],
    addiParams: json["addiParams"],
    chMessage:
        json["chMessage"] != null
            ? ChMessage.fromJson(json["chMessage"])
            : null,
    urlDecision: json["urlDecision"],
  );

  Map<String, dynamic> toJson() => {
    "reqSecureKey": reqSecureKey,
    "addiParams": addiParams,
    "chMessage": chMessage?.toJson(),
    "urlDecision": urlDecision,
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

  factory ChMessage.fromJson(Map<String, dynamic> json) => ChMessage(
    code: json["code"],
    message: json["message"],
    type: json["type"],
    dispType: json["dispType"],
    isError: json["isError"],
    subject: json["subject"],
    dataArr: json["dataArr"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "type": type,
    "dispType": dispType,
    "isError": isError,
    "subject": subject,
    "dataArr": dataArr,
  };
}
