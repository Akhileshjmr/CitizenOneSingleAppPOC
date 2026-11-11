import 'AbLoanDetailLiqResp.dart';
import 'common_models/HeaderInfo.dart';
import 'common_models/ServerMessage.dart';

class AbQueryLoanDetails {
  String? _laonAccNum;
  String? _loanBrn;
  String? _esn;
  AbLoanDetailLiqResp? _loanDetResp;
  HeaderInfo? _headerInfo;
  ServerMessage? _resMessage;

  AbQueryLoanDetails({
    String? laonAccNum,
    String? loanBrn,
    String? esn,
    AbLoanDetailLiqResp? loanDetResp,
    HeaderInfo? headerInfo,
    ServerMessage? resMessage,
  })  : _laonAccNum = laonAccNum,
        _loanBrn = loanBrn,
        _esn = esn,
        _loanDetResp = loanDetResp,
        _headerInfo = headerInfo ?? HeaderInfo(),
        _resMessage = resMessage ?? ServerMessage();

  // Getters
  String? get laonAccNum => _laonAccNum;
  String? get loanBrn => _loanBrn;
  String? get esn => _esn;
  AbLoanDetailLiqResp? get loanDetResp => _loanDetResp;
  HeaderInfo? get headerInfo => _headerInfo;
  ServerMessage? get resMessage => _resMessage;

  // Setters
  set laonAccNum(String? value) => _laonAccNum = value;
  set loanBrn(String? value) => _loanBrn = value;
  set esn(String? value) => _esn = value;
  set loanDetResp(AbLoanDetailLiqResp? value) => _loanDetResp = value;
  set headerInfo(HeaderInfo? value) => _headerInfo = value;
  set resMessage(ServerMessage? value) => _resMessage = value;

  // Factory fromJson
  factory AbQueryLoanDetails.fromJson(Map<String, dynamic> json) {
    return AbQueryLoanDetails(
      laonAccNum: json['laonAccNum'],
      loanBrn: json['loanBrn'],
      esn: json['esn'],
      loanDetResp: json['loanDetResp'] != null
          ? AbLoanDetailLiqResp.fromJson(json['loanDetResp'])
          : null,
      headerInfo: json['headerInfo'] != null
          ? HeaderInfo.fromJson(json['headerInfo'])
          : null,
      resMessage: json['resMessage'] != null
          ? ServerMessage.fromJson(json['resMessage'])
          : null,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'laonAccNum': _laonAccNum,
      'loanBrn': _loanBrn,
      'esn': _esn,
      'loanDetResp': _loanDetResp?.toJson(),
      'headerInfo': _headerInfo?.toJson(),
      'resMessage': _resMessage?.toJson(),
    };
  }
}
