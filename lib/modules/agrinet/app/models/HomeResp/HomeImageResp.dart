import '../../data/model/common/ch_message.dart';
import '../../data/model/user/doc_photo.dart';

class homeViewResp {
  String? reqSecureKey;
  String? addiParams;
  ChMessage? chMessage;
  String? urlDecision;
  List<Slideimages>? slideimages;

  homeViewResp({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.slideimages,
  });

  homeViewResp.fromJson(Map<String, dynamic> json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    chMessage =
        json['chMessage'] != null
            ? new ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision = json['urlDecision'];
    if (json['slideimages'] != null) {
      slideimages = <Slideimages>[];
      json['slideimages'].forEach((v) {
        slideimages!.add(new Slideimages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reqSecureKey'] = reqSecureKey;
    data['addiParams'] = addiParams;
    if (chMessage != null) {
      data['chMessage'] = chMessage?.toJson();
    }
    data['urlDecision'] = urlDecision;
    if (slideimages != null) {
      data['slideimages'] = slideimages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slideimages {
  Null docNo;
  String? fileName;
  Null docId;
  Null docName;
  String? docDesc;
  Null noOfDays;
  Null isUploaded;
  Null uploadDate;
  Null issuePlace;
  Null issueDate;
  Null isVerified;
  Null docComments;
  Null file;
  DocPhoto? docPhoto;

  Slideimages({
    this.docNo,
    this.fileName,
    this.docId,
    this.docName,
    this.docDesc,
    this.noOfDays,
    this.isUploaded,
    this.uploadDate,
    this.issuePlace,
    this.issueDate,
    this.isVerified,
    this.docComments,
    this.file,
    this.docPhoto,
  });

  Slideimages.fromJson(Map<String, dynamic> json) {
    docNo = json['docNo'];
    fileName = json['fileName'];
    docId = json['docId'];
    docName = json['docName'];
    docDesc = json['docDesc'];
    noOfDays = json['noOfDays'];
    isUploaded = json['isUploaded'];
    uploadDate = json['uploadDate'];
    issuePlace = json['issuePlace'];
    issueDate = json['issueDate'];
    isVerified = json['isVerified'];
    docComments = json['docComments'];
    file = json['file'];
    docPhoto =
        json['docPhoto'] != null ? DocPhoto.fromJson(json['docPhoto']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['docNo'] = docNo;
    data['fileName'] = fileName;
    data['docId'] = docId;
    data['docName'] = docName;
    data['docDesc'] = docDesc;
    data['noOfDays'] = noOfDays;
    data['isUploaded'] = isUploaded;
    data['uploadDate'] = uploadDate;
    data['issuePlace'] = issuePlace;
    data['issueDate'] = issueDate;
    data['isVerified'] = isVerified;
    data['docComments'] = docComments;
    data['file'] = file;
    if (docPhoto != null) {
      data['docPhoto'] = docPhoto!.toJson();
    }
    return data;
  }
}
