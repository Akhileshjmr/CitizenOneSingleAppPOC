import 'TxnDetails.dart';

class RewardPointResp {
  RewardPointResp({
      this.totalRecords, 
      this.txnDetails, 
      this.loyaltyId, 
      this.totalPages, 
      this.status,});

  RewardPointResp.fromJson(dynamic json) {
    totalRecords = json['totalRecords'];
    if (json['txnDetails'] != null) {
      txnDetails = [];
      json['txnDetails'].forEach((v) {
        txnDetails?.add(TxnDetails.fromJson(v));
      });
    }
    loyaltyId = json['loyaltyId'];
    totalPages = json['totalPages'];
    status = json['status'];
  }
  String? totalRecords;
  List<TxnDetails>? txnDetails;
  dynamic loyaltyId;
  String? totalPages;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalRecords'] = totalRecords;
    if (txnDetails != null) {
      map['txnDetails'] = txnDetails?.map((v) => v.toJson()).toList();
    }
    map['loyaltyId'] = loyaltyId;
    map['totalPages'] = totalPages;
    map['status'] = status;
    return map;
  }

}