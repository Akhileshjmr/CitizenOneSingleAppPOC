class ApiConstants {
  static const String profittoBaseUrl = 'http://192.168.1.5:2048/profitto';
  static const String insuranceBaseUrl =
      'http://192.168.1.5:8087/api/insurance';
  //DEV http://192.168.1.81:2048/profitto
  // SIT http://192.168.1.5:2048/profitto
  // static const String baseUrl = 'http://192.168.3.69:8084';
  static const String searchKycUser = '$profittoBaseUrl/farmer/kyc-search';
  static const String fetchLocationUrl =
      '$profittoBaseUrl/farmer/farmer-on-board';
  static const String submitKycUrl =
      '$profittoBaseUrl/farmer/save-customer-kyc';
  static const String fetchRecentHistoryUrl =
      '$profittoBaseUrl/farmer/kyc-history';
  static const String getOtpKycUrl = '$profittoBaseUrl/api/otp/get-otp';
  static const String resendOtpKycUrl = getOtpKycUrl;
  static const String verifyOtpKycUrl = '$profittoBaseUrl/api/otp/verify';

  // Insurance
  // Dev 'http://192.168.3.69:8084/api/insurance';
  //  SIT 'http://192.168.1.5:8086/api/insurance';
  static const String getInsuranceCategories = '$insuranceBaseUrl/categories';
  static const String getMotorProductDetails =
      '$insuranceBaseUrl/motor/products';
  static const String getMotorMaintainence =
      '$insuranceBaseUrl/motor/maintenance';
  // '$insuranceBaseUrl/motor/maintenance';
  static const String fetchVehicleDetails =
      '$insuranceBaseUrl/motor/vehicle/search';
  static const String fetchMasterDataUrl = '$insuranceBaseUrl/master-data';
  static const String createVehicle = '$insuranceBaseUrl/motor/vehicle/create';
  static const String getRiskCategories =
      '$insuranceBaseUrl/motor/risk-categories';
  static const String getMotorInsuranceOtp = '$insuranceBaseUrl/otp/get-otp';
  static const String verifyMotorInsuranceOtp = '$insuranceBaseUrl/otp/verify';
  static const String compareQuotation =
      '$insuranceBaseUrl/motor/quotation/compare';
  static const String createQuotation = '$insuranceBaseUrl/motor/quotation';
  static const String createIndividualUser =
      '$insuranceBaseUrl/users/create-individual';
  static const String createInstantIssue =
      '$insuranceBaseUrl/motor/instant-issue';
  static const String searchInsuranceUser = '$insuranceBaseUrl/users/search';
  static const String downloadInvoiceUrl = '$insuranceBaseUrl/motor/policies';
  static const String insuranceTransactionUrl =
      '$insuranceBaseUrl/transactions';
  static const String wirepickRequest =
      '$insuranceBaseUrl/payments/wirepick/request';
  static const String printReceiptUrl =
      '$insuranceBaseUrl/motor/generate-policy-receipt';
  static const String issuePolicyByQuoteId =
      '$insuranceBaseUrl/motor/issue-policy-by-quoteid';
  static const String sendSMSForPolicyKeyFacts = '$insuranceBaseUrl/send-sms';
  static const String downloadInsuranceDocument =
      '$insuranceBaseUrl/download-doc/##PRODUCTID##';
}
