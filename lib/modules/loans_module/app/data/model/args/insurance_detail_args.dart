import '../insurance/PrdInsurList.dart';

class InsurencDetailArgs {
  /// Specifications to open order detail
  InsurencDetailArgs({
    required this.loanamt,
    required this.orderKey,
    required this.leadId,
    required this.catType,
  });
  final String loanamt;
  final String orderKey;
  final String leadId;
  final String catType;
}

class AutoInsurencDetailArgs {
  /// Specifications to open order detail
  AutoInsurencDetailArgs({
    required this.loanamt,
    required this.orderKey,
    required this.leadId,
    required this.requestid,
    required this.insurList,
  });
  final String loanamt;
  final String orderKey;
  final String leadId;
  final String requestid;
  final PrdInsurList? insurList;
}
