// import 'GdbVendorList.dart';
//
// class GdbVendorProductDetails {
//   String? productGroupName;
//   String? productId;
//   double? loanAmountMin;
//   double? loanAmountMax;
//   int? loanTermMin;
//   int? loanTermMax;
//   double? intrstRateMin;
//   double? intrstRateMax;
//   int? discountType;
//   double? discount;
//   int? expenceType;
//   double? expence;
//   List<GdbVendorList>? vendorList;
//
//   GdbVendorProductDetails({
//     this.productGroupName,
//     this.productId,
//     this.loanAmountMin,
//     this.loanAmountMax,
//     this.loanTermMin,
//     this.loanTermMax,
//     this.intrstRateMin,
//     this.intrstRateMax,
//     this.discountType,
//     this.discount,
//     this.expenceType,
//     this.expence,
//     this.vendorList,
//   });
//
//   factory GdbVendorProductDetails.fromJson(Map<String, dynamic> json) {
//     return GdbVendorProductDetails(
//       productGroupName: json['productGroupName'],
//       productId: json['productId'],
//       loanAmountMin: json['loanAmountMin'],
//       loanAmountMax: json['loanAmountMax'],
//       loanTermMin: json['loanTermMin'],
//       loanTermMax: json['loanTermMax'],
//       intrstRateMin: json['intrstRateMin'],
//       intrstRateMax: json['intrstRateMax'],
//       discountType: json['discountType'],
//       discount: json['discount'],
//       expenceType: json['expenceType'],
//       expence: json['expence'],
//       vendorList: (json['vendorList'] as List<dynamic>?)
//           ?.map((e) => GdbVendorList.fromJson(e))
//           .toList(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'productGroupName': productGroupName,
//       'productId': productId,
//       'loanAmountMin': loanAmountMin,
//       'loanAmountMax': loanAmountMax,
//       'loanTermMin': loanTermMin,
//       'loanTermMax': loanTermMax,
//       'intrstRateMin': intrstRateMin,
//       'intrstRateMax': intrstRateMax,
//       'discountType': discountType,
//       'discount': discount,
//       'expenceType': expenceType,
//       'expence': expence,
//       'vendorList': vendorList?.map((e) => e.toJson()).toList(),
//     };
//   }
// }


import 'GdbVendorList.dart';

class GdbVendorProductDetails {
  final String? productGroupName;
  final String? productId;
  final String? productDesc;
  final double? loanAmountMin;
  final double? loanAmountMax;
  final int? loanTermMin;
  final int? loanTermMax;
  final double? intrstRateMin;
  final double? intrstRateMax;
  final int? discountType;
  final double? discount;
  final int? expenseType;
  final double? expense;
  final List<GdbVendorList> vendorList;

  GdbVendorProductDetails({
    this.productGroupName,
    this.productId,
    this.productDesc,
    this.loanAmountMin,
    this.loanAmountMax,
    this.loanTermMin,
    this.loanTermMax,
    this.intrstRateMin,
    this.intrstRateMax,
    this.discountType,
    this.discount,
    this.expenseType,
    this.expense,
    List<GdbVendorList>? vendorList,
  }) : vendorList = vendorList ?? [];

  factory GdbVendorProductDetails.fromJson(Map<String, dynamic> json) {
    return GdbVendorProductDetails(
      productGroupName: json['productGroupName'] as String?,
      productId: json['productId'] as String?,
      productDesc: json['productDesc'] as String?,
      loanAmountMin: (json['loanAmountMin'] != null)
          ? (json['loanAmountMin'] as num).toDouble()
          : null,
      loanAmountMax: (json['loanAmountMax'] != null)
          ? (json['loanAmountMax'] as num).toDouble()
          : null,
      loanTermMin: json['loanTermMin'] != null
          ? (json['loanTermMin'] as num).toInt()
          : null,
      loanTermMax: json['loanTermMax'] != null
          ? (json['loanTermMax'] as num).toInt()
          : null,
      intrstRateMin: (json['intrstRateMin'] != null)
          ? (json['intrstRateMin'] as num).toDouble()
          : null,
      intrstRateMax: (json['intrstRateMax'] != null)
          ? (json['intrstRateMax'] as num).toDouble()
          : null,
      discountType: json['discountType'] != null
          ? (json['discountType'] as num).toInt()
          : null,
      discount: (json['discount'] != null)
          ? (json['discount'] as num).toDouble()
          : null,
      expenseType: json['expenceType'] != null
          ? (json['expenceType'] as num).toInt()
          : null,
      expense: (json['expence'] != null)
          ? (json['expence'] as num).toDouble()
          : null,
      vendorList: (json['vendorList'] as List<dynamic>?)
          ?.map((e) =>
          GdbVendorList.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productGroupName': productGroupName,
      'productId': productId,
      'productDesc': productDesc,
      'loanAmountMin': loanAmountMin,
      'loanAmountMax': loanAmountMax,
      'loanTermMin': loanTermMin,
      'loanTermMax': loanTermMax,
      'intrstRateMin': intrstRateMin,
      'intrstRateMax': intrstRateMax,
      'discountType': discountType,
      'discount': discount,
      'expenceType': expenseType, // keeping original key spelling for compatibility
      'expence': expense,
      'vendorList': vendorList.map((e) => e.toJson()).toList(),
    };
  }


}
