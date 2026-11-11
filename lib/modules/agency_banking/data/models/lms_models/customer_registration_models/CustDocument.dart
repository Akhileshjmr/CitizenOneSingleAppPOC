import 'dart:typed_data';

class CustDocument {
  String? docRef;
  Uint8List? file;
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

  CustDocument({
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

  factory CustDocument.fromJson(Map<String, dynamic> json) {
    return CustDocument(
      docRef: json['docRef'],
      file: json['file'] != null ? Uint8List.fromList(List<int>.from(json['file'])) : null,
      docName: json['docName'],
      docId: json['docId'],
      fileName: json['fileName'],
      docUrl: json['docUrl'],
      issuingDate: json['issuingDate'],
      verificationDate: json['verificationDate'],
      expiryDate: json['expiryDate'],
      extension: json['extension'],
      uploadFile: json['uploadFile'],
      filePath: json['filePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'docRef': docRef,
      'file': file?.toList(), // Converts Uint8List to List<int>
      'docName': docName,
      'docId': docId,
      'fileName': fileName,
      'docUrl': docUrl,
      'issuingDate': issuingDate,
      'verificationDate': verificationDate,
      'expiryDate': expiryDate,
      'extension': extension,
      'uploadFile': uploadFile,
      'filePath': filePath,
    };
  }
}
