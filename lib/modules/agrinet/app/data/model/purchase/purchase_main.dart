class PurchaseMain {
  List<ImgSliders>? imgSliders;
  List<dynamic>? featuredProducts;
  List<Category>? categories;
  dynamic offers;
  int? noOfWishlistItems;
  int? noOfCartItems;
  int? noOfInboxItems;
  ComResp? comResp;

  PurchaseMain({
    this.imgSliders,
    this.featuredProducts,
    this.categories,
    this.offers,
    this.noOfWishlistItems,
    this.noOfCartItems,
    this.noOfInboxItems,
    this.comResp,
  });

  factory PurchaseMain.fromJson(Map<String, dynamic> json) {
    return PurchaseMain(
      imgSliders:
          json["imgSliders"] == null
              ? []
              : List<ImgSliders>.from(
                json["imgSliders"].map((x) => ImgSliders.fromJson(x)),
              ),
      featuredProducts: json["featuredProducts"] ?? [],
      categories:
          json["categories"] == null
              ? []
              : List<Category>.from(
                json["categories"].map((x) => Category.fromJson(x)),
              ),
      offers: json["offers"],
      noOfWishlistItems: json["noOfWishlistItems"],
      noOfCartItems: json["noOfCartItems"],
      noOfInboxItems: json["noOfInboxItems"],
      comResp:
          json["comResp"] == null ? null : ComResp.fromJson(json["comResp"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "imgSliders":
        imgSliders == null ? [] : imgSliders!.map((x) => x.toJson()).toList(),
    "featuredProducts": featuredProducts,
    "categories":
        categories == null ? [] : categories!.map((x) => x.toJson()).toList(),
    "offers": offers,
    "noOfWishlistItems": noOfWishlistItems,
    "noOfCartItems": noOfCartItems,
    "noOfInboxItems": noOfInboxItems,
    "comResp": comResp?.toJson(),
  };
}

class ImgSliders {
  ImgAction? imgAction;

  ImgSliders({this.imgAction});

  factory ImgSliders.fromJson(Map<String, dynamic> json) => ImgSliders(
    imgAction:
        json["imgAction"] == null
            ? null
            : ImgAction.fromJson(json["imgAction"]),
  );

  Map<String, dynamic> toJson() => {"imgAction": imgAction?.toJson()};
}

class ImgAction {
  String? name;
  String? imgUrl;
  String? targetUrl;
  String? targetVal;
  String? type;

  ImgAction({
    this.name,
    this.imgUrl,
    this.targetUrl,
    this.targetVal,
    this.type,
  });

  factory ImgAction.fromJson(Map<String, dynamic> json) => ImgAction(
    name: json["name"],
    imgUrl: json["imgUrl"],
    targetUrl: json["targetUrl"],
    targetVal: json["targetVal"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "imgUrl": imgUrl,
    "targetUrl": targetUrl,
    "targetVal": targetVal,
    "type": type,
  };
}

class Category {
  String? key;
  String? name;
  String? imgUrl;
  String? desc;
  String? id;
  String? prdType;

  Category({
    this.key,
    this.name,
    this.imgUrl,
    this.desc,
    this.id,
    this.prdType,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
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

class ComResp {
  dynamic reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;

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
        json["chMessage"] == null
            ? null
            : ChMessage.fromJson(json["chMessage"]),
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
  String? code;
  String? message;
  String? type;
  String? dispType;
  bool? isError;
  String? subject;
  dynamic dataArr;

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

