class L2lEmiCalculateRequest {
  double? _loanAmount;
  List<int>? _tenorList;
  List<double>? _interestRateList;
  String? _intCalcMethod;

  // Constructor
  L2lEmiCalculateRequest({
    double? loanAmount,
    List<int>? tenorList,
    List<double>? interestRateList,
    String? intCalcMethod,
  })  : _loanAmount = loanAmount,
        _tenorList = tenorList,
        _interestRateList = interestRateList,
        _intCalcMethod = intCalcMethod;

  // Getters
  double? get loanAmount => _loanAmount;
  List<int>? get tenorList => _tenorList;
  List<double>? get interestRateList => _interestRateList;
  String? get intCalcMethod => _intCalcMethod;

  // Setters
  set loanAmount(double? value) => _loanAmount = value;
  set tenorList(List<int>? value) => _tenorList = value;
  set interestRateList(List<double>? value) => _interestRateList = value;
  set intCalcMethod(String? value) => _intCalcMethod = value;

  // fromJson factory
  factory L2lEmiCalculateRequest.fromJson(Map<String, dynamic> json) {
    return L2lEmiCalculateRequest(
      loanAmount: (json['loanamount'] as num?)?.toDouble(),
      tenorList: (json['tenorList'] as List?)?.map((e) => e as int).toList(),
      interestRateList: (json['interestRateList'] as List?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      intCalcMethod: json['intCalcMethod'] as String?,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'loanamount': _loanAmount,
      'tenorList': _tenorList,
      'interestRateList': _interestRateList,
      'intCalcMethod': _intCalcMethod,
    };
  }
}
