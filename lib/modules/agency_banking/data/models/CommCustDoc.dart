import 'dart:convert';
import 'common_models/HeaderInfo.dart';
import 'common_models/ServerMessage.dart';

class CommCustDoc {
  HeaderInfo? _headerInfo;
  ServerMessage? _resMessage;
  String? _documentType;
  String? _documentName;
  int? _dmDocument;
  String? _docUniqueNum;
  String? _remarks;
  DateTime? _uploadedDate;
  String? _imgPath;
  List<int>? _image;
  String? _customerId;
  String? _imageBase64;
  String? _branch;
  String? _uploadtype;

  // Constructor
  CommCustDoc({
    HeaderInfo? headerInfo,
    ServerMessage? resMessage,
    String? documentType,
    String? documentName,
    int? dmDocument,
    String? docUniqueNum,
    String? remarks,
    DateTime? uploadedDate,
    String? imgPath,
    List<int>? image,
    String? customerId,
    String? imageBase64,
    String? branch,
    String? uploadtype,
  })  : _headerInfo = headerInfo,
        _resMessage = resMessage,
        _documentType = documentType,
        _documentName = documentName,
        _dmDocument = dmDocument,
        _docUniqueNum = docUniqueNum,
        _remarks = remarks,
        _uploadedDate = uploadedDate,
        _imgPath = imgPath,
        _image = image,
        _customerId = customerId,
        _imageBase64 = imageBase64,
        _branch = branch,
        _uploadtype = uploadtype;

  // Getters and Setters
  HeaderInfo? get headerInfo => _headerInfo;
  set headerInfo(HeaderInfo? value) => _headerInfo = value;

  ServerMessage? get resMessage => _resMessage;
  set resMessage(ServerMessage? value) => _resMessage = value;

  String? get documentType => _documentType;
  set documentType(String? value) => _documentType = value;

  String? get documentName => _documentName;
  set documentName(String? value) => _documentName = value;

  int? get dmDocument => _dmDocument;
  set dmDocument(int? value) => _dmDocument = value;

  String? get docUniqueNum => _docUniqueNum;
  set docUniqueNum(String? value) => _docUniqueNum = value;

  String? get remarks => _remarks;
  set remarks(String? value) => _remarks = value;

  DateTime? get uploadedDate => _uploadedDate;
  set uploadedDate(DateTime? value) => _uploadedDate = value;

  String? get imgPath => _imgPath;
  set imgPath(String? value) => _imgPath = value;

  List<int>? get image => _image;
  set image(List<int>? value) => _image = value;

  String? get customerId => _customerId;
  set customerId(String? value) => _customerId = value;

  String? get imageBase64 => _imageBase64;
  set imageBase64(String? value) => _imageBase64 = value;

  String? get branch => _branch;
  set branch(String? value) => _branch = value;

  String? get uploadtype => _uploadtype;
  set uploadtype(String? value) => _uploadtype = value;

  // Factory method to create an instance from JSON
  factory CommCustDoc.fromJson(Map<String, dynamic> json) {
    return CommCustDoc(
      headerInfo: HeaderInfo.fromJson(json['headerInfo']),
      resMessage: ServerMessage.fromJson(json['resMessage']),
      documentType: json['documentType'] as String?,
      documentName: json['documentName'] as String?,
      dmDocument: json['dmDocument'] as int?,
      docUniqueNum: json['docUniqueNum'] as String?,
      remarks: json['remarks'] as String?,
      uploadedDate: json['uploadedDate'] != null ? DateTime.parse(json['uploadedDate']) : null,
      imgPath: json['imgPath'] as String?,
      image: json['image'] != null ? List<int>.from(json['image']) : null,
      customerId: json['customerId'] as String?,
      imageBase64: json['imageBase64'] as String?,
      branch: json['branch'] as String?,
      uploadtype: json['uploadType'] as String?,
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'headerInfo': _headerInfo?.toJson(),
      'resMessage': _resMessage?.toJson(),
      'documentType': _documentType,
      'documentName': _documentName,
      'dmDocument': _dmDocument,
      'docUniqueNum': _docUniqueNum,
      'remarks': _remarks,
      'uploadedDate': _uploadedDate?.toIso8601String(),
      'imgPath': _imgPath,
      'image': _image,
      'customerId': _customerId,
      'imageBase64': _imageBase64,
      'branch': _branch,
      'uploadtype': _uploadtype,
    };
  }
}