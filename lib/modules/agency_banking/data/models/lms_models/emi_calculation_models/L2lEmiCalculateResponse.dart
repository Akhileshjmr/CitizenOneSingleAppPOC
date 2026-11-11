class L2lEmiCalculateResponse {
  List<double>? _loanEmiList;
  bool? _isError;
  String? _message;

  // Constructor
  L2lEmiCalculateResponse({
    List<double>? loanEmiList,
    bool? isError,
    String? message,
  })  : _loanEmiList = loanEmiList,
        _isError = isError,
        _message = message;

  // Getters
  List<double>? get loanEmiList => _loanEmiList;
  bool? get isError => _isError;
  String? get message => _message;

  // Setters
  set loanEmiList(List<double>? value) => _loanEmiList = value;
  set isError(bool? value) => _isError = value;
  set message(String? value) => _message = value;

  // fromJson factory
  factory L2lEmiCalculateResponse.fromJson(Map<String, dynamic> json) {
    return L2lEmiCalculateResponse(
      loanEmiList: (json['loanEmiList'] as List?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      isError: json['isError'] as bool?,
      message: json['message'] as String?,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'loanEmiList': _loanEmiList,
      'isError': _isError,
      'message': _message,
    };
  }
}
