import '../../common_models/HeaderInfo.dart';

class CasaAccountCreateRequest {
  HeaderInfo? headerInfo;
  String? accountType;
  String? customercode;
  String? productCode;
  DateTime? openingDate;
  double? openingBalance;
  String? modeOfOperation;
  bool? isVendorAccount;
  String? vendorName;
  bool? waiverOff;
  double? accountOpeningCharges;
  bool? chequeBook;
  bool? passBook;
  bool? standingInstruction;
  bool? overDraft;
  bool? nominationFacility;
  bool? atm;
  bool? teleBanking;
  bool? internetBanking;
  bool? mobileBanking;
  bool? smsBanking;
  bool? sms;
  bool? email;
  bool? both;

  CasaAccountCreateRequest({
    this.headerInfo,
    this.accountType,
    this.customercode,
    this.productCode,
    this.openingDate,
    this.openingBalance,
    this.modeOfOperation,
    this.isVendorAccount,
    this.vendorName,
    this.waiverOff,
    this.accountOpeningCharges,
    this.chequeBook,
    this.passBook,
    this.standingInstruction,
    this.overDraft,
    this.nominationFacility,
    this.atm,
    this.teleBanking,
    this.internetBanking,
    this.mobileBanking,
    this.smsBanking,
    this.sms,
    this.email,
    this.both,
  });

  factory CasaAccountCreateRequest.fromJson(Map<String, dynamic> json) {
    return CasaAccountCreateRequest(
      headerInfo: HeaderInfo.fromJson(json['headerInfo']),
      accountType: json['accountType'],
      customercode: json['customercode'],
      productCode: json['productCode'],
      openingDate: json['openingDate'] != null
          ? DateTime.parse(json['openingDate'])
          : null,
      openingBalance: (json['openingBalance'] as num?)?.toDouble(),
      modeOfOperation: json['modeOfOperation'],
      isVendorAccount: json['isVendorAccount'],
      vendorName: json['vendorName'],
      waiverOff: json['waiverOff'],
      accountOpeningCharges: (json['accountOpeningCharges'] as num?)?.toDouble(),
      chequeBook: json['chequeBook'],
      passBook: json['passBook'],
      standingInstruction: json['standingInstruction'],
      overDraft: json['overDraft'],
      nominationFacility: json['nominationFacility'],
      atm: json['atm'],
      teleBanking: json['teleBanking'],
      internetBanking: json['internetBanking'],
      mobileBanking: json['mobileBanking'],
      smsBanking: json['smsBanking'],
      sms: json['sms'],
      email: json['email'],
      both: json['both'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "headerInfo": headerInfo?.toJson(),
      'accountType': accountType,
      'customercode': customercode,
      'productCode': productCode,
      'openingDate': openingDate?.toIso8601String(),
      'openingBalance': openingBalance,
      'modeOfOperation': modeOfOperation,
      'isVendorAccount': isVendorAccount,
      'vendorName': vendorName,
      'waiverOff': waiverOff,
      'accountOpeningCharges': accountOpeningCharges,
      'chequeBook': chequeBook,
      'passBook': passBook,
      'standingInstruction': standingInstruction,
      'overDraft': overDraft,
      'nominationFacility': nominationFacility,
      'atm': atm,
      'teleBanking': teleBanking,
      'internetBanking': internetBanking,
      'mobileBanking': mobileBanking,
      'smsBanking': smsBanking,
      'sms': sms,
      'email': email,
      'both': both,
    };
  }
}