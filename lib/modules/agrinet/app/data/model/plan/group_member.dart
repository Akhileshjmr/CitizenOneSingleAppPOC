// lib/app/data/model/plan/group_member.dart
import 'package:flutter/material.dart';

import '../common/ch_message.dart';
import '../common/option.dart';

class GroupMember {
  String? reqSecureKey;
  Option? custId;
  String? custName;
  String? mobileNo;
  dynamic landDetails;
  double? contribution;
  bool? isChecked;
  int? id;
  ChMessage? chMessage;

  // UI helper for entering contribution
  final TextEditingController contributionCtrl = TextEditingController();

  GroupMember({
    this.reqSecureKey,
    this.custId,
    this.custName,
    this.mobileNo,
    this.landDetails,
    this.contribution,
    this.isChecked,
    this.id,
    this.chMessage,
  }) {
    // initialize controller text if contribution present
    if (contribution != null) contributionCtrl.text = contribution.toString();
  }

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      reqSecureKey: json["reqSecureKey"]?.toString(),
      custId: json["custId"] != null ? Option.fromJson(json["custId"]) : null,
      custName: json["custName"],
      mobileNo: json["mobileNo"],
      landDetails: json["landDetails"],
      contribution:
          json["contribution"] != null
              ? double.tryParse(json["contribution"].toString())
              : null,
      isChecked: json["isChecked"],
      id:
          json["id"] is int
              ? json["id"] as int
              : (json["id"] != null
                  ? int.tryParse(json["id"].toString())
                  : null),
      chMessage:
          json["chMessage"] != null
              ? ChMessage.fromJson(json["chMessage"])
              : null,
    );
  }

  // toJson for debugging (not used by service which needs specific shape)
  Map<String, dynamic> toJson() {
    return {
      "reqSecureKey": reqSecureKey,
      "contribution":
          double.tryParse(contributionCtrl.text.trim()) ?? contribution ?? 0.0,
      "custId": custId?.toJson(),
      "custName": custName,
      "mobileNo": mobileNo ?? " ",
      "uniqueId": " ",
    };
  }
}
