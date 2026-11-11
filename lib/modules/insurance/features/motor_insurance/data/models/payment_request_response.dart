// =============================================================================
// PaymentRequestResponse  —  Response model for payment request API
// =============================================================================

class PaymentRequestResponse {
  final String? code;
  final String? status;
  final String? message;
  final String? reference;
  final String? gwId;
  final String? mnoRequestId;
  final String? mnoFintxnId;
  final String? otpUrl;
  final String? paymentRefNo;

  PaymentRequestResponse({
    this.code,
    this.status,
    this.message,
    this.reference,
    this.gwId,
    this.mnoRequestId,
    this.mnoFintxnId,
    this.otpUrl,
    this.paymentRefNo,
  });

  factory PaymentRequestResponse.fromJson(Map<String, dynamic> json) {
    return PaymentRequestResponse(
      code: json['code'] as String?,
      status: json['status'] as String?,
      message: json['message'] as String?,
      reference: json['reference'] as String?,
      gwId: json['gw_id'] as String?,
      mnoRequestId: json['mno_request_id'] as String?,
      mnoFintxnId: json['mno_fintxn_id'] as String?,
      otpUrl: json['otpUrl'] as String?,
      paymentRefNo: json['paymentRefNo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
      'message': message,
      'reference': reference,
      'gw_id': gwId,
      'mno_request_id': mnoRequestId,
      'mno_fintxn_id': mnoFintxnId,
      'otpUrl': otpUrl,
      'paymentRefNo': paymentRefNo
    };
  }

  bool get isSuccessful {
    return status == 'SUCCESSFUL' || status == 'ACCEPTED';
  }
}
