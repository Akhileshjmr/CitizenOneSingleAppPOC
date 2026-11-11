import 'CommWalletCharges.dart';
import 'common_models/HeaderInfo.dart';
import 'common_models/ServerMessage.dart';

class CommFeeCalculation {
  HeaderInfo? headerInfo;
  ServerMessage? resMessage;
  double? txnWalletFee;
  double? txnWalletTax;
  double? txnFee;
  String? consolidatedCharges;
  List<CommWalletCharges>? commWalletCharges;

  // Constructor
  CommFeeCalculation({
    this.headerInfo,
    this.resMessage,
    this.txnWalletFee,
    this.txnWalletTax,
    this.txnFee,
    this.consolidatedCharges,
    this.commWalletCharges,
  });

  // Factory method to create an instance from JSON
  factory CommFeeCalculation.fromJson(Map<String, dynamic> json) {
    return CommFeeCalculation(
      headerInfo: json['headerInfo'] != null
          ? HeaderInfo.fromJson(json['headerInfo'])
          : HeaderInfo(),
      resMessage: json['resMessage'] != null
          ? ServerMessage.fromJson(json['resMessage'])
          : ServerMessage(),
      txnWalletFee: json['txnWalletFee']?.toDouble(),
      txnWalletTax: json['txnWalletTax']?.toDouble(),
      txnFee: json['txnFee']?.toDouble(),
      consolidatedCharges: json['consolidatedCharges'],
      commWalletCharges: json['commWalletCharges'] != null
          ? (json['commWalletCharges'] as List)
          .map((item) => CommWalletCharges.fromJson(item))
          .toList()
          : null,
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo?.toJson(),
      'resMessage': resMessage?.toJson(),
      'txnWalletFee': txnWalletFee,
      'txnWalletTax': txnWalletTax,
      'txnFee': txnFee,
      'consolidatedCharges': consolidatedCharges,
      'commWalletCharges': commWalletCharges?.map((item) => item.toJson()).toList(),
    };
  }
}
