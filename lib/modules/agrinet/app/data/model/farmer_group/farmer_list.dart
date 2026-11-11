class FarmersListResponse {
  List<FarmerDetail>? formerList;

  FarmersListResponse({this.formerList});

  factory FarmersListResponse.fromJson(Map<String, dynamic> json) {
    return FarmersListResponse(
      formerList:
          json["formerList"] == null
              ? null
              : List<FarmerDetail>.from(
                json["formerList"].map((x) => FarmerDetail.fromJson(x)),
              ),
    );
  }

  Map<String, dynamic> toJson() => {
    "formerList":
        formerList == null
            ? null
            : List<dynamic>.from(formerList!.map((x) => x.toJson())),
  };
}

class FarmerDetail {
  bool? isLeader;
  FarmerModal? farmer;
  ImageUrl? imageUrl;
  String? area;

  FarmerDetail({this.isLeader, this.farmer, this.imageUrl, this.area});

  factory FarmerDetail.fromJson(Map<String, dynamic> json) => FarmerDetail(
    isLeader: json["isLeader"],
    farmer:
        json["farmer"] == null ? null : FarmerModal.fromJson(json["farmer"]),
    imageUrl:
        json["imageUrl"] == null ? null : ImageUrl.fromJson(json["imageUrl"]),
    area: json["area"],
  );

  Map<String, dynamic> toJson() => {
    "isLeader": isLeader,
    "farmer": farmer?.toJson(),
    "imageUrl": imageUrl?.toJson(),
    "area": area,
  };
}

class FarmerModal {
  int? id;
  String? type;
  String? friendlyType;

  FarmerModal({this.id, this.type, this.friendlyType});

  factory FarmerModal.fromJson(Map<String, dynamic> json) => FarmerModal(
    id: json["id"],
    type: json["type"],
    friendlyType: json["friendlyType"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "friendlyType": friendlyType,
  };
}

class ImageUrl {
  String? docRef;
  String? file;
  String? docName;
  String? docId;
  String? fileName;
  String? docUrl;
  String? issuingDate;
  String? verificationDate;
  String? expiryDate;
  String? extension;
  String? uploadFile;
  String? filePath;

  ImageUrl({
    this.docRef,
    this.file,
    this.docName,
    this.docId,
    this.fileName,
    this.docUrl,
    this.issuingDate,
    this.verificationDate,
    this.expiryDate,
    this.extension,
    this.uploadFile,
    this.filePath,
  });

  factory ImageUrl.fromJson(Map<String, dynamic> json) => ImageUrl(
    docRef: json["docRef"],
    file: json["file"],
    docName: json["docName"],
    docId: json["docId"],
    fileName: json["fileName"],
    docUrl: json["docUrl"],
    issuingDate: json["issuingDate"],
    verificationDate: json["verificationDate"],
    expiryDate: json["expiryDate"],
    extension: json["extension"],
    uploadFile: json["uploadFile"],
    filePath: json["filePath"],
  );

  Map<String, dynamic> toJson() => {
    "docRef": docRef,
    "file": file,
    "docName": docName,
    "docId": docId,
    "fileName": fileName,
    "docUrl": docUrl,
    "issuingDate": issuingDate,
    "verificationDate": verificationDate,
    "expiryDate": expiryDate,
    "extension": extension,
    "uploadFile": uploadFile,
    "filePath": filePath,
  };
}
