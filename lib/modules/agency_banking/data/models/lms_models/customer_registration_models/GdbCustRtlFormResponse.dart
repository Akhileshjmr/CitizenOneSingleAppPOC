import 'CustDocumentResponse.dart';
import 'GdbCustGenDetForm.dart';
import 'GdbCustRtlAddiInfoForm.dart';
import 'GdbCustRtlCommDetForm.dart';
import 'GdbCustRtlEmpDetForm.dart';

class GdbCustRtlFormResponse{
  bool? isTcAgreed;
  List<CustDocumentResponse>? docs;
  GdbCustGenDetForm? genDet;
  GdbCustRtlCommDetForm? commDet;
  GdbCustRtlEmpDetForm? empDetails;
  GdbCustRtlAddiInfoForm? addiDet;
  CustDocumentResponse? profilePic;
  CustDocumentResponse? signature;
  String? phone;
  String? kycStatus;

  GdbCustRtlFormResponse({
    this.isTcAgreed,
    this.docs,
    this.genDet,
    this.commDet,
    this.empDetails,
    this.addiDet,
    this.profilePic,
    this.phone,
    this.kycStatus,
    this.signature
  });

  factory GdbCustRtlFormResponse.fromJson(Map<String, dynamic> json) {
    return GdbCustRtlFormResponse(
      isTcAgreed: json['isTcAgreed'],
      docs: (json['docs'] as List<dynamic>?)
          ?.map((item) => CustDocumentResponse.fromJson(item))
          .toList(),
      genDet: json['genDet'] != null
          ? GdbCustGenDetForm.fromJson(json['genDet'])
          : null,
      commDet: json['commDet'] != null
          ? GdbCustRtlCommDetForm.fromJson(json['commDet'])
          : null,
      empDetails: json['empDetails'] != null
          ? GdbCustRtlEmpDetForm.fromJson(json['empDetails'])
          : null,
      addiDet: json['addiDet'] != null
          ? GdbCustRtlAddiInfoForm.fromJson(json['addiDet'])
          : null,
      profilePic: json['profilePic'] != null
          ? CustDocumentResponse.fromJson(json['profilePic'])
          : null,
      signature: json['signature'] != null
          ? CustDocumentResponse.fromJson(json['signature'])
          : null,

      phone: json['phone'],
      kycStatus: json['kycStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isTcAgreed': isTcAgreed,
      'docs': docs?.map((e) => e?.toJson()).toList(),
      'genDet': genDet?.toJson(),
      'commDet': commDet?.toJson(),
      'empDetails': empDetails?.toJson(),
      'addiDet': addiDet?.toJson(),
      'profilePic': profilePic?.toJson(),
      'signature': signature?.toJson(),
      'phone': phone,
      'kycStatus': kycStatus,
    };
  }
}



