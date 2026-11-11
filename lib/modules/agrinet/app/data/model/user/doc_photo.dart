class DocPhoto {
  final String? docRef;
  final String? file;
  final String? docName;
  final int? docId;
  final String? fileName;
  final String? docUrl;
  final int? issuingDate;
  final int? verificationDate;
  final int? expiryDate;
  final String? extension;
  final String? uploadFile;
  final String? filePath;

  DocPhoto({
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

  factory DocPhoto.fromJson(Map<String, dynamic> json) {
    return DocPhoto(
      docRef: json['docRef'],
      file: json['file'],
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
      'file': file,
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
