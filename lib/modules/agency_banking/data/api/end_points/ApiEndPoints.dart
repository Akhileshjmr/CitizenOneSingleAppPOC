class ApiEndpoints {
  // Base URL
  static String baseUrl = "http://192.168.1.5:8087/abapigw/agent/channel/";
  static const String profittoBaseUrl =
      'https://frontab.citizenonezm.com:8243/profitto/v1';
  static const String emiUrl = "$profittoBaseUrl/channel/";
  static const String scoreUrl = "$profittoBaseUrl/mobile/customer/online-app/";
  static const String privacyPolicyURL =
      "https://zampost.com.zm/citizenone/assets/CITIZENONE%20PRIVACY%20POLICY.htm";
  /*publicly reachable server. Selectable via the "Update Base URL" dialog.*/
  static const String publicUrl =
      'https://frontab.citizenonezm.com:8243/abgw/v1/';
  static const String devUrl = 'http://192.168.1.5:8087/abapigw/agent/channel/';
  static const String insuranceBaseUrl =
      'https://frontab.citizenonezm.com:8243/insurance/v1';
  static const String insuranceProvider =
      "$insuranceBaseUrl/insurance-providers";

  // Auth Endpoints
  static const String login = "user-login-validation";

  /// Used only by the auto-login path driven by Citizen One's embedded
  /// module entry point. Same request/response contract as [login].
  static const String citizenUserLogin = "citizen-user-login-validation";
  static const String secondLogin = "login-user-dashboard";
  static const String requestOtp = "otp-validation";
  static const String otpValidation = "otp-failed-validation";
  static const String resetPassword = "user-reset-password";
  static const String lov = 'ab-get-lovs';
  static const String kycUpload = 'kyc-upload';
  static const String custEnroll = "ab-cust-enroll";
  static const String walletSearch = "ab-wallet-search";
  static const String accountSearch = "ab-query-account-details";
  static const String taxCal = "calculate-txn-fee";
  static const String pinValidation = "pin-validation";
  static const String accountTransaction = "transaction";
  static const String walletTransaction = "ab-wallet-transaction";
  static const String accountWallettransaction = "ab-wallet-acc-txn";
  static const String sendMoneyAccount = "send-money";
  static const String imageUpload = "ab-cbs-cust-image-upload";
  static const String walletCreation = "ab-wallet-create";
  static const String trustaccountWallet = "ab-corporate-wallet-transaction";
  static const String additionalAccount = "create-account";
  static const String changePin = "change-customer-pin";
  static const String resetPin = "reset-customer-pin";
  static const String loginQr = "get-walletqr-image";
  static const String userProfile = "user-profile-details";
  static const String transactionReceipt = "get-trans-receipt";
  static const String receiveRequest = "ab-get-cust-req";
  static const String transHistory = "transaction-history";
  static const String requestMoney = "ab-cust-req-money";
  static const String walletBalance = "check-wallet-balance";
  static const String accountBalance = "check-balance";
  static const String balanceSMS = "balance-enquery-sms";
  static const String bulkFt = 'bulk-transaction-extract';
  static const String bulkRegistration = 'bulk-wallet-cust-extract';
  static const String walletReceivePayment = 'ab-wallet-recv-ft';
  static const String languageLabels = 'language-labels';
  static const String loanAccount = 'ab-query-loan-account-detail';
  static const String loanRepayment = 'ab-loan-repayment';
  static const String productsList = 'ab-loan-products-list';
  static const String productGroup = 'ab-loan-product-groups';
  static const String loanApply = 'ab-loan-apply';
  static const String customerRegistration = 'ab-cust-reg';
  static const String customerSearch = 'ab-prof-cust-search';
  static const String casaAccountOpening = 'ab-casa-acc-open';
  static const String tdAccountOpening = 'ab-term-dep-acc-open';
  static const String emiCalculation = 'loan/emi';
  static const String eligibilityScore = 'get-customer-score';
  static const String applicationStatus = 'get-application-status';
  static const String custSpecific = 'ab-cust-spec_repayment';
  static const String accSpecific = 'ab-acc-spec_repayment';
  static const String chatbotUrl = "https://jmr-bot.jmrinfotech.com/chat";
  static const String collateral = 'get-collateral-details';
  static const String service_list = 'get-service-request-list';
  static const String logout = "user-logout";
  static const String searchKycUser = '$insuranceBaseUrl/users/kyc-search';
  static const String fetchLocationUrl =
      '$insuranceBaseUrl/users/select-box-values';
  static const String submitKycUrl =
      '$insuranceBaseUrl/users/save-customer-kyc';
  static const String fetchRecentHistoryUrl =
      '$insuranceBaseUrl/users/kyc-history';
  static const String getOtpKycUrl = '$insuranceBaseUrl/otp/get-otp';
  static const String resendOtpKycUrl = '$insuranceBaseUrl/otp/resend';
  static const String verifyOtpKycUrl = '$insuranceBaseUrl/otp/verify';
  static const String transMethod = "ab-get-trans-method";
}
