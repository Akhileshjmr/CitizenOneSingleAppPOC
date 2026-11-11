class GdbChScoreReqRes {
  int? _applicantId;
  String? _customerCode;
  int? _customerScore;
  int? _leadScore;
  String? _responseCode;
  String? _responseDesc;

  // Constructor
  GdbChScoreReqRes({
    int? applicantId,
    String? customerCode,
    int? customerScore,
    int? leadScore,
    String? responseCode,
    String? responseDesc,
  })  : _applicantId = applicantId,
        _customerCode = customerCode,
        _customerScore = customerScore,
        _leadScore = leadScore,
        _responseCode = responseCode,
        _responseDesc = responseDesc;

  // Getters
  int? get applicantId => _applicantId;
  String? get customerCode => _customerCode;
  int? get customerScore => _customerScore;
  int? get leadScore => _leadScore;
  String? get responseCode => _responseCode;
  String? get responseDesc => _responseDesc;

  // Setters
  set applicantId(int? value) => _applicantId = value;
  set customerCode(String? value) => _customerCode = value;
  set customerScore(int? value) => _customerScore = value;
  set leadScore(int? value) => _leadScore = value;
  set responseCode(String? value) => _responseCode = value;
  set responseDesc(String? value) => _responseDesc = value;

  // fromJson factory method
  factory GdbChScoreReqRes.fromJson(Map<String, dynamic> json) {
    return GdbChScoreReqRes(
      applicantId: json['applicantId'],
      customerCode: json['customerCode'],
      customerScore: json['customerScore'],
      leadScore: json['leadScore'],
      responseCode: json['responseCode'],
      responseDesc: json['responseDesc'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'applicantId': _applicantId,
      'customerCode': _customerCode,
      'customerScore': _customerScore,
      'leadScore': _leadScore,
      'responseCode': _responseCode,
      'responseDesc': _responseDesc,
    };
  }
}