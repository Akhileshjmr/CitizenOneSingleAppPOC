class PaymentSuccessEntity {
  final String code;
  final String status;
  final String message;
  final String reference;
  final String gwid;
  final String mnorequestid;
  final String mnofintxnid;
  final String paymentRefNo;
  final String otpUrl;
  PaymentSuccessEntity({
    required this.code,
    required this.status,
    required this.reference,
    required this.message,
    required this.gwid,
    required this.mnorequestid,
    required this.mnofintxnid,
    required this.paymentRefNo,
    required this.otpUrl,
  });
}
