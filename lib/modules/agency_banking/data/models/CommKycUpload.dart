import 'common_models/HeaderInfo.dart';
import 'common_models/ServerMessage.dart';
class CommKycUpload {
  HeaderInfo _headerInfo;
  ServerMessage _resMessage;
  String? _documentType;
  String? _documentName;
  int? _dmDocument;
  String? _docUniqueNum;
  String? _remarks;
  String? _imgPath;
  String? _image; // Change to String
  String? _customerId;
  String? _imageBase64;
  String? _uploadtype;

  CommKycUpload({
    HeaderInfo? headerInfo,
    ServerMessage? resMessage,
    String? documentType,
    String? documentName,
    int? dmDocument,
    String? docUniqueNum,
    String? remarks,
    String? imgPath,
    String? image, // Change to String
    String? customerId,
    String? imageBase64,
    String? uploadtype,
  })
      :  _headerInfo = headerInfo ?? HeaderInfo(),
        _resMessage = resMessage ?? ServerMessage(),
        _documentType = documentType,
        _documentName = documentName,
        _dmDocument = dmDocument,
        _docUniqueNum = docUniqueNum,
        _remarks = remarks,
        _imgPath = imgPath,
        _image = image,
        _customerId = customerId,
        _imageBase64 = imageBase64,
        _uploadtype = uploadtype;

  // Getters and setters
  // Getter and setter for headerInfo
  HeaderInfo get headerInfo => _headerInfo;
  set headerInfo(HeaderInfo value) => _headerInfo = value;
  ServerMessage get resMessage => _resMessage;
  set resMessage(ServerMessage value) => _resMessage = value;

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

  String? get imgPath => _imgPath;

  set imgPath(String? value) => _imgPath = value;

  String? get image => _image;
  set image(String? value) => _image = value;

  String? get customerId => _customerId;

  set customerId(String? value) => _customerId = value;

  String? get imageBase64 => _imageBase64;

  set imageBase64(String? value) => _imageBase64 = value;
  String? get uploadtype => _uploadtype;
  set uploadtype(String? value) => _uploadtype = value;
  factory CommKycUpload.fromJson(Map<String, dynamic> json) {
    return CommKycUpload(
      headerInfo: json['headerInfo'] != null
          ? HeaderInfo.fromJson(json['headerInfo'])
          : HeaderInfo(),
      resMessage: json['resMessage'] != null
          ? ServerMessage.fromJson(json['resMessage'])
          : ServerMessage(),
      documentType: json['documentType'],
      documentName: json['documentName'],
      dmDocument: json['dmDocument'],
      docUniqueNum: json['docUniqueNum'],
      remarks: json['remarks'],
      imgPath: json['imgPath'],
      image: json['image'],
      customerId: json['customerId'],
      imageBase64: json['imageBase64'],
      uploadtype: json['uploadtype'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'headerInfo': _headerInfo.toJson(),
      'resMessage': _resMessage.toJson(),
      'documentType': _documentType,
      'documentName': _documentName,
      'dmDocument': _dmDocument,
      'docUniqueNum': _docUniqueNum,
      'remarks': _remarks,
      'imgPath': _imgPath,
      'image': _image, // Now a Base64 String
      'customerId': _customerId,
      'imageBase64': _imageBase64,
      'uploadtype': _uploadtype,
    };
  }
}