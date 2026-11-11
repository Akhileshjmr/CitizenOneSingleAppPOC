import 'CommRequestMoney.dart';
import 'common_models/HeaderInfo.dart';
import 'common_models/ServerMessage.dart';

class CommRequestList {
  HeaderInfo? headerInfo;
  ServerMessage? resMessage;
  String? mobilenumber;
  List<CommRequestMoney>? requestlist;
  String? requestType;

  CommRequestList({
    this.headerInfo,
    this.resMessage,
    this.mobilenumber,
    this.requestlist,
    this.requestType,
  });

  // Factory method to create an instance from JSON
  factory CommRequestList.fromJson(Map<String, dynamic> json) {
    return CommRequestList(
      headerInfo: json['headerInfo'] != null
          ? HeaderInfo.fromJson(json['headerInfo'])
          : null,
      resMessage: json['resMessage'] != null
          ? ServerMessage.fromJson(json['resMessage'])
          : null,
      mobilenumber: json['mobilenumber'] as String?,
      requestlist: (json['requestlist'] as List<dynamic>?)
          ?.map((e) => CommRequestMoney.fromJson(e as Map<String, dynamic>))
          .toList(),
      requestType: json['requestType'] as String?,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo?.toJson(),
      'resMessage': resMessage?.toJson(),
      'mobilenumber': mobilenumber,
      'requestlist': requestlist?.map((e) => e.toJson()).toList(),
      'requestType': requestType,
    };
  }
}