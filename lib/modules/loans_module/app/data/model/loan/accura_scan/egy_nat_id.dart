///
class EgyNatId {
  ///
  EgyNatId({
    this.status,
    this.message,
    this.data,
  });

  ///
  factory EgyNatId.fromJson(Map<String, dynamic> json) => EgyNatId(
        status: json['Status'],
        message: json['Message'],
        data: json['data'] == null ? null : Data.fromJson(json['data']),
      );

  ///
  String? status;

  ///
  String? message;

  ///
  Data? data;

  ///
  Map<String, dynamic> toJson() => {
        'Status': status,
        'Message': message,
        'data': data?.toJson(),
      };
}

///
class Data {
  ///
  Data({
    this.ocrData,
  });

  ///
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        ocrData:
            json['OCRdata'] == null ? null : OcrData.fromJson(json['OCRdata']),
      );

  ///
  OcrData? ocrData;

  ///
  Map<String, dynamic> toJson() => {
        'OCRdata': ocrData?.toJson(),
      };
}

///
class OcrData {
  ///
  OcrData({
    this.idNo,
    this.face,
    this.lastName,
    this.firstName,
    this.address,
    this.date,
  });

  ///
  factory OcrData.fromJson(Map<String, dynamic> json) => OcrData(
        idNo: json['id_no'],
        face: json['face'] ?? '',
        lastName: json['last_name'],
        firstName: json['first_name'],
        address: json['address'],
        date: json['date'],
      );

  ///
  String? idNo;

  ///
  String? face;

  ///
  String? lastName;

  ///
  String? firstName;

  ///
  String? address;

  ///
  String? date;

  ///
  Map<String, dynamic> toJson() => {
        'id_no': idNo,
    'face': face,
        'last_name': lastName,
        'first_name': firstName,
        'address': address,
        'date': date,
      };
}
