import 'doc_photo.dart';

class CmOtherDoc {
  final String? docNo;
  final String? fileName;
  final int? docId;
  final DocName? docName;
  final String? docDesc;
  final int? noOfDays;
  final bool? isUploaded;
  final int? uploadDate;
  final String? issuePlace;
  final int? issueDate;
  final bool? isVerified;
  final String? docComments;
  final String? file;
  final DocPhoto? docPhoto;

  CmOtherDoc({
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

  factory CmOtherDoc.fromJson(Map<String, dynamic> json) {
    return CmOtherDoc(
      docNo: json['docNo'],
      fileName: json['fileName'],
      docId: json['docId'],
      docName:
          json['docName'] != null ? DocName.fromJson(json['docName']) : null,
      docDesc: json['docDesc'],
      noOfDays: json['noOfDays'],
      isUploaded: json['isUploaded'],
      uploadDate: json['uploadDate'],
      issuePlace: json['issuePlace'],
      issueDate: json['issueDate'],
      isVerified: json['isVerified'],
      docComments: json['docComments'],
      file: json['file'],
      docPhoto:
          json['docPhoto'] != null ? DocPhoto.fromJson(json['docPhoto']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'docNo': docNo,
      'fileName': fileName,
      'docId': docId,
      'docName': docName?.toJson(),
      'docDesc': docDesc,
      'noOfDays': noOfDays,
      'isUploaded': isUploaded,
      'uploadDate': uploadDate,
      'issuePlace': issuePlace,
      'issueDate': issueDate,
      'isVerified': isVerified,
      'docComments': docComments,
      'file': file,
      'docPhoto': docPhoto?.toJson(),
    };
  }
}

class DocName {
  final int? id;
  final String? type;
  final String? friendlyType;

  DocName({this.id, this.type, this.friendlyType});

  factory DocName.fromJson(Map<String, dynamic> json) {
    return DocName(
      id: json['id'],
      type: json['type'],
      friendlyType: json['friendlyType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'type': type, 'friendlyType': friendlyType};
  }
}
