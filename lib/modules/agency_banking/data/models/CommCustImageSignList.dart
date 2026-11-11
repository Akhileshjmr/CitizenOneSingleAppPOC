import 'CommCustImageSign.dart';
import 'common_models/HeaderInfo.dart';
import 'common_models/ServerMessage.dart';

class CommCustImageSignList {
  HeaderInfo? headerInfo;
  ServerMessage? resMessage;
  String? customerId;
  String? branch;
  String? transactionType;
  List<CommCustImageSign>? commCustImageSignList;

  // Constructor with a function body
  CommCustImageSignList({
    this.headerInfo,
    this.resMessage,
    this.customerId,
    this.branch,
    this.transactionType,
    this.commCustImageSignList,
  });

  // Deserialize from JSON
  factory CommCustImageSignList.fromJson(Map<String, dynamic> json) {
    return CommCustImageSignList(
      headerInfo: json['headerInfo'] != null
          ? HeaderInfo.fromJson(json['headerInfo'])
          : HeaderInfo(),
      resMessage: json['resMessage'] != null
          ? ServerMessage.fromJson(json['resMessage'])
          : ServerMessage(),
      customerId: json['customerId'],
      branch: json['branch'],
      transactionType: json['transactionType'],
      commCustImageSignList: json['commCustImageSignList'] != null
          ? List<CommCustImageSign>.from(json['commCustImageSignList']
          .map((x) => CommCustImageSign.fromJson(x)))
          : null,
    );
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo?.toJson(),
      'resMessage': resMessage?.toJson(),
      'customerId': customerId,
      'branch': branch,
      'transactionType': transactionType,
      'commCustImageSignList': commCustImageSignList != null
          ? commCustImageSignList!.map((x) => x.toJson()).toList()
          : null,
    };
  }
}
