
class ModuleCode {
  // Wallet / CBS
  static const String walletToCbs = 'WALL_CBS';
  static const String cbsToWallet = 'CBS_WALL';

  // Send / Receive Money
  static const String sendMoney = 'SM';
  static const String requestMoney = 'REQ_MONEY';
  static const String receiveMoney = 'RM';
  static const String receiveRequest = 'RECV_REQ';
  static const String recurringPayment = 'REC_PAY';

  // Cash Transactions
  static const String deposit = 'DEP';
  static const String withdrawal = 'WDL';
  static const String loanRepayment = 'LR';
  static const String balanceEnquiry = 'BALANCEENQUIRY';

  // Customer / Account
  static const String customerCreation = 'CUST_CR';
  static const String accountCreation = 'ACC_CR';
  static const String trustAccount = 'TRUST_ACC';

  // Fund Transfer
  static const String fundTransfer = 'FT';
  static const String domesticFt = 'DOM_FT';
  static const String internationalFt = 'INTL_FT';

  // Wallet
  static const String walletRegistration = 'WALL_REG';
  static const String bulkWalletRegistration = 'BULK_WALL_REG';

  // Repayment
  static const String customerRepayment = 'CUST_REPAY';
  static const String accountRepayment = 'ACC_REPAY';

  // Payments
  static const String corporatePayment = 'CORP_PAY';
  static const String billPayment = 'BP';

  // Loans / Applications
  static const String retailLoanApplication = 'RET_LOAN_APP';
  static const String applicationStatus = 'APL_STATUS';

  // KYC
  static const String kycRegistration = 'KYC_REG';
}
