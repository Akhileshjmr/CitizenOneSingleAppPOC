import 'dart:convert';
import 'common_models/HeaderInfo.dart';
import 'common_models/ServerMessage.dart';

class CommCustKYCEnrollment {
  HeaderInfo? headerInfo;
  ServerMessage? resMessage;
  String? kycRefno;
  String? custflname;
  String? kyccusttype;
  String? risklvl;
  String? authstat;
  String? kycccy;
  DateTime? brthdt;
  String? localAddrCountry;
  String? homeAddrCountry;
  String? nationality;
  String? salaryinc;
  String? rentalinc;
  String? invstinc;
  String? bussinc;
  String? prfbusinc;
  String? ovrsinc;
  String? otherincsrc;
  String? ttlinc;
  String? ttlntworth;
  String? accprps;
  DateTime? kycnxtrvwdt;
  String? kyccommnt;
  String? ssocmmnt;
  String? birthCountry;
  String? companyname;
  String? kyclocation;
  String? holdng;
  String? annlincm;
  String? bussline;
  String? fldnam;
  String? fldval;
  String? branch;
  String? pepremarks;
  String? pepflag;
  String? peptier;
  String? allowance;
  String? informalSector;
  String? royalDi;
  String? birthplace;

  CommCustKYCEnrollment({
    this.headerInfo,
    this.resMessage,
    this.kycRefno,
    this.custflname,
    this.kyccusttype,
    this.risklvl,
    this.authstat,
    this.kycccy,
    this.brthdt,
    this.localAddrCountry,
    this.homeAddrCountry,
    this.nationality,
    this.salaryinc,
    this.rentalinc,
    this.invstinc,
    this.bussinc,
    this.prfbusinc,
    this.ovrsinc,
    this.otherincsrc,
    this.ttlinc,
    this.ttlntworth,
    this.accprps,
    this.kycnxtrvwdt,
    this.kyccommnt,
    this.ssocmmnt,
    this.birthCountry,
    this.companyname,
    this.kyclocation,
    this.holdng,
    this.annlincm,
    this.bussline,
    this.fldnam,
    this.fldval,
    this.branch,
    this.pepremarks,
    this.pepflag,
    this.peptier,
    this.allowance,
    this.informalSector,
    this.royalDi,
    this.birthplace,
  });

  // Factory method to create an instance from JSON
  factory CommCustKYCEnrollment.fromJson(Map<String, dynamic> json) {
    return CommCustKYCEnrollment(
      headerInfo: json['headerInfo'] != null
          ? HeaderInfo.fromJson(json['headerInfo'])
          : null,
      resMessage: json['resMessage'] != null
          ? ServerMessage.fromJson(json['resMessage'])
          : null,
      kycRefno: json['kyc_refno'],
      custflname: json['custflname'],
      kyccusttype: json['kyccusttype'],
      risklvl: json['risklvl'],
      authstat: json['authstat'],
      kycccy: json['kycccy'],
      brthdt: json['brthdt'] != null ? DateTime.parse(json['brthdt']) : null,
      localAddrCountry: json['local_addr_country'],
      homeAddrCountry: json['home_addr_country'],
      nationality: json['nationality'],
      salaryinc: json['salaryinc'],
      rentalinc: json['rentalinc'],
      invstinc: json['invstinc'],
      bussinc: json['bussinc'],
      prfbusinc: json['prfbusinc'],
      ovrsinc: json['ovrsinc'],
      otherincsrc: json['otherincsrc'],
      ttlinc: json['ttlinc'],
      ttlntworth: json['ttlntworth'],
      accprps: json['accprps'],
      kycnxtrvwdt: json['kycnxtrvwdt'] != null
          ? DateTime.parse(json['kycnxtrvwdt'])
          : null,
      kyccommnt: json['kyccommnt'],
      ssocmmnt: json['ssocmmnt'],
      birthCountry: json['birth_country'],
      companyname: json['companyname'],
      kyclocation: json['kyclocation'],
      holdng: json['holdng'],
      annlincm: json['annlincm'],
      bussline: json['bussline'],
      fldnam: json['fldnam'],
      fldval: json['fldval'],
      branch: json['branch'],
      pepremarks: json['pepremarks'],
      pepflag: json['pepflag'],
      peptier: json['peptier'],
      allowance: json['allowance'],
      informalSector: json['informal_sector'],
      royalDi: json['royal_di'],
      birthplace: json['birthplace'],
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo?.toJson(),
      'resMessage': resMessage?.toJson(),
      'kyc_refno': kycRefno,
      'custflname': custflname,
      'kyccusttype': kyccusttype,
      'risklvl': risklvl,
      'authstat': authstat,
      'kycccy': kycccy,
      'brthdt': brthdt?.toIso8601String(),
      'local_addr_country': localAddrCountry,
      'home_addr_country': homeAddrCountry,
      'nationality': nationality,
      'salaryinc': salaryinc,
      'rentalinc': rentalinc,
      'invstinc': invstinc,
      'bussinc': bussinc,
      'prfbusinc': prfbusinc,
      'ovrsinc': ovrsinc,
      'otherincsrc': otherincsrc,
      'ttlinc': ttlinc,
      'ttlntworth': ttlntworth,
      'accprps': accprps,
      'kycnxtrvwdt': kycnxtrvwdt?.toIso8601String(),
      'kyccommnt': kyccommnt,
      'ssocmmnt': ssocmmnt,
      'birth_country': birthCountry,
      'companyname': companyname,
      'kyclocation': kyclocation,
      'holdng': holdng,
      'annlincm': annlincm,
      'bussline': bussline,
      'fldnam': fldnam,
      'fldval': fldval,
      'branch': branch,
      'pepremarks': pepremarks,
      'pepflag': pepflag,
      'peptier': peptier,
      'allowance': allowance,
      'informal_sector': informalSector,
      'royal_di': royalDi,
      'birthplace': birthplace,
    };
  }
}