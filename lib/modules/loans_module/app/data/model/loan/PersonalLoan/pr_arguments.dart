class PRArguments {
  /// Arguments to be passed when opening the quiz
  PRArguments({
    required this.filterval,
    required this.montlyInc,
    required this.montlyExc,
    required this.bankid,
    required this.bankName,
    required this.LimtMode,
  });

  /// Either [Sporting] or [Learning]
  final String filterval;
  final String montlyInc;
  final String montlyExc;
  final String bankid;
  final String bankName;
  final String LimtMode;
}
