// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Citizen One';

  @override
  String get appVersion => 'v1.0.0';

  @override
  String get navHome => 'Home';

  @override
  String get navServices => 'Services';

  @override
  String get navAlerts => 'Alerts';

  @override
  String get navProfile => 'Profile';

  @override
  String get navPay => 'Pay';

  @override
  String get headerDashboard => 'Dashboard';

  @override
  String get headerGreeting => 'Good Morning';

  @override
  String get headerLocation => 'Lusaka';

  @override
  String get agentWorkContext => 'WORK CONTEXT';

  @override
  String get settingsLabel => 'Settings';

  @override
  String get loginWelcomeTitle => 'Welcome to CitizenOne';

  @override
  String get loginSubtitle => 'Sign in to continue';

  @override
  String get loginSelectPersona => 'Select Personal';

  @override
  String get loginChooseRole => 'Choose your role';

  @override
  String get authContextSelect => 'Select Context';

  @override
  String get authRoleCitizen => 'Citizen';

  @override
  String get authRoleCitizenDesc => 'Access personal services and applications';

  @override
  String get authRoleAgent => 'Service Agent';

  @override
  String get authRoleAgentDesc => 'Manage applications and help citizens';

  @override
  String get loginValidationSelectPersona => 'Please select a personal';

  @override
  String get loginUsernameLabel => 'Username';

  @override
  String get loginUsernameHint => 'Enter your username';

  @override
  String get loginValidationUsernameRequired => 'Username is required';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordHint => 'Enter your password';

  @override
  String get loginValidationPasswordRequired => 'Password is required';

  @override
  String loginButtonAs(String roleName) {
    return 'Login as $roleName';
  }

  @override
  String get loginButton => 'Login';

  @override
  String get loginMobileLabel => 'Mobile Number';

  @override
  String get loginMobileHint => 'Enter your mobile number';

  @override
  String get loginValidationMobileRequired => 'Mobile number is required';

  @override
  String get loginForgotPassword => 'Forgot Password?';

  @override
  String get loginForgotPasswordPending =>
      'Forgot password flow is coming soon.';

  @override
  String get forgotPasswordBrand => 'CitizenOne / ZAMPOST';

  @override
  String get forgotPasswordTitle => 'Forgot Password?';

  @override
  String get forgotPasswordBody =>
      'Enter your registered mobile number below — we\'ll verify your identity and guide you through resetting it.';

  @override
  String get forgotPasswordMobileLabel => 'Mobile Number';

  @override
  String get forgotPasswordMobileHint => 'Enter your mobile number';

  @override
  String get forgotPasswordMobileRequired =>
      'Please enter a valid mobile number';

  @override
  String get forgotPasswordInfoBanner =>
      'For your security, we will send a one-time password (OTP) to verify your identity before allowing you to reset your password.';

  @override
  String get forgotPasswordContinue => 'Continue';

  @override
  String get forgotPasswordRememberPrefix => 'Remember your password?';

  @override
  String get forgotPasswordSignIn => 'Sign In';

  @override
  String get forgotPasswordOtpTitle => 'OTP Verification';

  @override
  String get forgotPasswordOtpCardTitle => 'One Time Verification';

  @override
  String get forgotPasswordOtpBody =>
      'To verify your identity, enter the One-Time Password (OTP) sent to your registered mobile number.';

  @override
  String get forgotPasswordOtpRequired => 'OTP is required';

  @override
  String get forgotPasswordOtpInvalid => 'Please enter a valid 6-digit OTP';

  @override
  String get forgotPasswordOtpSec => 'Sec';

  @override
  String forgotPasswordOtpAttemptsLeft(int count) {
    return 'Attempts Left $count';
  }

  @override
  String get forgotPasswordOtpResend => 'Resend OTP';

  @override
  String get forgotPasswordOtpResent =>
      'A new OTP has been sent to your registered mobile number.';

  @override
  String get forgotPasswordOtpVerify => 'Verify OTP';

  @override
  String get createPasswordTitle => 'Create Password';

  @override
  String get createPasswordSubtitle => 'Set a strong password for your account';

  @override
  String get createPasswordNewLabel => 'New Password';

  @override
  String get createPasswordNewHint => 'Enter Your New Password';

  @override
  String get createPasswordConfirmLabel => 'Confirm Password';

  @override
  String get createPasswordConfirmHint => 'Enter Your Confirm Password';

  @override
  String get createPasswordRulesTitle => 'Your password must contain:';

  @override
  String get createPasswordMismatch => 'Passwords do not match';

  @override
  String get createPasswordSubmit => 'Submit';

  @override
  String get passwordRuleLength => '8 - 30 characters';

  @override
  String get passwordRuleUpper => 'An upper case letter (A-Z)';

  @override
  String get passwordRuleLower => 'A lower case letter (a-z)';

  @override
  String get passwordRuleDigit => 'A number (0-9)';

  @override
  String get passwordRuleSpecial => 'A special character';

  @override
  String get passwordRuleNoSuccessiveOver3 => 'No successive characters over 3';

  @override
  String get passwordRuleNoCharMoreThan3 =>
      'No character repeated more than 3 times';

  @override
  String get passwordSetupRequiredTitle => 'Password Setup Required';

  @override
  String get passwordSetupRequiredBody =>
      'Your Account has not yet completed the initial password setup. Please reset your password to continue';

  @override
  String get passwordSetupRequiredContinue => 'Continue';

  @override
  String get passwordSetupRequiredClose => 'Close';

  @override
  String get setPasswordTitle => 'Set Your Password';

  @override
  String get setPasswordSubtitle => 'Set your password to continue';

  @override
  String get setPasswordTempLabel => 'Temporary Password';

  @override
  String get setPasswordTempHint => 'Enter Old Password';

  @override
  String get setPasswordNewLabel => 'New Password';

  @override
  String get setPasswordNewHint => 'Enter Your New Password';

  @override
  String get setPasswordConfirmLabel => 'Confirm Password';

  @override
  String get setPasswordConfirmHint => 'Enter Your Confirm Password';

  @override
  String get setPasswordValidationTempRequired =>
      'Temporary password is required';

  @override
  String get setPasswordValidationNewRequired => 'New password is required';

  @override
  String get setPasswordValidationNewTooShort =>
      'Password must be at least 8 characters';

  @override
  String get setPasswordValidationNewSameAsTemp =>
      'New password must differ from the temporary password';

  @override
  String get setPasswordValidationConfirmRequired =>
      'Please confirm your new password';

  @override
  String get setPasswordValidationConfirmMismatch => 'Passwords do not match';

  @override
  String get setPasswordSubmit => 'Submit';

  @override
  String get changePasswordTitle => 'Change Password';

  @override
  String get changePasswordSubtitle => 'Update the password for your account';

  @override
  String get changePasswordCurrentLabel => 'Current Password';

  @override
  String get changePasswordCurrentHint => 'Enter Current Password';

  @override
  String get changePasswordValidationCurrentRequired =>
      'Current password is required';

  @override
  String get changePasswordValidationNewSameAsCurrent =>
      'New password must differ from the current password';

  @override
  String get passwordSuccessTitle => 'Success';

  @override
  String get passwordSuccessBody =>
      'Your Password has been Successfully Updated.';

  @override
  String get passwordSuccessLogin => 'Login Now';

  @override
  String get splashTagline => 'CITIZEN ONE';

  @override
  String get profileTabPersonal => 'Personal';

  @override
  String get profileTabSecurity => 'Security';

  @override
  String get profileTabServices => 'Services';

  @override
  String get profileTabPayments => 'Payments';

  @override
  String get agentTabProfile => 'Profile';

  @override
  String get agentTabWork => 'Work';

  @override
  String get agentTabTransactions => 'Transactions';

  @override
  String get agentTabPerformance => 'Performance';

  @override
  String get profileActionLogout => 'Log Out';

  @override
  String profileLabelGoldBenefits(int count) {
    return '$count Active Gold Benefits';
  }

  @override
  String get profileActionDeactivate => 'Deactivate / Close Account';

  @override
  String get profileSectionMore => 'MORE';

  @override
  String get profileGroupSettings => 'Settings';

  @override
  String get profileMenuProfileDetails => 'Profile Details';

  @override
  String get profileMenuContactDetails => 'Contact Details';

  @override
  String get profileMenuAddressInfo => 'Address Information';

  @override
  String get profileMenuKycVerification => 'KYC / Verification';

  @override
  String get profileMenuChangePin => 'Change PIN / Password';

  @override
  String get profileMenuBiometric => 'Biometric Authentication';

  @override
  String get profileMenuLoginActivity => 'Login Activity';

  @override
  String get profileMenuConsent => 'Consent & Data Permissions';

  @override
  String get profileMenuMyLoans => 'My Loans';

  @override
  String get profileMenuLoanRepayment => 'Loan Repayment Schedule';

  @override
  String get profileMenuInsurancePolicies => 'My Insurance Policies';

  @override
  String get profileMenuInsuranceCoverage => 'Insurance Coverage';

  @override
  String get profileMenuSubsidies => 'Subsidies & Govt Benefits';

  @override
  String get profileMenuServiceRequests => 'Service Requests';

  @override
  String get profileMenuBankAccounts => 'Linked Bank Accounts';

  @override
  String get profileMenuWallets => 'Linked Wallets / Cards';

  @override
  String get profileMenuDefaultPayment => 'Default Payment Method';

  @override
  String get profileMenuTransactionHistory => 'Transaction History';

  @override
  String get profileMenuStatements => 'Statements / Receipts';

  @override
  String get profileAgentMenuIdRole => 'Agent ID & Role';

  @override
  String get profileAgentMenuRegion => 'Assigned Region / Branch';

  @override
  String get profileAgentMenuValidity => 'Validity / Renewal Dates';

  @override
  String get profileAgentMenuAgreement => 'Agent Agreement';

  @override
  String get profileAgentMenuIdProof => 'ID Proof / License';

  @override
  String get profileAgentMenuCertificates => 'Training Certificates';

  @override
  String get profileAgentMenuCustomers => 'Assigned Customers';

  @override
  String get profileAgentMenuTasks => 'Pending Tasks';

  @override
  String get profileAgentMenuTargets => 'Daily / Weekly Targets';

  @override
  String get profileAgentMenuTransactions => 'Transactions Performed';

  @override
  String get profileAgentMenuCollections => 'Collections / Disbursements';

  @override
  String get profileAgentMenuHistory => 'Assisted Services History';

  @override
  String get profileAgentMenuBanking => 'Banking Services';

  @override
  String get profileAgentMenuLoanOrigination => 'Loan Origination';

  @override
  String get profileAgentMenuInsurance => 'Insurance Enrollment';

  @override
  String get profileAgentMenuGovSchemes => 'Government Schemes';

  @override
  String get profileAgentMenuKpis => 'KPIs / SLAs';

  @override
  String get profileAgentMenuSuccessRate => 'Success Rate';

  @override
  String get profileAgentMenuTurnaround => 'Turnaround Time';

  @override
  String get profileAgentMenuCommission => 'Commission Summary';

  @override
  String get profileAgentMenuPendingPaid => 'Pending vs Paid';

  @override
  String get profileAgentMenuSettlement => 'Settlement History';

  @override
  String get profileMenuOfflineMode => 'Offline Mode';

  @override
  String get profileMenuSyncStatus => 'Sync Status';

  @override
  String get profileMenuTrainingManuals => 'Training & Manuals';

  @override
  String get profileMenuDeviceBinding => 'Device Binding';

  @override
  String get profileMenuSessionHistory => 'Session History';

  @override
  String get profileMenuActivityLogs => 'Activity Logs';

  @override
  String get profileMenuGeoTagged => 'Geo-tagged Transactions';

  @override
  String get profileMenuConsentRecords => 'Consent Records';

  @override
  String get profileStatKyc => 'KYC';

  @override
  String get profileStatCards => 'Cards';

  @override
  String get profileStatLoans => 'Loans';

  @override
  String get profileStatCustomers => 'Customers';

  @override
  String get profileStatTarget => 'Target';

  @override
  String get profileStatEarnings => 'Earnings';

  @override
  String get profileLabelVerified => 'Verified';

  @override
  String get profileLabelGold => 'Gold';

  @override
  String get profileLabelGoldMember => 'Gold Member';

  @override
  String get profileLabelRegionActive => 'Lusaka Region';

  @override
  String profileLabelAccountId(String id) {
    return 'Account ID: $id';
  }

  @override
  String profileLabelLastLogin(String time) {
    return '$time';
  }

  @override
  String profileLabelLinked(Object count) {
    return '$count Linked';
  }

  @override
  String profileLabelActiveCount(Object count) {
    return '$count Active';
  }

  @override
  String get profileLabelFieldAgent => 'Field Agent';

  @override
  String get notificationsTitle => 'Alerts & Notifications';

  @override
  String get notificationBillTitle => 'Electricity Bill Due';

  @override
  String get notificationBillDesc =>
      'Your bill of ZK 450.00 is due tomorrow. Pay now to avoid late fees.';

  @override
  String get notificationLoginTitle => 'New Login Detected';

  @override
  String get notificationLoginDesc =>
      'Login from new device (iPhone 13) in Lusaka.';

  @override
  String get notificationInsightTitle => 'Smart Insight';

  @override
  String get notificationInsightDesc =>
      'You spent 15% less on groceries this week compared to last month. Great job!';

  @override
  String get notificationPaymentTitle => 'Payment Received';

  @override
  String get notificationPaymentDesc =>
      'Received ZK 5,000.00 from John Doe via Wallet.';

  @override
  String notificationTimeHours(Object count) {
    return '$count hours ago';
  }

  @override
  String get notificationTimeYesterday => 'Yesterday';

  @override
  String get aiAssistantTitle => 'Citizen AI';

  @override
  String get aiAssistantTagline => 'Always here to help';

  @override
  String get aiAssistantInputHint => 'Ask anything...';

  @override
  String aiMessageGreeting(String name) {
    return 'Hello $name! I noticed you are eligible for a personal loan up to ₹15L with lower interest rates. Would you like to explore?';
  }

  @override
  String get aiMessageUserReply =>
      'Yes, tell me more about the interest rates.';

  @override
  String get aiMessageLoanDetails =>
      'Sure! HDFC is offering 10.5% p.a. specially for you. \n\nIf you take ₹5L for 5 years, your EMI will be ₹10,747. You save ₹1,200 compared to standard rates!';

  @override
  String get aiActionApplyNow => 'Apply Now';

  @override
  String get aiActionCompare => 'Compare';

  @override
  String get loansDashboardTitle => 'Loans Dashboard';

  @override
  String get loansDashboardSubtitle => 'Find the right financing for you';

  @override
  String get loanCategoryPersonal => 'Personal Loan';

  @override
  String get loanCategoryHome => 'Home Loan';

  @override
  String get loanCategoryVehicle => 'Vehicle Loan';

  @override
  String get loanCategoryAgri => 'Agri Loan';

  @override
  String get loanCategoryEducation => 'Education';

  @override
  String get loanCategoryMsme => 'MSME Business';

  @override
  String get loanCategoryConstruction => 'Construction';

  @override
  String get loanCategoryAsset => 'Asset Based';

  @override
  String get loansPromoTitle => 'Need funds quickly?';

  @override
  String get loansPromoSubtitle =>
      'Get pre-approved personal loans up to ZK 50,000 instantly.';

  @override
  String get loansPromoAction => 'Check Loan Eligibility';

  @override
  String get loansCategoriesHeader => 'Loan Categories';

  @override
  String get loansCategoriesViewAll => 'View All';

  @override
  String get loansLabelAmount => 'Loan Amount';

  @override
  String get loansLabelInterestRate => 'Interest Rate (%)';

  @override
  String get loansLabelTenure => 'Tenure (Months)';

  @override
  String get loansLabelMonthlyEmi => 'Monthly EMI';

  @override
  String get loansLabelTotalInterest => 'Total Interest';

  @override
  String get loansLabelTotalPayable => 'Total Payable';

  @override
  String get loansLabelPrincipalAmount => 'Principal Amount';

  @override
  String get loansEmiDisclaimer =>
      '* Note: The calculated EMI is indicative and may vary based on bank policies and processing fees.';

  @override
  String get loansActionApply => 'Apply';

  @override
  String get loansActionCancel => 'Cancel';

  @override
  String get loansStatusTitle => 'Application Status';

  @override
  String get loansLabelAmountHeader => 'Amount';

  @override
  String get loansLabelDateHeader => 'Date';

  @override
  String get loansLabelTrackingHistory => 'Tracking History';

  @override
  String get loansStatusSubmitted => 'Submitted';

  @override
  String get loansStatusCreditScoring => 'Credit Scoring';

  @override
  String get loansStatusEligibility => 'Eligibility Check';

  @override
  String get loansStatusApproval => 'Final Approval';

  @override
  String get loansLabelActionRequired => 'Action Required';

  @override
  String get loansActionUploadDocs => 'Upload Documents';

  @override
  String get loansEmiCalcTitle => 'EMI Calculator';

  @override
  String get loansEmiCalcSubtitle =>
      'Plan your finances with our easy calculator';

  @override
  String get loansWhyChooseHeader => 'Why choose us?';

  @override
  String get loansBenefit1Title => 'Multiple Banks';

  @override
  String get loansBenefit1Subtitle => 'Compare rates from over 10+ partners.';

  @override
  String get loansBenefit2Title => 'Paperless Process';

  @override
  String get loansBenefit2Subtitle =>
      '100% digital application and documentation.';

  @override
  String get loansMyAppsHeader => 'My Applications';

  @override
  String loansAppRef(Object ref) {
    return 'Ref: $ref';
  }

  @override
  String loansAppLastUpdate(Object date) {
    return 'Last update: $date';
  }

  @override
  String get commonServicesTitle => 'Common Services';

  @override
  String get commonServicesSystemOverview => 'System Overview';

  @override
  String get commonServicesUptime => 'UPTIME';

  @override
  String get commonServicesLatency => 'LATENCY';

  @override
  String get commonServicesQuickAnalytics => 'Analytics';

  @override
  String get commonServicesQuickTickets => 'Tickets';

  @override
  String get commonServicesQuickAdmin => 'Admin';

  @override
  String get commonServicesQuickSupport => 'Support';

  @override
  String get commonServicesLogs => 'Service Logs';

  @override
  String get commonServicesUserMgmt => 'User Management';

  @override
  String get commonServicesSecurity => 'Security Controls';

  @override
  String get commonServicesAiAlert => 'CITIZEN AI ALERT';

  @override
  String get commonServicesAiPerf => 'Performance';

  @override
  String get commonServicesAiStatus =>
      'System load is normal. No incidents reported.';

  @override
  String get commonServicesAiDetails => 'View Details';

  @override
  String get profileGroupSupport => 'Support';

  @override
  String get profileGroupAbout => 'About';

  @override
  String get profileGroupSecurity => 'Security';

  @override
  String get profileGroupHelpAbout => 'Help & About';

  @override
  String get profileMenuLanguage => 'Language Selection';

  @override
  String get profileMenuNotifications => 'Notification Preferences';

  @override
  String get profileMenuLocation => 'Location & Regional Settings';

  @override
  String get profileMenuTheme => 'Theme (Light / Dark)';

  @override
  String get profileMenuSupportTicket => 'Raise Support Ticket';

  @override
  String get profileMenuFAQs => 'FAQs';

  @override
  String get profileMenuChatSupport => 'Chat / Call Support';

  @override
  String get profileMenuReportIssue => 'Report an Issue';

  @override
  String get profileMenuFeedback => 'Feedback & Ratings';

  @override
  String get profileMenuAbout => 'About CitizenOne';

  @override
  String get profileMenuWhatsNew => 'What\'s New';

  @override
  String get profileMenuAppVersion => 'App Version';

  @override
  String get profileMenuPrivacyPolicy => 'Privacy Policy';

  @override
  String get profileMenuTerms => 'Terms & Conditions';

  @override
  String get quickActionPay => 'Pay';

  @override
  String get quickActionScanQr => 'Scan QR';

  @override
  String get quickActionApplyLoan => 'Apply Loan';

  @override
  String get quickActionSupport => 'Support';

  @override
  String get quickActionAgriLoan => 'Agri Loan';

  @override
  String get quickActionWeather => 'Weather';

  @override
  String get quickActionMarket => 'Market';

  @override
  String get quickActionOnboard => 'Onboard';

  @override
  String get quickActionCollect => 'Collect';

  @override
  String get quickActionTodayTasks => 'Today Tasks';

  @override
  String get dashboardSectionQuickActions => 'Quick Actions';

  @override
  String get dashboardSectionAllServices => 'All Services';

  @override
  String get dashboardActionViewAll => 'View All';

  @override
  String get dashboardSectionRecentActivity => 'Recent Activity';

  @override
  String get heroCardCitizenLabel => 'Citizen AI Alert';

  @override
  String get heroCardAgentLabel => 'Agent Performance';

  @override
  String get heroCardFarmerLabel => 'WEATHER ALERT';

  @override
  String get heroCardCitizenTitle => 'Electricity Bill Due';

  @override
  String get heroCardCitizenDueTag => 'Due Tomorrow';

  @override
  String get heroCardCitizenDueNote => 'Due in 5 days';

  @override
  String get heroCardAgentCommissionLabel => 'Commission Earned';

  @override
  String get heroCardFarmerRainfallLabel => 'Rainfall Alert';

  @override
  String get heroCardFarmerRainfallValue => 'Heavy Rain';

  @override
  String get heroCardFarmerRainfallNote => 'Expected in 2 days';

  @override
  String get heroCardFarmerRainExpectedNote => 'Heavy Rain Expected';

  @override
  String get heroBtnViewTasks => 'View Tasks';

  @override
  String get heroBtnViewForecast => 'View Forecast';

  @override
  String get heroBtnPayNow => 'Pay Now';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork => 'No internet connection.';

  @override
  String get errorSession => 'Your session has expired. Please log in again.';

  @override
  String get loadingLabel => 'Loading…';

  @override
  String get retryLabel => 'Retry';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get saveLabel => 'Save';

  @override
  String get confirmLabel => 'Confirm';

  @override
  String get serviceBankingTitle => 'Banking Services';

  @override
  String get serviceBankingBalanceLabel => 'Total Balance';

  @override
  String serviceBankingBalanceChange(Object percentage) {
    return '$percentage this month';
  }

  @override
  String serviceBankingAccountSavings(Object lastFour) {
    return 'Savings: **** $lastFour';
  }

  @override
  String get serviceBankingActionTransfer => 'Transfer';

  @override
  String get serviceBankingActionLoan => 'Loan';

  @override
  String get serviceBankingActionStatements => 'Statements';

  @override
  String get serviceBankingAccSavings => 'Savings\nAccount';

  @override
  String get serviceBankingAccCurrent => 'Current\nAccount';

  @override
  String get serviceBankingAccBusiness => 'Business\nAccount';

  @override
  String get serviceBankingAccFixed => 'Fixed /\nTerm Deposit';

  @override
  String get serviceBankingLoanPersonal => 'Personal\nLoan';

  @override
  String get serviceBankingLoanBusiness => 'Business /\nSME Loan';

  @override
  String get serviceBankingLoanHome => 'Home\nLoan';

  @override
  String get serviceBankingLoanVehicle => 'Vehicle\nLoan';

  @override
  String get serviceBankingLoanAgri => 'Agricultural\nLoan';

  @override
  String get serviceBankingCardClassic => 'Classic /\nStandard';

  @override
  String get serviceBankingCardCashback => 'Cashback\nCard';

  @override
  String get serviceBankingCardRewards => 'Rewards\nCard';

  @override
  String get serviceBankingCardTravel => 'Travel\nCard';

  @override
  String get serviceBankingCardPremium => 'Premium /\nSignature';

  @override
  String get serviceBankingCardSecured => 'Secured\nCard';

  @override
  String get serviceBankingCardBusiness => 'Business /\nCorporate';

  @override
  String get serviceBankingCardCobranded => 'Co-branded\nCard';

  @override
  String get serviceBankingTransactions => 'Recent Transactions';

  @override
  String get serviceBankingSectionAccounts => 'Accounts';

  @override
  String get serviceBankingSectionLoans => 'Loans';

  @override
  String get serviceBankingSectionCards => 'Cards';

  @override
  String get serviceGovtTitle => 'Government Services';

  @override
  String get serviceGovtSubtitle =>
      'One-stop access to all government portals.';

  @override
  String get serviceGovtHeroTitle => 'Citizen Services';

  @override
  String get serviceGovtBlogTitle1 => 'Digital Land Records Update';

  @override
  String get serviceGovtBlogSnippet1 =>
      'Process for getting land records digitally is now faster.';

  @override
  String get serviceGovtBlogTitle2 => 'New Skill Mission Launched';

  @override
  String get serviceGovtBlogSnippet2 =>
      'Join the new vocational training programs for youth.';

  @override
  String get serviceWealthTitle => 'Wealth Management';

  @override
  String get serviceWealthPortfolioLabel => 'Total Portfolio Value';

  @override
  String get serviceWealthGoalAnalysis => 'Goal Analysis';

  @override
  String get serviceWealthAiGoalDesc =>
      'You are on track to reach your \"New Car\" goal by Dec 2026.';

  @override
  String get serviceWealthActionInvest => 'Invest';

  @override
  String get serviceWealthActionFunds => 'Funds';

  @override
  String get serviceWealthActionSIPs => 'SIPs';

  @override
  String get serviceWealthActionAdvisory => 'Advisory';

  @override
  String get serviceWealthMutualFunds => 'Mutual Fund Operations';

  @override
  String get serviceWealthFixedDeposits => 'Fixed Deposits';

  @override
  String get serviceWealthPensionPlans => 'Pension Plans (NPS)';

  @override
  String get serviceInsuranceTitle => 'Insurance';

  @override
  String serviceInsuranceActivePolicies(int count) {
    return '$count Active Policies';
  }

  @override
  String get serviceInsuranceActionBuyNew => 'Buy New';

  @override
  String get serviceInsuranceActionRenew => 'Renew';

  @override
  String get serviceInsuranceActionClaim => 'Claim';

  @override
  String get serviceInsuranceActionMyPolicies => 'My Policies';

  @override
  String get serviceInsuranceRenewalAlert => 'Renewal Alert';

  @override
  String get serviceInsuranceAiRenewalDesc =>
      'Car Insurance expires in 5 days. Renew now to avoid inspection.';

  @override
  String get serviceInsuranceNetworkHospitals => 'Network Hospitals';

  @override
  String get serviceInsuranceDownloadPolicy => 'Download Policy Copy';

  @override
  String get serviceInsuranceClaimStatus => 'Claim Status';

  @override
  String get serviceBillPayTitle => 'Bill Payments';

  @override
  String get serviceBillPayTotalDue => 'Total Due';

  @override
  String serviceBillPayDueNote(int days) {
    return 'Due within $days days';
  }

  @override
  String get serviceBillPayActionPayAll => 'Pay All Bills';

  @override
  String get serviceBillPayActionPayBill => 'Pay Bills';

  @override
  String get serviceBillPayPrediction => 'Bill Prediction';

  @override
  String get serviceBillPayAiUsageDesc =>
      'Your electricity bill is expected to be 10% lower next month.';

  @override
  String get serviceBillPayActionElectricity => 'Electricity';

  @override
  String get serviceBillPayActionWater => 'Water';

  @override
  String get serviceBillPayActionMobile => 'Mobile';

  @override
  String get serviceBillPayActionAddNew => 'Add New';

  @override
  String get serviceBillPayHistory => 'Payment History';

  @override
  String get serviceBillPayManage => 'Manage Billers';

  @override
  String get serviceBillPayAutoPay => 'Auto-Pay Settings';

  @override
  String get serviceActionViewUsage => 'View Usage';

  @override
  String get serviceHealthTitle => 'HealthEzy';

  @override
  String get serviceHealthPassport => 'Your Health Passport';

  @override
  String get serviceHealthCheckupDue => 'Checkup Due';

  @override
  String get serviceHealthAiCheckupDesc =>
      'Annual dental checkup is due next week.';

  @override
  String get serviceHealthActionVitals => 'Vitals';

  @override
  String get serviceHealthActionMedicines => 'Medicines';

  @override
  String get serviceHealthActionLabs => 'Lab Tests';

  @override
  String get serviceHealthActionRecords => 'Records';

  @override
  String get serviceHealthSymptomChecker => 'Symptom Checker';

  @override
  String get serviceHealthVaccination => 'Vaccination History';

  @override
  String get serviceHealthHospitals => 'Find Hospitals Nearby';

  @override
  String get serviceActionBookAppointment => 'Book Appointment';

  @override
  String get serviceMobileTitle => 'Mobile & Airtime';

  @override
  String get serviceMobileMyNumber => 'My Number';

  @override
  String serviceMobileExpiryNote(int days) {
    return 'Prepaid • Expires in $days days';
  }

  @override
  String serviceMobileDataLeft(String amount) {
    return 'Data: $amount GB left';
  }

  @override
  String get serviceMobilePlanExpiring => 'Plan Expiring';

  @override
  String get serviceMobileAiPlanExpiringDesc =>
      'Your 5G Data Pack expires tomorrow. Recharge now.';

  @override
  String get serviceMobileActionRecharge => 'Recharge';

  @override
  String get serviceMobileActionDataPack => 'Data Pack';

  @override
  String get serviceMobileActionPayBill => 'Pay Bill';

  @override
  String get serviceMobileActionHistory => 'History';

  @override
  String get serviceMobilePopularPlans => 'Popular Plans';

  @override
  String get serviceMobileFamilyAccounts => 'Family Accounts';

  @override
  String get serviceMobileRoaming => 'Roaming Services';

  @override
  String get serviceGovtSectionHealth => 'Health';

  @override
  String get serviceGovtSectionEducation => 'Education';

  @override
  String get serviceGovtSectionLand => 'Land & Property';

  @override
  String get serviceGovtSectionCivic => 'Civic & Welfare';

  @override
  String get serviceGovtActionTaxes => 'Taxes';

  @override
  String get serviceGovtActionCertificates => 'Certificates';

  @override
  String get serviceGovtActionLandRecords => 'Land Records';

  @override
  String get serviceGovtActionMyDocs => 'My Docs';

  @override
  String get serviceGovtHealthInsurance => 'Health Insurance';

  @override
  String get serviceGovtBirthCertificate => 'Birth Certificate';

  @override
  String get serviceGovtDeathCertificate => 'Death Certificate';

  @override
  String get serviceGovtFitness => 'Physical Fitness';

  @override
  String get serviceGovtScholarships => 'Scholarships';

  @override
  String get serviceGovtAdmissions => 'School Admissions';

  @override
  String get serviceGovtSkillCertificates => 'Skill Certificates';

  @override
  String get serviceGovtDigitalLibrary => 'Digital Library';

  @override
  String get serviceGovtPropertyTax => 'Property Tax';

  @override
  String get serviceGovtEncumbrance => 'Encumbrance';

  @override
  String get serviceGovtSurveyMutation => 'Survey & Mutation';

  @override
  String get serviceGovtAadhaar => 'Aadhaar Services';

  @override
  String get serviceGovtVoterId => 'Voter ID';

  @override
  String get serviceGovtPension => 'Pension Services';

  @override
  String get serviceGovtRti => 'RTI Applications';

  @override
  String get serviceGovtRelatedUpdates => 'RELATED UPDATES';

  @override
  String get serviceActionViewDetails => 'View Details';

  @override
  String get serviceMarketplaceTitle => 'Marketplace';

  @override
  String get serviceMarketplaceSalesToday => 'Sales Today';

  @override
  String serviceMarketplaceOrdersPending(Object count) {
    return '$count Orders Pending';
  }

  @override
  String get serviceMarketplaceActionListItem => 'List Item';

  @override
  String get serviceMarketplaceActionOrders => 'Orders';

  @override
  String get serviceMarketplaceActionLogistics => 'Logistics';

  @override
  String get serviceMarketplaceActionMyStore => 'My Store';

  @override
  String get serviceMarketplaceSectionServices => 'Services';

  @override
  String get serviceMarketplaceCatalog => 'Product Catalog';

  @override
  String get serviceMarketplaceReviews => 'Customer Reviews';

  @override
  String get serviceMarketplaceSupport => 'Seller Support';

  @override
  String get serviceMarketplaceAiDemandForecast => 'Demand Forecast';

  @override
  String get serviceMarketplaceAiDemandForecastDesc =>
      'Stock up on \"Organic Rice\". High demand expected this weekend.';

  @override
  String get serviceLogisticsTitle => 'Logistics';

  @override
  String get serviceLogisticsActiveShipments => 'Active Shipments';

  @override
  String serviceLogisticsDeliveryAlert(Object time) {
    return 'Next delivery expected by $time today';
  }

  @override
  String get serviceLogisticsActionTrackAll => 'Track All Shipments';

  @override
  String get serviceLogisticsActionBookNow => 'Book Now';

  @override
  String get serviceLogisticsActionTrack => 'Track';

  @override
  String get serviceLogisticsActionCalcFare => 'Calc Fare';

  @override
  String get serviceLogisticsActionMyOrders => 'My Orders';

  @override
  String get serviceLogisticsSectionServices => 'Services';

  @override
  String get serviceLogisticsWarehousing => 'Warehousing Services';

  @override
  String get serviceLogisticsFleet => 'Fleet Management';

  @override
  String get serviceLogisticsPastShipments => 'Past Shipments';

  @override
  String get serviceLogisticsAiRouteOptimization => 'Route Optimization';

  @override
  String serviceLogisticsAiRouteOptimizationDesc(
    Object highway,
    Object tripId,
  ) {
    return 'Save 20 mins on the Trip #$tripId via $highway.';
  }

  @override
  String get serviceSportTitle => 'Sporting & Mental Health';

  @override
  String get serviceSportActiveStreak => 'Active Streak';

  @override
  String get serviceSportDays => 'Days';

  @override
  String get serviceSportStreakMotivation =>
      'Keep it up! Physical health boosts mental wealth.';

  @override
  String get serviceSportActionWorkouts => 'Workouts';

  @override
  String get serviceSportActionEvents => 'Events';

  @override
  String get serviceSportActionCommunity => 'Community';

  @override
  String get serviceSportActionBook => 'Book';

  @override
  String get serviceSportSectionServices => 'Services';

  @override
  String get serviceSportFacilities => 'Local Sports Facilities';

  @override
  String get serviceSportWellnessGuides => 'Mental Wellness Guides';

  @override
  String get serviceSportMeditation => 'Meditation Zone';

  @override
  String get serviceSportAiWellnessTip => 'Wellness Tip';

  @override
  String get serviceSportAiWellnessTipDesc =>
      'Try a 10-minute walk after lunch to improve digestion and focus.';

  @override
  String get labelAiAssistants => 'AI Assistants';

  @override
  String get labelActionView => 'View';

  @override
  String get serviceCommonTitle => 'Common Svcs';

  @override
  String get serviceAgriTitle => 'Agri Services';

  @override
  String get serviceSmeTitle => 'SME Services';

  @override
  String get loansMarketplaceSubtitle => 'Marketplace';

  @override
  String get loansFilterAll => 'All Offers';

  @override
  String get loansFilterLowestRate => 'Lowest Rate';

  @override
  String get loansFilterFastest => 'Fastest Approval';

  @override
  String get loansPreApproved => 'Pre-Approved';

  @override
  String get loansLabelFee => 'Fee';

  @override
  String get loansInterestRateLabel => 'Interest Rate';

  @override
  String get loansActionCompare => 'Compare';

  @override
  String get loansActionSelected => 'Selected';

  @override
  String loansCompareBanksSelected(int count) {
    return '$count banks selected';
  }

  @override
  String get loansCompareOffersTitle => 'Compare Offers';

  @override
  String get loansActionViewComparison => 'View Comparison';

  @override
  String get loansComparePlansTitle => 'Compare Plans';

  @override
  String get loansCompareInterestRate => 'INTEREST RATE (ROI)';

  @override
  String get loansCompareProcessingFee => 'PROCESSING FEE';

  @override
  String get loansCompareMaxAmount => 'MAX AMOUNT';

  @override
  String get loansCompareFeatures => 'FEATURES';

  @override
  String get loansBestRate => 'Best Rate';

  @override
  String get loansPerAnnum => 'per annum';

  @override
  String get loansCheckEligibilityTitle => 'Check Eligibility';

  @override
  String get loansEligibilityHeadline => 'Tell us about yourself';

  @override
  String get loansEligibilitySubheadline =>
      'We\'ll find the best loan offers for your profile.';

  @override
  String get loansLabelMonthlyIncome => 'Monthly Income';

  @override
  String get loansLabelEmploymentType => 'Employment Type';

  @override
  String get loansLabelCity => 'City';

  @override
  String get loansLabelPan => 'ID Number (Optional)';

  @override
  String get loansActionCheckOffers => 'Check Offers';

  @override
  String get loansAiAnalysisTitle => 'AI Analysis';

  @override
  String get loansAiBestMatch => 'Best Match Found';

  @override
  String get loansAiBestMatchSubtitle =>
      'Highest approval chance for your profile';

  @override
  String get loansActionProceedWithOffer => 'Proceed with this Offer';

  @override
  String get loansCompareWithOthers => 'Or compare with others';

  @override
  String get loansActionViewComparisonTable => 'View Comparison Table';

  @override
  String get loansCompareTitle => 'Compare Loans';

  @override
  String get loansApplicationTitle => 'Application';

  @override
  String get loansStepPersonal => 'Personal';

  @override
  String get loansStepKyc => 'Documents';

  @override
  String get loansStepReview => 'Review';

  @override
  String get loansSubmittedTitle => 'Application Submitted!';

  @override
  String get loansSubmittedDescription =>
      'Your application ID is #CO-88291. We will update you shortly.';

  @override
  String get loansActionBackToHome => 'Back to Home';

  @override
  String loansStepIndicator(int step, int total) {
    return 'STEP $step OF $total';
  }

  @override
  String loansExistingCustomerQuestion(String bankName) {
    return 'Are you an existing customer of $bankName?';
  }

  @override
  String get loansExistingCustomerYes => 'Yes, I have an account';

  @override
  String get loansExistingCustomerYesDesc =>
      'Faster approval. We\'ll pre-fill your details from KYC records.';

  @override
  String get loansExistingCustomerNo => 'No, I am a new customer';

  @override
  String get loansExistingCustomerNoDesc =>
      'We\'ll need a few more details to set up your profile.';

  @override
  String get loansLabelNrc => 'NRC / ID Number';

  @override
  String get loansLabelEmploymentStatus => 'Employment Status';

  @override
  String get loansEmploymentFullTime => 'Full Time Employed';

  @override
  String get loansEmploymentPartTime => 'Part Time Employed';

  @override
  String get loansEmploymentSelfEmployed => 'Self Employed / Business';

  @override
  String get loansEmploymentRetired => 'Retired';

  @override
  String get loansFormInfoNote =>
      'Please ensure all details match your official documents. This helps in faster processing.';

  @override
  String loansDocInfoNote(String bankName) {
    return 'Since you selected $bankName, we can fetch your bank statement automatically if you provide consent.';
  }

  @override
  String get loansUploadPayslip => 'Upload Payslip / Proof of Income';

  @override
  String get loansUploadPayslipSubtitle => 'Latest 3 months • PDF or JPG';

  @override
  String get loansUploadNrc => 'Upload NRC Copy';

  @override
  String get loansUploadNrcSubtitle => 'Front and Back • PDF or JPG';

  @override
  String get loansApplicantDetails => 'Applicant Details';

  @override
  String get loansActionEdit => 'Edit';

  @override
  String get loansLabelNrcNumber => 'NRC Number';

  @override
  String get loansLabelEmployment => 'Employment';

  @override
  String get loansLabelDocuments => 'Documents';

  @override
  String loansDocsUploaded(int count) {
    return '$count Uploaded';
  }

  @override
  String loansTermsConfirmation(String bankName) {
    return 'I confirm the details provided are accurate and authorize $bankName to access my credit report for processing this application. I agree to the';
  }

  @override
  String get loansTermsOfService => 'Terms of Service';

  @override
  String get loansSuccessTitle => 'Application Submitted!';

  @override
  String loansSuccessDescription(String loanType, String bankName) {
    return 'Your application for $loanType with $bankName has been submitted successfully.';
  }

  @override
  String get loansReferenceIdLabel => 'REFERENCE ID';

  @override
  String get loansActionBackToLoansHub => 'Back to Loans Hub';

  @override
  String get loansActionTrackStatus => 'Track Status';

  @override
  String get loansActionBackToDashboard => 'Back to Dashboard';

  @override
  String get loansActionSubmitApplication => 'Submit Application';

  @override
  String get loansActionContinue => 'Continue';

  @override
  String get loansLabelTenureYears => 'Tenure (Years)';

  @override
  String get genericServiceGetStarted => 'Get Started';
}
