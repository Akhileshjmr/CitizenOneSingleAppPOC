// class GdbCustRtlAppRequest<T> {
//   T? customerDet;
//   bool isDraft;
//   int? gdbCustId;
//   String? screenId;
//   String? reqSecureKey;
//   String? customerSearchStatus;
//
//   GdbCustRtlAppRequest({
//     this.customerDet,
//     this.isDraft = false,
//     this.gdbCustId,
//     this.screenId,
//     this.reqSecureKey,
//     this.customerSearchStatus,
//   });
//
//   /// Generic fromJson - pass a parser for T
//   factory GdbCustRtlAppRequest.fromJson(
//       Map<String, dynamic> json,
//       T Function(Map<String, dynamic>) fromJsonT,
//       ) {
//     return GdbCustRtlAppRequest<T>(
//       customerDet: json['customerDet'] != null
//           ? fromJsonT(json['customerDet'])
//           : null,
//       isDraft: json['isDraft'] ?? false,
//       gdbCustId: json['gdbCustId'],
//       screenId: json['screenId'],
//       reqSecureKey: json['reqSecureKey'],
//       customerSearchStatus: json['customerSearchStatus'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'customerDet': (customerDet as dynamic)?.toJson(),
//       'isDraft': isDraft,
//       'gdbCustId': gdbCustId,
//       'screenId': screenId,
//       'reqSecureKey': reqSecureKey,
//       'customerSearchStatus': customerSearchStatus,
//     };
//   }
// }

import '../../common_models/HeaderInfo.dart';

class GdbCustRtlAppRequest<T> {
  HeaderInfo? headerInfo;
  T? customerDet;
  bool isDraft;
  int? gdbCustId;
  String? screenId;
  String? reqSecureKey;
  String? customerSearchStatus;

  GdbCustRtlAppRequest({
    this.headerInfo,
    this.customerDet,
    this.isDraft = false,
    this.gdbCustId,
    this.screenId,
    this.reqSecureKey,
    this.customerSearchStatus,
  });

  /// Generic fromJson - pass parser for T
  factory GdbCustRtlAppRequest.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    return GdbCustRtlAppRequest<T>(
      headerInfo: json['headerInfo'] != null
          ? HeaderInfo.fromJson(json['headerInfo'])
          : null,
      customerDet: json['customerDet'] != null
          ? fromJsonT(json['customerDet'])
          : null,
      isDraft: json['isDraft'] ?? false,
      gdbCustId: json['gdbCustId'],
      screenId: json['screenId'],
      reqSecureKey: json['reqSecureKey'],
      customerSearchStatus: json['customerSearchStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo?.toJson(),
      'customerDet': (customerDet as dynamic)?.toJson(),
      'isDraft': isDraft,
      'gdbCustId': gdbCustId,
      'screenId': screenId,
      'reqSecureKey': reqSecureKey,
      'customerSearchStatus': customerSearchStatus,
    };
  }
}
