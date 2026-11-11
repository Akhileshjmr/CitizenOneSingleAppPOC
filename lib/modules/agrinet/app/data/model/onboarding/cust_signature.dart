import 'dart:convert';

class CustSignature {
  String? docRef;
  List<int>? file;
  String? docName;
  int? docId;
  String? fileName;
  String? docUrl;
  String? issuingDate;
  String? verificationDate;
  String? expiryDate;
  String? extension;
  String? uploadFile;
  String? filePath;

  CustSignature({
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

  factory CustSignature.fromJson(Map<String, dynamic> json) {
    return CustSignature(
      docRef: json["docRef"],
      file: json["file"] != null ? base64Decode(json["file"]) : null,
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
  }

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
