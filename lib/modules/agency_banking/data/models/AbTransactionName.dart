import 'AbTransactionMethod.dart';
import 'common_models/HeaderInfo.dart';
import 'common_models/ServerMessage.dart';


class AbTransactionName {
  HeaderInfo? headerInfo;
  ServerMessage? resMessage;
  List<AbTransactionMethod>? abTransactionMethod;
  String? transname;
  String? menuName;

  // Constructor
  AbTransactionName({
    this.headerInfo,
    this.resMessage,
    this.abTransactionMethod,
    this.transname,
    this.menuName,
  });

  // Factory method to create object from JSON
  factory AbTransactionName.fromJson(Map<String, dynamic> json) {
    return AbTransactionName(
      headerInfo: json['headerInfo'] != null
          ? HeaderInfo.fromJson(json['headerInfo'])
          : null,
      resMessage: json['resMessage'] != null
          ? ServerMessage.fromJson(json['resMessage'])
          : null,
      abTransactionMethod: (json['abTransactionMethod'] as List<dynamic>?)
          ?.map((item) => AbTransactionMethod.fromJson(item))
          .toList(),
      transname: json['transname'],
      menuName: json['menuName'],
    );
  }

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo?.toJson(),
      'resMessage': resMessage?.toJson(),
      'abTransactionMethod':
      abTransactionMethod?.map((item) => item.toJson()).toList(),
      'transname': transname,
      'menuName': menuName,
    };
  }
}