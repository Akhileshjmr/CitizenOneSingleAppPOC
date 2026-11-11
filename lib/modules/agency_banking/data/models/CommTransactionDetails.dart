import 'common_models/HeaderInfo.dart';
import 'common_models/ServerMessage.dart';

class CommTransactionDetails {
  HeaderInfo _headerInfo;
  ServerMessage _resMessage;
  String? _transId;
  String? _transactionPdf;

  // Constructor
  CommTransactionDetails({
    HeaderInfo? headerInfo,
    ServerMessage? resMessage,
    String? transId,
    String? transactionPdf,
  })  : _headerInfo = headerInfo ?? HeaderInfo(),
        _resMessage = resMessage ?? ServerMessage(),
        _transId = transId,
        _transactionPdf = transactionPdf;

  // Factory method to create an instance from JSON
  factory CommTransactionDetails.fromJson(Map<String, dynamic> json) {
    return CommTransactionDetails(
      headerInfo: HeaderInfo.fromJson(json['headerInfo']),
      resMessage: ServerMessage.fromJson(json['resMessage']),
      transId: json['transId'],
      transactionPdf: json['transactionPdf'],
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'headerInfo': _headerInfo.toJson(),
      'resMessage': _resMessage.toJson(),
      'transId': _transId,
      'transactionPdf': _transactionPdf,
    };
  }

  // Getters and Setters
  HeaderInfo get headerInfo => _headerInfo;
  set headerInfo(HeaderInfo value) => _headerInfo = value;

  ServerMessage get resMessage => _resMessage;
  set resMessage(ServerMessage value) => _resMessage = value;

  String? get transId => _transId;
  set transId(String? value) => _transId = value;

  String? get transactionPdf => _transactionPdf;
  set transactionPdf(String? value) => _transactionPdf = value;
}