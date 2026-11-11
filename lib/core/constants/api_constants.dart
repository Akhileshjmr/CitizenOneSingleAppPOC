class ApiConstants {
  static const String profittoBaseUrl = 'http://192.168.1.81:2048/profitto';
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
}
