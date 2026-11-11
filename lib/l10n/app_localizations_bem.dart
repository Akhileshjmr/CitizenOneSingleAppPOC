// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bemba (`bem`).
class AppLocalizationsBem extends AppLocalizations {
  AppLocalizationsBem([String locale = 'bem']) : super(locale);

  @override
  String get appTitle => 'Citizen One';

  @override
  String get appVersion => 'v1.0.0';

  @override
  String get navHome => 'Imyaka';

  @override
  String get navServices => 'Inshita';

  @override
  String get navAlerts => 'Amashiwi';

  @override
  String get navProfile => 'Ifyakwe';

  @override
  String get navPay => 'Lipila';

  @override
  String get headerDashboard => 'Icisela';

  @override
  String get headerGreeting => 'Mwapoleni';

  @override
  String get headerLocation => 'Lusaka';

  @override
  String get agentWorkContext => 'INSHITA YA CITO';

  @override
  String get settingsLabel => 'Ifyo Baika';

  @override
  String get loginWelcomeTitle => 'Mukwai ku CitizenOne';

  @override
  String get loginSubtitle => 'Ingila pa account yobe';

  @override
  String get loginSelectPersona => 'Sala Ifyo Uli';

  @override
  String get loginChooseRole => 'Sala ubwina bwobe';

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
  String get loginValidationSelectPersona => 'Sala ubwina';

  @override
  String get loginUsernameLabel => 'Izina Lya Kulombela';

  @override
  String get loginUsernameHint => 'Funda izina lyobe';

  @override
  String get loginValidationUsernameRequired => 'Izina lyakwetwa';

  @override
  String get loginPasswordLabel => 'Icifungo ca Mucinshi';

  @override
  String get loginPasswordHint => 'Funda icifungo icamucinshi';

  @override
  String get loginValidationPasswordRequired =>
      'Icifungo ca mucinshi cyakwetwa';

  @override
  String loginButtonAs(String roleName) {
    return 'Ingila nga $roleName';
  }

  @override
  String get loginButton => 'Ingila';

  @override
  String get loginMobileLabel => 'Inambala ya Foni';

  @override
  String get loginMobileHint => 'Funda inambala ya foni yobe';

  @override
  String get loginValidationMobileRequired => 'Inambala ya foni yasenda';

  @override
  String get loginForgotPassword => 'Mwalubalubo Icifungo?';

  @override
  String get loginForgotPasswordPending =>
      'Ifyalongolwa pa kwalubalubwa kwa cifulo ca mucinshi.';

  @override
  String get forgotPasswordBrand => 'CitizenOne / ZAMPOST';

  @override
  String get forgotPasswordTitle => 'Mwalubalubo Icifungo?';

  @override
  String get forgotPasswordBody =>
      'Funda inambala yobe ya foni apa panshi — tuli yalolela ubwibe bwobe no kukuyobeka pakusetapo icifulo ca mucinshi.';

  @override
  String get forgotPasswordMobileLabel => 'Inambala ya Foni';

  @override
  String get forgotPasswordMobileHint => 'Funda inambala yobe ya foni';

  @override
  String get forgotPasswordMobileRequired =>
      'Tafwaya kufunda inambala ya foni iyakulolwa';

  @override
  String get forgotPasswordInfoBanner =>
      'Pa buminshi bwobe, tuli katuma iyiyo ya OTP pakulolela ubwibe bwobe ishitilila kuti twasetapo icifulo ca mucinshi.';

  @override
  String get forgotPasswordContinue => 'Endelela';

  @override
  String get forgotPasswordRememberPrefix => 'Mukuwishi icifulo ca mucinshi?';

  @override
  String get forgotPasswordSignIn => 'Ingila';

  @override
  String get forgotPasswordOtpTitle => 'Ukulolela kwa OTP';

  @override
  String get forgotPasswordOtpCardTitle => 'Ukulolela kwa Kamo';

  @override
  String get forgotPasswordOtpBody =>
      'Pakulolela ubwibe bwobe, funda iyiyo ya OTP iya tumwa ku foni yobe ya kwingilamo.';

  @override
  String get forgotPasswordOtpRequired => 'OTP yasenda';

  @override
  String get forgotPasswordOtpInvalid =>
      'Tafwaya kufunda OTP yafwa ya nambala 6';

  @override
  String get forgotPasswordOtpSec => 'Sekondi';

  @override
  String forgotPasswordOtpAttemptsLeft(int count) {
    return 'Imisango $count yasala';
  }

  @override
  String get forgotPasswordOtpResend => 'Tuma OTP Nobe';

  @override
  String get forgotPasswordOtpResent => 'OTP impya yatumwa ku foni yobe.';

  @override
  String get forgotPasswordOtpVerify => 'Lolela OTP';

  @override
  String get createPasswordTitle => 'Pangizula Icifulo Cobe ca Mucinshi';

  @override
  String get createPasswordSubtitle =>
      'Pangizula icifulo ca mucinshi icakosa pa akaunti yobe';

  @override
  String get createPasswordNewLabel => 'Icifulo Cipya ca Mucinshi';

  @override
  String get createPasswordNewHint => 'Funda Icifulo Cipya ca Mucinshi';

  @override
  String get createPasswordConfirmLabel => 'Suminisha Icifulo ca Mucinshi';

  @override
  String get createPasswordConfirmHint => 'Funda Icifulo Cobe ca Kusuminisha';

  @override
  String get createPasswordRulesTitle => 'Icifulo ca mucinshi cikwete:';

  @override
  String get createPasswordMismatch => 'Ififulo ca mucinshi tafya filingana';

  @override
  String get createPasswordSubmit => 'Tuma';

  @override
  String get passwordRuleLength => 'Ifyalembo 8 - 30';

  @override
  String get passwordRuleUpper => 'Ilembo lya paulu (A-Z)';

  @override
  String get passwordRuleLower => 'Ilembo lya pa kunsi (a-z)';

  @override
  String get passwordRuleDigit => 'Inambala (0-9)';

  @override
  String get passwordRuleSpecial => 'Ilembo lya kona';

  @override
  String get passwordRuleNoSuccessiveOver3 =>
      'Tapafwa ifyalembo fimo ifyalipita 3';

  @override
  String get passwordRuleNoCharMoreThan3 =>
      'Tapakwete ilembo limo ilipita inshita 3';

  @override
  String get passwordSetupRequiredTitle => 'Icifulo ca Mucinshi Cilaleta';

  @override
  String get passwordSetupRequiredBody =>
      'Akaunti yobe tayacakulwa pa kupangizula icifulo ca mucinshi. Tafwaya ku sinya icifulo ca mucinshi ili upitilile';

  @override
  String get passwordSetupRequiredContinue => 'Endelela';

  @override
  String get passwordSetupRequiredClose => 'Isala';

  @override
  String get setPasswordTitle => 'Pangizula Icifulo Cobe ca Mucinshi';

  @override
  String get setPasswordSubtitle =>
      'Pangizula icifulo ca mucinshi ili upitilile';

  @override
  String get setPasswordTempLabel => 'Icifulo ca Mucinshi ca Kwingilamo';

  @override
  String get setPasswordTempHint => 'Funda Icifulo ca Kwingilamo';

  @override
  String get setPasswordNewLabel => 'Icifulo Cipya ca Mucinshi';

  @override
  String get setPasswordNewHint => 'Funda Icifulo Cipya ca Mucinshi';

  @override
  String get setPasswordConfirmLabel => 'Suminisha Icifulo ca Mucinshi';

  @override
  String get setPasswordConfirmHint => 'Funda Icifulo Cobe ca Kusuminisha';

  @override
  String get setPasswordValidationTempRequired =>
      'Icifulo ca kwingilamo cikwete';

  @override
  String get setPasswordValidationNewRequired => 'Icifulo cipya cikwete';

  @override
  String get setPasswordValidationNewTooShort =>
      'Icifulo ca mucinshi cilekwa ifyalembo 8';

  @override
  String get setPasswordValidationNewSameAsTemp =>
      'Icifulo cipya cilekwa kucifikana ne ca kwingilamo';

  @override
  String get setPasswordValidationConfirmRequired =>
      'Tafwaya kusuminisha icifulo ca mucinshi';

  @override
  String get setPasswordValidationConfirmMismatch =>
      'Ififulo ca mucinshi tafya filingana';

  @override
  String get setPasswordSubmit => 'Tuma';

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
  String get passwordSuccessTitle => 'Wafwayapo';

  @override
  String get passwordSuccessBody => 'Icifulo ca Mucinshi Casuminishiwa.';

  @override
  String get passwordSuccessLogin => 'Ingila Nomba';

  @override
  String get splashTagline => 'CITIZEN ONE';

  @override
  String get profileTabPersonal => 'Ifikabo';

  @override
  String get profileTabSecurity => 'Ubucinshi';

  @override
  String get profileTabServices => 'Inshita';

  @override
  String get profileTabPayments => 'Ifyakuipaya';

  @override
  String get agentTabProfile => 'Ifikabo';

  @override
  String get agentTabWork => 'Umweo';

  @override
  String get agentTabTransactions => 'Ifyo Baipaye';

  @override
  String get agentTabPerformance => 'Umweo Wabwino';

  @override
  String get profileActionLogout => 'Fuma';

  @override
  String profileLabelGoldBenefits(int count) {
    return '$count Active Gold Benefits';
  }

  @override
  String get profileActionDeactivate => 'Sengula / Ufunge Akaunti';

  @override
  String get profileSectionMore => 'IFYABWINO';

  @override
  String get profileGroupSettings => 'Ifyo Baika';

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
    return 'Last Login: $time';
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
  String get profileGroupSupport => 'Amafweko';

  @override
  String get profileGroupAbout => 'Pali Cino';

  @override
  String get profileGroupSecurity => 'Ubucinshi';

  @override
  String get profileGroupHelpAbout => 'Amafweko & Pali Cino';

  @override
  String get profileMenuLanguage => 'Ukusala Ululimi';

  @override
  String get profileMenuNotifications => 'Amashiwi ya Ndondwa';

  @override
  String get profileMenuLocation => 'Ifyalo & Inshita Shansi';

  @override
  String get profileMenuTheme => 'Ubunobwe (Ubwino / Ubwindililika)';

  @override
  String get profileMenuSupportTicket => 'Funda Tikiti ya Amafweko';

  @override
  String get profileMenuFAQs => 'Imiputulo iishibikwa';

  @override
  String get profileMenuChatSupport => 'Kukombela / Kufumya Amafweko';

  @override
  String get profileMenuReportIssue => 'Landila Icakubupwa';

  @override
  String get profileMenuFeedback => 'Amafunde & Abaise';

  @override
  String get profileMenuAbout => 'Pali CitizenOne';

  @override
  String get profileMenuWhatsNew => 'Ifyo Fibonse Fipya';

  @override
  String get profileMenuAppVersion => 'Insendwa ya App';

  @override
  String get profileMenuPrivacyPolicy => 'Ubupalamano bwa Fyakumucinshi';

  @override
  String get profileMenuTerms => 'Imilandu & Ifintu';

  @override
  String get quickActionPay => 'Lipila';

  @override
  String get quickActionScanQr => 'Salanganya QR';

  @override
  String get quickActionApplyLoan => 'Lomba Ingawe';

  @override
  String get quickActionSupport => 'Amafweko';

  @override
  String get quickActionAgriLoan => 'Ingawe ya Bulimi';

  @override
  String get quickActionWeather => 'Mfula';

  @override
  String get quickActionMarket => 'Kasoko';

  @override
  String get quickActionOnboard => 'Ingisha Bambi';

  @override
  String get quickActionCollect => 'Bokola';

  @override
  String get quickActionTodayTasks => 'Ifintu fya Lelo';

  @override
  String get dashboardSectionQuickActions => 'Ifintu Ifyashininkisha';

  @override
  String get dashboardSectionAllServices => 'Inshita Iyonse';

  @override
  String get dashboardActionViewAll => 'Monako Iyonse';

  @override
  String get dashboardSectionRecentActivity => 'Ifyo Fyacitwa Mpela Nomba';

  @override
  String get heroCardCitizenLabel => 'Amashiwi ya Citizen AI';

  @override
  String get heroCardAgentLabel => 'UMWEO WA AGENT';

  @override
  String get heroCardFarmerLabel => 'AMASHIWI YA MFULA';

  @override
  String get heroCardCitizenTitle => 'Insapo ya Mwela ya Nkome';

  @override
  String get heroCardCitizenDueTag => 'Nkocela Mailo';

  @override
  String get heroCardCitizenDueNote => 'Nkocela mu nsiku 5';

  @override
  String get heroCardAgentCommissionLabel => 'Ubushiku bwa Komisho';

  @override
  String get heroCardFarmerRainfallLabel => 'Amashiwi ya Mfula';

  @override
  String get heroCardFarmerRainfallValue => 'Mfula ya Bungi';

  @override
  String get heroCardFarmerRainfallNote => 'Ikafikila mu nsiku 2';

  @override
  String get heroCardFarmerRainExpectedNote => 'Icindamika Mfula ya Bungi';

  @override
  String get heroBtnViewTasks => 'Monako Ifintu';

  @override
  String get heroBtnViewForecast => 'Monako Ifintu ifya Mfula';

  @override
  String get heroBtnPayNow => 'Lipila Nomba';

  @override
  String get errorGeneric => 'Fwile pantu. Esha cine.';

  @override
  String get errorNetwork => 'Tapali internet.';

  @override
  String get errorSession => 'Inshita yobe yafuma. Ingila cine.';

  @override
  String get loadingLabel => 'Tulelikanya…';

  @override
  String get retryLabel => 'Esha Cine';

  @override
  String get cancelLabel => 'Cinganiko';

  @override
  String get saveLabel => 'Bika';

  @override
  String get confirmLabel => 'Shinkisha';

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
    return 'Prepaid | Expires in $days days';
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
