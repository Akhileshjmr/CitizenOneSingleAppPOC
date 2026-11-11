import 'dart:convert';

class CommCustImageSign {
  String? documentType;
  String? documentName;
  int? dmDocument;
  String? docUniqueNum;
  String? remarks;
  DateTime? uploadedDate;
  String? imgPath;
  String? image;
  String? imageBase64;
  List<List<double>>? faceTwoDArray;

  CommCustImageSign({
    this.documentType,
    this.documentName,
    this.dmDocument,
    this.docUniqueNum,
    this.remarks,
    this.uploadedDate,
    this.imgPath,
    this.image,
    this.imageBase64,
    this.faceTwoDArray,
  });

  // Convert from JSON
  factory CommCustImageSign.fromJson(Map<String, dynamic> json) {
    return CommCustImageSign(
      documentType: json['documentType'],
      documentName: json['documentName'],
      dmDocument: json['dmDocument'],
      docUniqueNum: json['docUniqueNum'],
      remarks: json['remarks'],
      uploadedDate: json['uploadedDate'] != null
          ? DateTime.parse(json['uploadedDate'])
          : null,
      imgPath: json['imgPath'],
      image: json['image'] ,
      imageBase64: json['imageBase64'],
      faceTwoDArray: json['faceTwoDArray'] != null
          ? (json['faceTwoDArray'] as List)
          .map((row) => List<double>.from(row))
          .toList()
          : null,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'documentType': documentType,
      'documentName': documentName,
      'dmDocument': dmDocument,
      'docUniqueNum': docUniqueNum,
      'remarks': remarks,
      'uploadedDate': uploadedDate?.toIso8601String(),
      'imgPath': imgPath,
      'image': image,
      'imageBase64': imageBase64,
      'faceTwoDArray': faceTwoDArray
          ?.map((row) => row.map((val) => val).toList())
          .toList(),
    };
  }
}