import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bem.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bem'),
    Locale('en'),
  ];

  /// The application name displayed in title bars and splash screen
  ///
  /// In en, this message translates to:
  /// **'Citizen One'**
  String get appTitle;

  /// Current application version string
  ///
  /// In en, this message translates to:
  /// **'v1.0.0'**
  String get appVersion;

  /// Bottom nav bar and side rail: Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom nav bar and side rail: Services tab label
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get navServices;

  /// Bottom nav bar and side rail: Alerts tab label
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get navAlerts;

  /// Bottom nav bar and side rail: Profile tab label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// Central QR pay FAB label in bottom nav bar
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get navPay;

  /// Desktop header title
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get headerDashboard;

  /// Mobile header greeting shown next to user avatar
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get headerGreeting;

  /// Default location label displayed in mobile header
  ///
  /// In en, this message translates to:
  /// **'Lusaka'**
  String get headerLocation;

  /// Label above context toggle in agent side nav and mobile header
  ///
  /// In en, this message translates to:
  /// **'WORK CONTEXT'**
  String get agentWorkContext;

  /// Settings menu item and section group label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsLabel;

  /// Main heading on login screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to CitizenOne'**
  String get loginWelcomeTitle;

  /// Subtitle below heading on login screen
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get loginSubtitle;

  /// Label above personal dropdown on login screen
  ///
  /// In en, this message translates to:
  /// **'Select Personal'**
  String get loginSelectPersona;

  /// Hint text for personal dropdown on login screen
  ///
  /// In en, this message translates to:
  /// **'Choose your role'**
  String get loginChooseRole;

  /// No description provided for @authContextSelect.
  ///
  /// In en, this message translates to:
  /// **'Select Context'**
  String get authContextSelect;

  /// No description provided for @authRoleCitizen.
  ///
  /// In en, this message translates to:
  /// **'Citizen'**
  String get authRoleCitizen;

  /// No description provided for @authRoleCitizenDesc.
  ///
  /// In en, this message translates to:
  /// **'Access personal services and applications'**
  String get authRoleCitizenDesc;

  /// No description provided for @authRoleAgent.
  ///
  /// In en, this message translates to:
  /// **'Service Agent'**
  String get authRoleAgent;

  /// No description provided for @authRoleAgentDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage applications and help citizens'**
  String get authRoleAgentDesc;

  /// Validation message when no personal is selected on login
  ///
  /// In en, this message translates to:
  /// **'Please select a personal'**
  String get loginValidationSelectPersona;

  /// Label for username field on login screen
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get loginUsernameLabel;

  /// Hint text for username field on login screen
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get loginUsernameHint;

  /// Validation message when username field is empty on login
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get loginValidationUsernameRequired;

  /// Label for password field on login screen
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// Hint text for password field on login screen
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginPasswordHint;

  /// Validation message when password field is empty on login
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get loginValidationPasswordRequired;

  /// Login button label when a role is selected
  ///
  /// In en, this message translates to:
  /// **'Login as {roleName}'**
  String loginButtonAs(String roleName);

  /// Default login button label when no role is selected
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// Label for the mobile number field on the login screen
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get loginMobileLabel;

  /// Hint text for the mobile number field on the login screen
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number'**
  String get loginMobileHint;

  /// Validation message when the mobile number is empty or malformed on login
  ///
  /// In en, this message translates to:
  /// **'Mobile number is required'**
  String get loginValidationMobileRequired;

  /// Link to the forgot-password flow on the login screen
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get loginForgotPassword;

  /// Temporary message shown when the user taps Forgot Password before the feature ships
  ///
  /// In en, this message translates to:
  /// **'Forgot password flow is coming soon.'**
  String get loginForgotPasswordPending;

  /// Branding line at the top of the forgot-password screen
  ///
  /// In en, this message translates to:
  /// **'CitizenOne / ZAMPOST'**
  String get forgotPasswordBrand;

  /// Title of the forgot-password screen
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordTitle;

  /// Body text below the forgot-password screen title
  ///
  /// In en, this message translates to:
  /// **'Enter your registered mobile number below — we\'ll verify your identity and guide you through resetting it.'**
  String get forgotPasswordBody;

  /// Label above the mobile-number input on the forgot-password screen
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get forgotPasswordMobileLabel;

  /// Hint for the mobile-number input on the forgot-password screen
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number'**
  String get forgotPasswordMobileHint;

  /// Validation error when the mobile number is missing or invalid
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid mobile number'**
  String get forgotPasswordMobileRequired;

  /// Information banner explaining the identity verification step
  ///
  /// In en, this message translates to:
  /// **'For your security, we will send a one-time password (OTP) to verify your identity before allowing you to reset your password.'**
  String get forgotPasswordInfoBanner;

  /// Continue button on the forgot-password screen
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get forgotPasswordContinue;

  /// Prefix text next to the Sign In link on the forgot-password screen
  ///
  /// In en, this message translates to:
  /// **'Remember your password?'**
  String get forgotPasswordRememberPrefix;

  /// Sign In link on the forgot-password screen
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get forgotPasswordSignIn;

  /// Title of the OTP verification screen
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get forgotPasswordOtpTitle;

  /// Card title on the OTP screen
  ///
  /// In en, this message translates to:
  /// **'One Time Verification'**
  String get forgotPasswordOtpCardTitle;

  /// Body text on the OTP screen
  ///
  /// In en, this message translates to:
  /// **'To verify your identity, enter the One-Time Password (OTP) sent to your registered mobile number.'**
  String get forgotPasswordOtpBody;

  /// Validation error when the OTP is empty
  ///
  /// In en, this message translates to:
  /// **'OTP is required'**
  String get forgotPasswordOtpRequired;

  /// Validation error when the OTP length is not 6
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 6-digit OTP'**
  String get forgotPasswordOtpInvalid;

  /// Seconds unit label next to the OTP countdown
  ///
  /// In en, this message translates to:
  /// **'Sec'**
  String get forgotPasswordOtpSec;

  /// Label showing the number of attempts remaining for the OTP
  ///
  /// In en, this message translates to:
  /// **'Attempts Left {count}'**
  String forgotPasswordOtpAttemptsLeft(int count);

  /// Resend OTP button label
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get forgotPasswordOtpResend;

  /// Confirmation snackbar after a successful OTP resend
  ///
  /// In en, this message translates to:
  /// **'A new OTP has been sent to your registered mobile number.'**
  String get forgotPasswordOtpResent;

  /// Verify OTP bottom button label
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get forgotPasswordOtpVerify;

  /// Title of the create password screen
  ///
  /// In en, this message translates to:
  /// **'Create Password'**
  String get createPasswordTitle;

  /// Subtitle of the create password screen
  ///
  /// In en, this message translates to:
  /// **'Set a strong password for your account'**
  String get createPasswordSubtitle;

  /// Label for the new password field
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get createPasswordNewLabel;

  /// Hint for the new password field
  ///
  /// In en, this message translates to:
  /// **'Enter Your New Password'**
  String get createPasswordNewHint;

  /// Label for the confirm password field
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get createPasswordConfirmLabel;

  /// Hint for the confirm password field
  ///
  /// In en, this message translates to:
  /// **'Enter Your Confirm Password'**
  String get createPasswordConfirmHint;

  /// Title above the password requirements list
  ///
  /// In en, this message translates to:
  /// **'Your password must contain:'**
  String get createPasswordRulesTitle;

  /// Inline error when confirm password does not match new password
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get createPasswordMismatch;

  /// Submit button on the create password screen
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get createPasswordSubmit;

  /// Password rule: length must be 8-30 characters
  ///
  /// In en, this message translates to:
  /// **'8 - 30 characters'**
  String get passwordRuleLength;

  /// Password rule: must contain an uppercase letter
  ///
  /// In en, this message translates to:
  /// **'An upper case letter (A-Z)'**
  String get passwordRuleUpper;

  /// Password rule: must contain a lowercase letter
  ///
  /// In en, this message translates to:
  /// **'A lower case letter (a-z)'**
  String get passwordRuleLower;

  /// Password rule: must contain a number
  ///
  /// In en, this message translates to:
  /// **'A number (0-9)'**
  String get passwordRuleDigit;

  /// Password rule: must contain a special character
  ///
  /// In en, this message translates to:
  /// **'A special character'**
  String get passwordRuleSpecial;

  /// Password rule: no run of the same character longer than 3
  ///
  /// In en, this message translates to:
  /// **'No successive characters over 3'**
  String get passwordRuleNoSuccessiveOver3;

  /// Password rule: no single character may appear more than 3 times in the password
  ///
  /// In en, this message translates to:
  /// **'No character repeated more than 3 times'**
  String get passwordRuleNoCharMoreThan3;

  /// Title of the password setup required bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Password Setup Required'**
  String get passwordSetupRequiredTitle;

  /// Body text of the password setup required bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Your Account has not yet completed the initial password setup. Please reset your password to continue'**
  String get passwordSetupRequiredBody;

  /// Continue button on the password setup required bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get passwordSetupRequiredContinue;

  /// Close button on the password setup required bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get passwordSetupRequiredClose;

  /// Title of the set password screen
  ///
  /// In en, this message translates to:
  /// **'Set Your Password'**
  String get setPasswordTitle;

  /// Subtitle of the set password screen
  ///
  /// In en, this message translates to:
  /// **'Set your password to continue'**
  String get setPasswordSubtitle;

  /// Label for the temporary password field
  ///
  /// In en, this message translates to:
  /// **'Temporary Password'**
  String get setPasswordTempLabel;

  /// Hint for the temporary password field
  ///
  /// In en, this message translates to:
  /// **'Enter Old Password'**
  String get setPasswordTempHint;

  /// Label for the new password field
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get setPasswordNewLabel;

  /// Hint for the new password field
  ///
  /// In en, this message translates to:
  /// **'Enter Your New Password'**
  String get setPasswordNewHint;

  /// Label for the confirm password field
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get setPasswordConfirmLabel;

  /// Hint for the confirm password field
  ///
  /// In en, this message translates to:
  /// **'Enter Your Confirm Password'**
  String get setPasswordConfirmHint;

  /// Validation error when the temporary password is empty
  ///
  /// In en, this message translates to:
  /// **'Temporary password is required'**
  String get setPasswordValidationTempRequired;

  /// Validation error when the new password is empty
  ///
  /// In en, this message translates to:
  /// **'New password is required'**
  String get setPasswordValidationNewRequired;

  /// Validation error when the new password is too short
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get setPasswordValidationNewTooShort;

  /// Validation error when the new password equals the temporary password
  ///
  /// In en, this message translates to:
  /// **'New password must differ from the temporary password'**
  String get setPasswordValidationNewSameAsTemp;

  /// Validation error when the confirm password is empty
  ///
  /// In en, this message translates to:
  /// **'Please confirm your new password'**
  String get setPasswordValidationConfirmRequired;

  /// Validation error when the confirm password does not match the new password
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get setPasswordValidationConfirmMismatch;

  /// Submit button on the set password screen
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get setPasswordSubmit;

  /// Title of the agent-initiated change password screen (Settings > Security)
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// Subtitle of the agent-initiated change password screen
  ///
  /// In en, this message translates to:
  /// **'Update the password for your account'**
  String get changePasswordSubtitle;

  /// Label for the current password field
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get changePasswordCurrentLabel;

  /// Hint for the current password field
  ///
  /// In en, this message translates to:
  /// **'Enter Current Password'**
  String get changePasswordCurrentHint;

  /// Validation error when the current password is empty
  ///
  /// In en, this message translates to:
  /// **'Current password is required'**
  String get changePasswordValidationCurrentRequired;

  /// Validation error when the new password equals the current password
  ///
  /// In en, this message translates to:
  /// **'New password must differ from the current password'**
  String get changePasswordValidationNewSameAsCurrent;

  /// Title of the password change success screen
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get passwordSuccessTitle;

  /// Body text of the password change success screen
  ///
  /// In en, this message translates to:
  /// **'Your Password has been Successfully Updated.'**
  String get passwordSuccessBody;

  /// Login Now button on the password change success screen
  ///
  /// In en, this message translates to:
  /// **'Login Now'**
  String get passwordSuccessLogin;

  /// All-caps brand tagline displayed on splash screen
  ///
  /// In en, this message translates to:
  /// **'CITIZEN ONE'**
  String get splashTagline;

  /// First tab label on customer profile screen
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get profileTabPersonal;

  /// Second tab label on customer profile screen
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get profileTabSecurity;

  /// Third tab label on customer profile screen
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get profileTabServices;

  /// Fourth tab label on customer profile screen
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get profileTabPayments;

  /// First tab label on agent profile screen
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get agentTabProfile;

  /// Second tab label on agent profile screen
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get agentTabWork;

  /// Third tab label on agent profile screen
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get agentTabTransactions;

  /// Fourth tab label on agent profile screen
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get agentTabPerformance;

  /// Log out action button on profile screen
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileActionLogout;

  /// No description provided for @profileLabelGoldBenefits.
  ///
  /// In en, this message translates to:
  /// **'{count} Active Gold Benefits'**
  String profileLabelGoldBenefits(int count);

  /// Account deactivation action button on profile screen
  ///
  /// In en, this message translates to:
  /// **'Deactivate / Close Account'**
  String get profileActionDeactivate;

  /// Section label above the More accordion group on profile screen
  ///
  /// In en, this message translates to:
  /// **'MORE'**
  String get profileSectionMore;

  /// Settings accordion group title on profile screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileGroupSettings;

  /// No description provided for @profileMenuProfileDetails.
  ///
  /// In en, this message translates to:
  /// **'Profile Details'**
  String get profileMenuProfileDetails;

  /// No description provided for @profileMenuContactDetails.
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get profileMenuContactDetails;

  /// No description provided for @profileMenuAddressInfo.
  ///
  /// In en, this message translates to:
  /// **'Address Information'**
  String get profileMenuAddressInfo;

  /// No description provided for @profileMenuKycVerification.
  ///
  /// In en, this message translates to:
  /// **'KYC / Verification'**
  String get profileMenuKycVerification;

  /// No description provided for @profileMenuChangePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN / Password'**
  String get profileMenuChangePin;

  /// No description provided for @profileMenuBiometric.
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get profileMenuBiometric;

  /// No description provided for @profileMenuLoginActivity.
  ///
  /// In en, this message translates to:
  /// **'Login Activity'**
  String get profileMenuLoginActivity;

  /// No description provided for @profileMenuConsent.
  ///
  /// In en, this message translates to:
  /// **'Consent & Data Permissions'**
  String get profileMenuConsent;

  /// No description provided for @profileMenuMyLoans.
  ///
  /// In en, this message translates to:
  /// **'My Loans'**
  String get profileMenuMyLoans;

  /// No description provided for @profileMenuLoanRepayment.
  ///
  /// In en, this message translates to:
  /// **'Loan Repayment Schedule'**
  String get profileMenuLoanRepayment;

  /// No description provided for @profileMenuInsurancePolicies.
  ///
  /// In en, this message translates to:
  /// **'My Insurance Policies'**
  String get profileMenuInsurancePolicies;

  /// No description provided for @profileMenuInsuranceCoverage.
  ///
  /// In en, this message translates to:
  /// **'Insurance Coverage'**
  String get profileMenuInsuranceCoverage;

  /// No description provided for @profileMenuSubsidies.
  ///
  /// In en, this message translates to:
  /// **'Subsidies & Govt Benefits'**
  String get profileMenuSubsidies;

  /// No description provided for @profileMenuServiceRequests.
  ///
  /// In en, this message translates to:
  /// **'Service Requests'**
  String get profileMenuServiceRequests;

  /// No description provided for @profileMenuBankAccounts.
  ///
  /// In en, this message translates to:
  /// **'Linked Bank Accounts'**
  String get profileMenuBankAccounts;

  /// No description provided for @profileMenuWallets.
  ///
  /// In en, this message translates to:
  /// **'Linked Wallets / Cards'**
  String get profileMenuWallets;

  /// No description provided for @profileMenuDefaultPayment.
  ///
  /// In en, this message translates to:
  /// **'Default Payment Method'**
  String get profileMenuDefaultPayment;

  /// No description provided for @profileMenuTransactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get profileMenuTransactionHistory;

  /// No description provided for @profileMenuStatements.
  ///
  /// In en, this message translates to:
  /// **'Statements / Receipts'**
  String get profileMenuStatements;

  /// No description provided for @profileAgentMenuIdRole.
  ///
  /// In en, this message translates to:
  /// **'Agent ID & Role'**
  String get profileAgentMenuIdRole;

  /// No description provided for @profileAgentMenuRegion.
  ///
  /// In en, this message translates to:
  /// **'Assigned Region / Branch'**
  String get profileAgentMenuRegion;

  /// No description provided for @profileAgentMenuValidity.
  ///
  /// In en, this message translates to:
  /// **'Validity / Renewal Dates'**
  String get profileAgentMenuValidity;

  /// No description provided for @profileAgentMenuAgreement.
  ///
  /// In en, this message translates to:
  /// **'Agent Agreement'**
  String get profileAgentMenuAgreement;

  /// No description provided for @profileAgentMenuIdProof.
  ///
  /// In en, this message translates to:
  /// **'ID Proof / License'**
  String get profileAgentMenuIdProof;

  /// No description provided for @profileAgentMenuCertificates.
  ///
  /// In en, this message translates to:
  /// **'Training Certificates'**
  String get profileAgentMenuCertificates;

  /// No description provided for @profileAgentMenuCustomers.
  ///
  /// In en, this message translates to:
  /// **'Assigned Customers'**
  String get profileAgentMenuCustomers;

  /// No description provided for @profileAgentMenuTasks.
  ///
  /// In en, this message translates to:
  /// **'Pending Tasks'**
  String get profileAgentMenuTasks;

  /// No description provided for @profileAgentMenuTargets.
  ///
  /// In en, this message translates to:
  /// **'Daily / Weekly Targets'**
  String get profileAgentMenuTargets;

  /// No description provided for @profileAgentMenuTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions Performed'**
  String get profileAgentMenuTransactions;

  /// No description provided for @profileAgentMenuCollections.
  ///
  /// In en, this message translates to:
  /// **'Collections / Disbursements'**
  String get profileAgentMenuCollections;

  /// No description provided for @profileAgentMenuHistory.
  ///
  /// In en, this message translates to:
  /// **'Assisted Services History'**
  String get profileAgentMenuHistory;

  /// No description provided for @profileAgentMenuBanking.
  ///
  /// In en, this message translates to:
  /// **'Banking Services'**
  String get profileAgentMenuBanking;

  /// No description provided for @profileAgentMenuLoanOrigination.
  ///
  /// In en, this message translates to:
  /// **'Loan Origination'**
  String get profileAgentMenuLoanOrigination;

  /// No description provided for @profileAgentMenuInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance Enrollment'**
  String get profileAgentMenuInsurance;

  /// No description provided for @profileAgentMenuGovSchemes.
  ///
  /// In en, this message translates to:
  /// **'Government Schemes'**
  String get profileAgentMenuGovSchemes;

  /// No description provided for @profileAgentMenuKpis.
  ///
  /// In en, this message translates to:
  /// **'KPIs / SLAs'**
  String get profileAgentMenuKpis;

  /// No description provided for @profileAgentMenuSuccessRate.
  ///
  /// In en, this message translates to:
  /// **'Success Rate'**
  String get profileAgentMenuSuccessRate;

  /// No description provided for @profileAgentMenuTurnaround.
  ///
  /// In en, this message translates to:
  /// **'Turnaround Time'**
  String get profileAgentMenuTurnaround;

  /// No description provided for @profileAgentMenuCommission.
  ///
  /// In en, this message translates to:
  /// **'Commission Summary'**
  String get profileAgentMenuCommission;

  /// No description provided for @profileAgentMenuPendingPaid.
  ///
  /// In en, this message translates to:
  /// **'Pending vs Paid'**
  String get profileAgentMenuPendingPaid;

  /// No description provided for @profileAgentMenuSettlement.
  ///
  /// In en, this message translates to:
  /// **'Settlement History'**
  String get profileAgentMenuSettlement;

  /// No description provided for @profileMenuOfflineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline Mode'**
  String get profileMenuOfflineMode;

  /// No description provided for @profileMenuSyncStatus.
  ///
  /// In en, this message translates to:
  /// **'Sync Status'**
  String get profileMenuSyncStatus;

  /// No description provided for @profileMenuTrainingManuals.
  ///
  /// In en, this message translates to:
  /// **'Training & Manuals'**
  String get profileMenuTrainingManuals;

  /// No description provided for @profileMenuDeviceBinding.
  ///
  /// In en, this message translates to:
  /// **'Device Binding'**
  String get profileMenuDeviceBinding;

  /// No description provided for @profileMenuSessionHistory.
  ///
  /// In en, this message translates to:
  /// **'Session History'**
  String get profileMenuSessionHistory;

  /// No description provided for @profileMenuActivityLogs.
  ///
  /// In en, this message translates to:
  /// **'Activity Logs'**
  String get profileMenuActivityLogs;

  /// No description provided for @profileMenuGeoTagged.
  ///
  /// In en, this message translates to:
  /// **'Geo-tagged Transactions'**
  String get profileMenuGeoTagged;

  /// No description provided for @profileMenuConsentRecords.
  ///
  /// In en, this message translates to:
  /// **'Consent Records'**
  String get profileMenuConsentRecords;

  /// No description provided for @profileStatKyc.
  ///
  /// In en, this message translates to:
  /// **'KYC'**
  String get profileStatKyc;

  /// No description provided for @profileStatCards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get profileStatCards;

  /// No description provided for @profileStatLoans.
  ///
  /// In en, this message translates to:
  /// **'Loans'**
  String get profileStatLoans;

  /// No description provided for @profileStatCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get profileStatCustomers;

  /// No description provided for @profileStatTarget.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get profileStatTarget;

  /// No description provided for @profileStatEarnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get profileStatEarnings;

  /// No description provided for @profileLabelVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get profileLabelVerified;

  /// No description provided for @profileLabelGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get profileLabelGold;

  /// No description provided for @profileLabelGoldMember.
  ///
  /// In en, this message translates to:
  /// **'Gold Member'**
  String get profileLabelGoldMember;

  /// No description provided for @profileLabelRegionActive.
  ///
  /// In en, this message translates to:
  /// **'Lusaka Region'**
  String get profileLabelRegionActive;

  /// No description provided for @profileLabelAccountId.
  ///
  /// In en, this message translates to:
  /// **'Account ID: {id}'**
  String profileLabelAccountId(String id);

  /// No description provided for @profileLabelLastLogin.
  ///
  /// In en, this message translates to:
  /// **'{time}'**
  String profileLabelLastLogin(String time);

  /// No description provided for @profileLabelLinked.
  ///
  /// In en, this message translates to:
  /// **'{count} Linked'**
  String profileLabelLinked(Object count);

  /// No description provided for @profileLabelActiveCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Active'**
  String profileLabelActiveCount(Object count);

  /// No description provided for @profileLabelFieldAgent.
  ///
  /// In en, this message translates to:
  /// **'Field Agent'**
  String get profileLabelFieldAgent;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Alerts & Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationBillTitle.
  ///
  /// In en, this message translates to:
  /// **'Electricity Bill Due'**
  String get notificationBillTitle;

  /// No description provided for @notificationBillDesc.
  ///
  /// In en, this message translates to:
  /// **'Your bill of ZK 450.00 is due tomorrow. Pay now to avoid late fees.'**
  String get notificationBillDesc;

  /// No description provided for @notificationLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'New Login Detected'**
  String get notificationLoginTitle;

  /// No description provided for @notificationLoginDesc.
  ///
  /// In en, this message translates to:
  /// **'Login from new device (iPhone 13) in Lusaka.'**
  String get notificationLoginDesc;

  /// No description provided for @notificationInsightTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Insight'**
  String get notificationInsightTitle;

  /// No description provided for @notificationInsightDesc.
  ///
  /// In en, this message translates to:
  /// **'You spent 15% less on groceries this week compared to last month. Great job!'**
  String get notificationInsightDesc;

  /// No description provided for @notificationPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Received'**
  String get notificationPaymentTitle;

  /// No description provided for @notificationPaymentDesc.
  ///
  /// In en, this message translates to:
  /// **'Received ZK 5,000.00 from John Doe via Wallet.'**
  String get notificationPaymentDesc;

  /// No description provided for @notificationTimeHours.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String notificationTimeHours(Object count);

  /// No description provided for @notificationTimeYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get notificationTimeYesterday;

  /// No description provided for @aiAssistantTitle.
  ///
  /// In en, this message translates to:
  /// **'Citizen AI'**
  String get aiAssistantTitle;

  /// No description provided for @aiAssistantTagline.
  ///
  /// In en, this message translates to:
  /// **'Always here to help'**
  String get aiAssistantTagline;

  /// No description provided for @aiAssistantInputHint.
  ///
  /// In en, this message translates to:
  /// **'Ask anything...'**
  String get aiAssistantInputHint;

  /// No description provided for @aiMessageGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello {name}! I noticed you are eligible for a personal loan up to ₹15L with lower interest rates. Would you like to explore?'**
  String aiMessageGreeting(String name);

  /// No description provided for @aiMessageUserReply.
  ///
  /// In en, this message translates to:
  /// **'Yes, tell me more about the interest rates.'**
  String get aiMessageUserReply;

  /// No description provided for @aiMessageLoanDetails.
  ///
  /// In en, this message translates to:
  /// **'Sure! HDFC is offering 10.5% p.a. specially for you. \n\nIf you take ₹5L for 5 years, your EMI will be ₹10,747. You save ₹1,200 compared to standard rates!'**
  String get aiMessageLoanDetails;

  /// No description provided for @aiActionApplyNow.
  ///
  /// In en, this message translates to:
  /// **'Apply Now'**
  String get aiActionApplyNow;

  /// No description provided for @aiActionCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get aiActionCompare;

  /// No description provided for @loansDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Loans Dashboard'**
  String get loansDashboardTitle;

  /// No description provided for @loansDashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find the right financing for you'**
  String get loansDashboardSubtitle;

  /// No description provided for @loanCategoryPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal Loan'**
  String get loanCategoryPersonal;

  /// No description provided for @loanCategoryHome.
  ///
  /// In en, this message translates to:
  /// **'Home Loan'**
  String get loanCategoryHome;

  /// No description provided for @loanCategoryVehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Loan'**
  String get loanCategoryVehicle;

  /// No description provided for @loanCategoryAgri.
  ///
  /// In en, this message translates to:
  /// **'Agri Loan'**
  String get loanCategoryAgri;

  /// No description provided for @loanCategoryEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get loanCategoryEducation;

  /// No description provided for @loanCategoryMsme.
  ///
  /// In en, this message translates to:
  /// **'MSME Business'**
  String get loanCategoryMsme;

  /// No description provided for @loanCategoryConstruction.
  ///
  /// In en, this message translates to:
  /// **'Construction'**
  String get loanCategoryConstruction;

  /// No description provided for @loanCategoryAsset.
  ///
  /// In en, this message translates to:
  /// **'Asset Based'**
  String get loanCategoryAsset;

  /// No description provided for @loansPromoTitle.
  ///
  /// In en, this message translates to:
  /// **'Need funds quickly?'**
  String get loansPromoTitle;

  /// No description provided for @loansPromoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get pre-approved personal loans up to ZK 50,000 instantly.'**
  String get loansPromoSubtitle;

  /// No description provided for @loansPromoAction.
  ///
  /// In en, this message translates to:
  /// **'Check Loan Eligibility'**
  String get loansPromoAction;

  /// No description provided for @loansCategoriesHeader.
  ///
  /// In en, this message translates to:
  /// **'Loan Categories'**
  String get loansCategoriesHeader;

  /// No description provided for @loansCategoriesViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get loansCategoriesViewAll;

  /// No description provided for @loansLabelAmount.
  ///
  /// In en, this message translates to:
  /// **'Loan Amount'**
  String get loansLabelAmount;

  /// No description provided for @loansLabelInterestRate.
  ///
  /// In en, this message translates to:
  /// **'Interest Rate (%)'**
  String get loansLabelInterestRate;

  /// No description provided for @loansLabelTenure.
  ///
  /// In en, this message translates to:
  /// **'Tenure (Months)'**
  String get loansLabelTenure;

  /// No description provided for @loansLabelMonthlyEmi.
  ///
  /// In en, this message translates to:
  /// **'Monthly EMI'**
  String get loansLabelMonthlyEmi;

  /// No description provided for @loansLabelTotalInterest.
  ///
  /// In en, this message translates to:
  /// **'Total Interest'**
  String get loansLabelTotalInterest;

  /// No description provided for @loansLabelTotalPayable.
  ///
  /// In en, this message translates to:
  /// **'Total Payable'**
  String get loansLabelTotalPayable;

  /// No description provided for @loansLabelPrincipalAmount.
  ///
  /// In en, this message translates to:
  /// **'Principal Amount'**
  String get loansLabelPrincipalAmount;

  /// No description provided for @loansEmiDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'* Note: The calculated EMI is indicative and may vary based on bank policies and processing fees.'**
  String get loansEmiDisclaimer;

  /// No description provided for @loansActionApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get loansActionApply;

  /// No description provided for @loansActionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get loansActionCancel;

  /// No description provided for @loansStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Application Status'**
  String get loansStatusTitle;

  /// No description provided for @loansLabelAmountHeader.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get loansLabelAmountHeader;

  /// No description provided for @loansLabelDateHeader.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get loansLabelDateHeader;

  /// No description provided for @loansLabelTrackingHistory.
  ///
  /// In en, this message translates to:
  /// **'Tracking History'**
  String get loansLabelTrackingHistory;

  /// No description provided for @loansStatusSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get loansStatusSubmitted;

  /// No description provided for @loansStatusCreditScoring.
  ///
  /// In en, this message translates to:
  /// **'Credit Scoring'**
  String get loansStatusCreditScoring;

  /// No description provided for @loansStatusEligibility.
  ///
  /// In en, this message translates to:
  /// **'Eligibility Check'**
  String get loansStatusEligibility;

  /// No description provided for @loansStatusApproval.
  ///
  /// In en, this message translates to:
  /// **'Final Approval'**
  String get loansStatusApproval;

  /// No description provided for @loansLabelActionRequired.
  ///
  /// In en, this message translates to:
  /// **'Action Required'**
  String get loansLabelActionRequired;

  /// No description provided for @loansActionUploadDocs.
  ///
  /// In en, this message translates to:
  /// **'Upload Documents'**
  String get loansActionUploadDocs;

  /// No description provided for @loansEmiCalcTitle.
  ///
  /// In en, this message translates to:
  /// **'EMI Calculator'**
  String get loansEmiCalcTitle;

  /// No description provided for @loansEmiCalcSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Plan your finances with our easy calculator'**
  String get loansEmiCalcSubtitle;

  /// No description provided for @loansWhyChooseHeader.
  ///
  /// In en, this message translates to:
  /// **'Why choose us?'**
  String get loansWhyChooseHeader;

  /// No description provided for @loansBenefit1Title.
  ///
  /// In en, this message translates to:
  /// **'Multiple Banks'**
  String get loansBenefit1Title;

  /// No description provided for @loansBenefit1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Compare rates from over 10+ partners.'**
  String get loansBenefit1Subtitle;

  /// No description provided for @loansBenefit2Title.
  ///
  /// In en, this message translates to:
  /// **'Paperless Process'**
  String get loansBenefit2Title;

  /// No description provided for @loansBenefit2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'100% digital application and documentation.'**
  String get loansBenefit2Subtitle;

  /// No description provided for @loansMyAppsHeader.
  ///
  /// In en, this message translates to:
  /// **'My Applications'**
  String get loansMyAppsHeader;

  /// No description provided for @loansAppRef.
  ///
  /// In en, this message translates to:
  /// **'Ref: {ref}'**
  String loansAppRef(Object ref);

  /// No description provided for @loansAppLastUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last update: {date}'**
  String loansAppLastUpdate(Object date);

  /// No description provided for @commonServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Common Services'**
  String get commonServicesTitle;

  /// No description provided for @commonServicesSystemOverview.
  ///
  /// In en, this message translates to:
  /// **'System Overview'**
  String get commonServicesSystemOverview;

  /// No description provided for @commonServicesUptime.
  ///
  /// In en, this message translates to:
  /// **'UPTIME'**
  String get commonServicesUptime;

  /// No description provided for @commonServicesLatency.
  ///
  /// In en, this message translates to:
  /// **'LATENCY'**
  String get commonServicesLatency;

  /// No description provided for @commonServicesQuickAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get commonServicesQuickAnalytics;

  /// No description provided for @commonServicesQuickTickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get commonServicesQuickTickets;

  /// No description provided for @commonServicesQuickAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get commonServicesQuickAdmin;

  /// No description provided for @commonServicesQuickSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get commonServicesQuickSupport;

  /// No description provided for @commonServicesLogs.
  ///
  /// In en, this message translates to:
  /// **'Service Logs'**
  String get commonServicesLogs;

  /// No description provided for @commonServicesUserMgmt.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get commonServicesUserMgmt;

  /// No description provided for @commonServicesSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security Controls'**
  String get commonServicesSecurity;

  /// No description provided for @commonServicesAiAlert.
  ///
  /// In en, this message translates to:
  /// **'CITIZEN AI ALERT'**
  String get commonServicesAiAlert;

  /// No description provided for @commonServicesAiPerf.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get commonServicesAiPerf;

  /// No description provided for @commonServicesAiStatus.
  ///
  /// In en, this message translates to:
  /// **'System load is normal. No incidents reported.'**
  String get commonServicesAiStatus;

  /// No description provided for @commonServicesAiDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get commonServicesAiDetails;

  /// Support accordion group title on profile screen
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get profileGroupSupport;

  /// About accordion group title on profile screen
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get profileGroupAbout;

  /// Security accordion group title on agent profile screen
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get profileGroupSecurity;

  /// Help and About accordion group title on agent profile screen
  ///
  /// In en, this message translates to:
  /// **'Help & About'**
  String get profileGroupHelpAbout;

  /// Language settings menu item on customer profile
  ///
  /// In en, this message translates to:
  /// **'Language Selection'**
  String get profileMenuLanguage;

  /// Notification preferences menu item on profile screen
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get profileMenuNotifications;

  /// Location and regional settings menu item on profile screen
  ///
  /// In en, this message translates to:
  /// **'Location & Regional Settings'**
  String get profileMenuLocation;

  /// Theme toggle menu item on profile screen
  ///
  /// In en, this message translates to:
  /// **'Theme (Light / Dark)'**
  String get profileMenuTheme;

  /// Support ticket menu item on profile screen
  ///
  /// In en, this message translates to:
  /// **'Raise Support Ticket'**
  String get profileMenuSupportTicket;

  /// FAQs menu item on profile screen
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get profileMenuFAQs;

  /// Chat / call support menu item on profile screen
  ///
  /// In en, this message translates to:
  /// **'Chat / Call Support'**
  String get profileMenuChatSupport;

  /// Report an issue menu item on profile screen
  ///
  /// In en, this message translates to:
  /// **'Report an Issue'**
  String get profileMenuReportIssue;

  /// Feedback and ratings menu item on profile screen
  ///
  /// In en, this message translates to:
  /// **'Feedback & Ratings'**
  String get profileMenuFeedback;

  /// About CitizenOne menu item on profile screen
  ///
  /// In en, this message translates to:
  /// **'About CitizenOne'**
  String get profileMenuAbout;

  /// What's New menu item on profile screen
  ///
  /// In en, this message translates to:
  /// **'What\'s New'**
  String get profileMenuWhatsNew;

  /// App version menu item on profile screen
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get profileMenuAppVersion;

  /// Privacy policy menu item on profile screen
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get profileMenuPrivacyPolicy;

  /// Terms and conditions menu item on profile screen
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get profileMenuTerms;

  /// Quick action button label — Pay (customer role)
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get quickActionPay;

  /// Quick action button label — Scan QR (customer role)
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get quickActionScanQr;

  /// Quick action button label — Apply Loan (customer role)
  ///
  /// In en, this message translates to:
  /// **'Apply Loan'**
  String get quickActionApplyLoan;

  /// Quick action button label — Support (all roles)
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get quickActionSupport;

  /// Quick action button label — Agri Loan (farmer role)
  ///
  /// In en, this message translates to:
  /// **'Agri Loan'**
  String get quickActionAgriLoan;

  /// Quick action button label — Weather (farmer role)
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get quickActionWeather;

  /// Quick action button label — Market (farmer role)
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get quickActionMarket;

  /// Quick action button label — Onboard (agent role)
  ///
  /// In en, this message translates to:
  /// **'Onboard'**
  String get quickActionOnboard;

  /// Quick action button label — Collect (agent role)
  ///
  /// In en, this message translates to:
  /// **'Collect'**
  String get quickActionCollect;

  /// Quick action button label — Today Tasks (agent role)
  ///
  /// In en, this message translates to:
  /// **'Today Tasks'**
  String get quickActionTodayTasks;

  /// Section header for Quick Actions on customer home screen
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get dashboardSectionQuickActions;

  /// Section header for All Services on customer home screen
  ///
  /// In en, this message translates to:
  /// **'All Services'**
  String get dashboardSectionAllServices;

  /// Action label on section headers to navigate to full list
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get dashboardActionViewAll;

  /// Section header for Recent Activity on home screen
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get dashboardSectionRecentActivity;

  /// Pill label on citizen hero card
  ///
  /// In en, this message translates to:
  /// **'Citizen AI Alert'**
  String get heroCardCitizenLabel;

  /// Pill label on agent hero card
  ///
  /// In en, this message translates to:
  /// **'Agent Performance'**
  String get heroCardAgentLabel;

  /// Pill label on farmer hero card
  ///
  /// In en, this message translates to:
  /// **'WEATHER ALERT'**
  String get heroCardFarmerLabel;

  /// Main headline on citizen hero card
  ///
  /// In en, this message translates to:
  /// **'Electricity Bill Due'**
  String get heroCardCitizenTitle;

  /// Due date badge on citizen hero card
  ///
  /// In en, this message translates to:
  /// **'Due Tomorrow'**
  String get heroCardCitizenDueTag;

  /// Secondary due date note on citizen hero card (desktop)
  ///
  /// In en, this message translates to:
  /// **'Due in 5 days'**
  String get heroCardCitizenDueNote;

  /// Sub-label above commission value on agent hero card
  ///
  /// In en, this message translates to:
  /// **'Commission Earned'**
  String get heroCardAgentCommissionLabel;

  /// Sub-label above rainfall alert on farmer hero card
  ///
  /// In en, this message translates to:
  /// **'Rainfall Alert'**
  String get heroCardFarmerRainfallLabel;

  /// Main headline value on farmer hero card
  ///
  /// In en, this message translates to:
  /// **'Heavy Rain'**
  String get heroCardFarmerRainfallValue;

  /// Secondary note below rainfall value on farmer hero card
  ///
  /// In en, this message translates to:
  /// **'Expected in 2 days'**
  String get heroCardFarmerRainfallNote;

  /// Desktop-only trailing note on farmer hero card
  ///
  /// In en, this message translates to:
  /// **'Heavy Rain Expected'**
  String get heroCardFarmerRainExpectedNote;

  /// Primary button label on agent hero card
  ///
  /// In en, this message translates to:
  /// **'View Tasks'**
  String get heroBtnViewTasks;

  /// Primary button label on farmer hero card
  ///
  /// In en, this message translates to:
  /// **'View Forecast'**
  String get heroBtnViewForecast;

  /// Primary button label on citizen hero card
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get heroBtnPayNow;

  /// Generic error message shown in error states
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// Network error message shown when offline
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get errorNetwork;

  /// Session expiry error message
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again.'**
  String get errorSession;

  /// Loading indicator label
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loadingLabel;

  /// Retry button label
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryLabel;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// Save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveLabel;

  /// Confirm button label
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmLabel;

  /// Title for the Banking Services screen
  ///
  /// In en, this message translates to:
  /// **'Banking Services'**
  String get serviceBankingTitle;

  /// Label for balance in banking hero
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get serviceBankingBalanceLabel;

  /// No description provided for @serviceBankingBalanceChange.
  ///
  /// In en, this message translates to:
  /// **'{percentage} this month'**
  String serviceBankingBalanceChange(Object percentage);

  /// No description provided for @serviceBankingAccountSavings.
  ///
  /// In en, this message translates to:
  /// **'Savings: **** {lastFour}'**
  String serviceBankingAccountSavings(Object lastFour);

  /// No description provided for @serviceBankingActionTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get serviceBankingActionTransfer;

  /// No description provided for @serviceBankingActionLoan.
  ///
  /// In en, this message translates to:
  /// **'Loan'**
  String get serviceBankingActionLoan;

  /// No description provided for @serviceBankingActionStatements.
  ///
  /// In en, this message translates to:
  /// **'Statements'**
  String get serviceBankingActionStatements;

  /// No description provided for @serviceBankingAccSavings.
  ///
  /// In en, this message translates to:
  /// **'Savings\nAccount'**
  String get serviceBankingAccSavings;

  /// No description provided for @serviceBankingAccCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current\nAccount'**
  String get serviceBankingAccCurrent;

  /// No description provided for @serviceBankingAccBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business\nAccount'**
  String get serviceBankingAccBusiness;

  /// No description provided for @serviceBankingAccFixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed /\nTerm Deposit'**
  String get serviceBankingAccFixed;

  /// No description provided for @serviceBankingLoanPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal\nLoan'**
  String get serviceBankingLoanPersonal;

  /// No description provided for @serviceBankingLoanBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business /\nSME Loan'**
  String get serviceBankingLoanBusiness;

  /// No description provided for @serviceBankingLoanHome.
  ///
  /// In en, this message translates to:
  /// **'Home\nLoan'**
  String get serviceBankingLoanHome;

  /// No description provided for @serviceBankingLoanVehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle\nLoan'**
  String get serviceBankingLoanVehicle;

  /// No description provided for @serviceBankingLoanAgri.
  ///
  /// In en, this message translates to:
  /// **'Agricultural\nLoan'**
  String get serviceBankingLoanAgri;

  /// No description provided for @serviceBankingCardClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic /\nStandard'**
  String get serviceBankingCardClassic;

  /// No description provided for @serviceBankingCardCashback.
  ///
  /// In en, this message translates to:
  /// **'Cashback\nCard'**
  String get serviceBankingCardCashback;

  /// No description provided for @serviceBankingCardRewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards\nCard'**
  String get serviceBankingCardRewards;

  /// No description provided for @serviceBankingCardTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel\nCard'**
  String get serviceBankingCardTravel;

  /// No description provided for @serviceBankingCardPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium /\nSignature'**
  String get serviceBankingCardPremium;

  /// No description provided for @serviceBankingCardSecured.
  ///
  /// In en, this message translates to:
  /// **'Secured\nCard'**
  String get serviceBankingCardSecured;

  /// No description provided for @serviceBankingCardBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business /\nCorporate'**
  String get serviceBankingCardBusiness;

  /// No description provided for @serviceBankingCardCobranded.
  ///
  /// In en, this message translates to:
  /// **'Co-branded\nCard'**
  String get serviceBankingCardCobranded;

  /// Header for recent transactions in banking
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get serviceBankingTransactions;

  /// Banking section: Accounts
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get serviceBankingSectionAccounts;

  /// Banking section: Loans
  ///
  /// In en, this message translates to:
  /// **'Loans'**
  String get serviceBankingSectionLoans;

  /// Banking section: Cards
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get serviceBankingSectionCards;

  /// Title for the Government Services screen
  ///
  /// In en, this message translates to:
  /// **'Government Services'**
  String get serviceGovtTitle;

  /// Subtitle for the Government Services screen
  ///
  /// In en, this message translates to:
  /// **'One-stop access to all government portals.'**
  String get serviceGovtSubtitle;

  /// Headline for govt services hero
  ///
  /// In en, this message translates to:
  /// **'Citizen Services'**
  String get serviceGovtHeroTitle;

  /// Govt blog title 1
  ///
  /// In en, this message translates to:
  /// **'Digital Land Records Update'**
  String get serviceGovtBlogTitle1;

  /// Govt blog snippet 1
  ///
  /// In en, this message translates to:
  /// **'Process for getting land records digitally is now faster.'**
  String get serviceGovtBlogSnippet1;

  /// Govt blog title 2
  ///
  /// In en, this message translates to:
  /// **'New Skill Mission Launched'**
  String get serviceGovtBlogTitle2;

  /// Govt blog snippet 2
  ///
  /// In en, this message translates to:
  /// **'Join the new vocational training programs for youth.'**
  String get serviceGovtBlogSnippet2;

  /// Title for Wealth Management screen
  ///
  /// In en, this message translates to:
  /// **'Wealth Management'**
  String get serviceWealthTitle;

  /// Label for portfolio value
  ///
  /// In en, this message translates to:
  /// **'Total Portfolio Value'**
  String get serviceWealthPortfolioLabel;

  /// Wealth AI insight title
  ///
  /// In en, this message translates to:
  /// **'Goal Analysis'**
  String get serviceWealthGoalAnalysis;

  /// No description provided for @serviceWealthAiGoalDesc.
  ///
  /// In en, this message translates to:
  /// **'You are on track to reach your \"New Car\" goal by Dec 2026.'**
  String get serviceWealthAiGoalDesc;

  /// No description provided for @serviceWealthActionInvest.
  ///
  /// In en, this message translates to:
  /// **'Invest'**
  String get serviceWealthActionInvest;

  /// No description provided for @serviceWealthActionFunds.
  ///
  /// In en, this message translates to:
  /// **'Funds'**
  String get serviceWealthActionFunds;

  /// No description provided for @serviceWealthActionSIPs.
  ///
  /// In en, this message translates to:
  /// **'SIPs'**
  String get serviceWealthActionSIPs;

  /// No description provided for @serviceWealthActionAdvisory.
  ///
  /// In en, this message translates to:
  /// **'Advisory'**
  String get serviceWealthActionAdvisory;

  /// No description provided for @serviceWealthMutualFunds.
  ///
  /// In en, this message translates to:
  /// **'Mutual Fund Operations'**
  String get serviceWealthMutualFunds;

  /// No description provided for @serviceWealthFixedDeposits.
  ///
  /// In en, this message translates to:
  /// **'Fixed Deposits'**
  String get serviceWealthFixedDeposits;

  /// No description provided for @serviceWealthPensionPlans.
  ///
  /// In en, this message translates to:
  /// **'Pension Plans (NPS)'**
  String get serviceWealthPensionPlans;

  /// Title for Insurance screen
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get serviceInsuranceTitle;

  /// Headline for active policies count
  ///
  /// In en, this message translates to:
  /// **'{count} Active Policies'**
  String serviceInsuranceActivePolicies(int count);

  /// No description provided for @serviceInsuranceActionBuyNew.
  ///
  /// In en, this message translates to:
  /// **'Buy New'**
  String get serviceInsuranceActionBuyNew;

  /// No description provided for @serviceInsuranceActionRenew.
  ///
  /// In en, this message translates to:
  /// **'Renew'**
  String get serviceInsuranceActionRenew;

  /// No description provided for @serviceInsuranceActionClaim.
  ///
  /// In en, this message translates to:
  /// **'Claim'**
  String get serviceInsuranceActionClaim;

  /// No description provided for @serviceInsuranceActionMyPolicies.
  ///
  /// In en, this message translates to:
  /// **'My Policies'**
  String get serviceInsuranceActionMyPolicies;

  /// Insurance AI insight title
  ///
  /// In en, this message translates to:
  /// **'Renewal Alert'**
  String get serviceInsuranceRenewalAlert;

  /// No description provided for @serviceInsuranceAiRenewalDesc.
  ///
  /// In en, this message translates to:
  /// **'Car Insurance expires in 5 days. Renew now to avoid inspection.'**
  String get serviceInsuranceAiRenewalDesc;

  /// No description provided for @serviceInsuranceNetworkHospitals.
  ///
  /// In en, this message translates to:
  /// **'Network Hospitals'**
  String get serviceInsuranceNetworkHospitals;

  /// No description provided for @serviceInsuranceDownloadPolicy.
  ///
  /// In en, this message translates to:
  /// **'Download Policy Copy'**
  String get serviceInsuranceDownloadPolicy;

  /// No description provided for @serviceInsuranceClaimStatus.
  ///
  /// In en, this message translates to:
  /// **'Claim Status'**
  String get serviceInsuranceClaimStatus;

  /// Title for Bill Pay screen
  ///
  /// In en, this message translates to:
  /// **'Bill Payments'**
  String get serviceBillPayTitle;

  /// No description provided for @serviceBillPayTotalDue.
  ///
  /// In en, this message translates to:
  /// **'Total Due'**
  String get serviceBillPayTotalDue;

  /// No description provided for @serviceBillPayDueNote.
  ///
  /// In en, this message translates to:
  /// **'Due within {days} days'**
  String serviceBillPayDueNote(int days);

  /// No description provided for @serviceBillPayActionPayAll.
  ///
  /// In en, this message translates to:
  /// **'Pay All Bills'**
  String get serviceBillPayActionPayAll;

  /// No description provided for @serviceBillPayActionPayBill.
  ///
  /// In en, this message translates to:
  /// **'Pay Bills'**
  String get serviceBillPayActionPayBill;

  /// No description provided for @serviceBillPayPrediction.
  ///
  /// In en, this message translates to:
  /// **'Bill Prediction'**
  String get serviceBillPayPrediction;

  /// No description provided for @serviceBillPayAiUsageDesc.
  ///
  /// In en, this message translates to:
  /// **'Your electricity bill is expected to be 10% lower next month.'**
  String get serviceBillPayAiUsageDesc;

  /// No description provided for @serviceBillPayActionElectricity.
  ///
  /// In en, this message translates to:
  /// **'Electricity'**
  String get serviceBillPayActionElectricity;

  /// No description provided for @serviceBillPayActionWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get serviceBillPayActionWater;

  /// No description provided for @serviceBillPayActionMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get serviceBillPayActionMobile;

  /// No description provided for @serviceBillPayActionAddNew.
  ///
  /// In en, this message translates to:
  /// **'Add New'**
  String get serviceBillPayActionAddNew;

  /// No description provided for @serviceBillPayHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get serviceBillPayHistory;

  /// No description provided for @serviceBillPayManage.
  ///
  /// In en, this message translates to:
  /// **'Manage Billers'**
  String get serviceBillPayManage;

  /// No description provided for @serviceBillPayAutoPay.
  ///
  /// In en, this message translates to:
  /// **'Auto-Pay Settings'**
  String get serviceBillPayAutoPay;

  /// No description provided for @serviceActionViewUsage.
  ///
  /// In en, this message translates to:
  /// **'View Usage'**
  String get serviceActionViewUsage;

  /// Title for HealthEzy screen
  ///
  /// In en, this message translates to:
  /// **'HealthEzy'**
  String get serviceHealthTitle;

  /// No description provided for @serviceHealthPassport.
  ///
  /// In en, this message translates to:
  /// **'Your Health Passport'**
  String get serviceHealthPassport;

  /// No description provided for @serviceHealthCheckupDue.
  ///
  /// In en, this message translates to:
  /// **'Checkup Due'**
  String get serviceHealthCheckupDue;

  /// No description provided for @serviceHealthAiCheckupDesc.
  ///
  /// In en, this message translates to:
  /// **'Annual dental checkup is due next week.'**
  String get serviceHealthAiCheckupDesc;

  /// No description provided for @serviceHealthActionVitals.
  ///
  /// In en, this message translates to:
  /// **'Vitals'**
  String get serviceHealthActionVitals;

  /// No description provided for @serviceHealthActionMedicines.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get serviceHealthActionMedicines;

  /// No description provided for @serviceHealthActionLabs.
  ///
  /// In en, this message translates to:
  /// **'Lab Tests'**
  String get serviceHealthActionLabs;

  /// No description provided for @serviceHealthActionRecords.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get serviceHealthActionRecords;

  /// No description provided for @serviceHealthSymptomChecker.
  ///
  /// In en, this message translates to:
  /// **'Symptom Checker'**
  String get serviceHealthSymptomChecker;

  /// No description provided for @serviceHealthVaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination History'**
  String get serviceHealthVaccination;

  /// No description provided for @serviceHealthHospitals.
  ///
  /// In en, this message translates to:
  /// **'Find Hospitals Nearby'**
  String get serviceHealthHospitals;

  /// No description provided for @serviceActionBookAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get serviceActionBookAppointment;

  /// Title for Mobile Recharge screen
  ///
  /// In en, this message translates to:
  /// **'Mobile & Airtime'**
  String get serviceMobileTitle;

  /// No description provided for @serviceMobileMyNumber.
  ///
  /// In en, this message translates to:
  /// **'My Number'**
  String get serviceMobileMyNumber;

  /// No description provided for @serviceMobileExpiryNote.
  ///
  /// In en, this message translates to:
  /// **'Prepaid • Expires in {days} days'**
  String serviceMobileExpiryNote(int days);

  /// No description provided for @serviceMobileDataLeft.
  ///
  /// In en, this message translates to:
  /// **'Data: {amount} GB left'**
  String serviceMobileDataLeft(String amount);

  /// No description provided for @serviceMobilePlanExpiring.
  ///
  /// In en, this message translates to:
  /// **'Plan Expiring'**
  String get serviceMobilePlanExpiring;

  /// No description provided for @serviceMobileAiPlanExpiringDesc.
  ///
  /// In en, this message translates to:
  /// **'Your 5G Data Pack expires tomorrow. Recharge now.'**
  String get serviceMobileAiPlanExpiringDesc;

  /// No description provided for @serviceMobileActionRecharge.
  ///
  /// In en, this message translates to:
  /// **'Recharge'**
  String get serviceMobileActionRecharge;

  /// No description provided for @serviceMobileActionDataPack.
  ///
  /// In en, this message translates to:
  /// **'Data Pack'**
  String get serviceMobileActionDataPack;

  /// No description provided for @serviceMobileActionPayBill.
  ///
  /// In en, this message translates to:
  /// **'Pay Bill'**
  String get serviceMobileActionPayBill;

  /// No description provided for @serviceMobileActionHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get serviceMobileActionHistory;

  /// No description provided for @serviceMobilePopularPlans.
  ///
  /// In en, this message translates to:
  /// **'Popular Plans'**
  String get serviceMobilePopularPlans;

  /// No description provided for @serviceMobileFamilyAccounts.
  ///
  /// In en, this message translates to:
  /// **'Family Accounts'**
  String get serviceMobileFamilyAccounts;

  /// No description provided for @serviceMobileRoaming.
  ///
  /// In en, this message translates to:
  /// **'Roaming Services'**
  String get serviceMobileRoaming;

  /// Govt services section: Health
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get serviceGovtSectionHealth;

  /// Govt services section: Education
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get serviceGovtSectionEducation;

  /// Govt services section: Land & Property
  ///
  /// In en, this message translates to:
  /// **'Land & Property'**
  String get serviceGovtSectionLand;

  /// Govt services section: Civic & Welfare
  ///
  /// In en, this message translates to:
  /// **'Civic & Welfare'**
  String get serviceGovtSectionCivic;

  /// No description provided for @serviceGovtActionTaxes.
  ///
  /// In en, this message translates to:
  /// **'Taxes'**
  String get serviceGovtActionTaxes;

  /// No description provided for @serviceGovtActionCertificates.
  ///
  /// In en, this message translates to:
  /// **'Certificates'**
  String get serviceGovtActionCertificates;

  /// No description provided for @serviceGovtActionLandRecords.
  ///
  /// In en, this message translates to:
  /// **'Land Records'**
  String get serviceGovtActionLandRecords;

  /// No description provided for @serviceGovtActionMyDocs.
  ///
  /// In en, this message translates to:
  /// **'My Docs'**
  String get serviceGovtActionMyDocs;

  /// No description provided for @serviceGovtHealthInsurance.
  ///
  /// In en, this message translates to:
  /// **'Health Insurance'**
  String get serviceGovtHealthInsurance;

  /// No description provided for @serviceGovtBirthCertificate.
  ///
  /// In en, this message translates to:
  /// **'Birth Certificate'**
  String get serviceGovtBirthCertificate;

  /// No description provided for @serviceGovtDeathCertificate.
  ///
  /// In en, this message translates to:
  /// **'Death Certificate'**
  String get serviceGovtDeathCertificate;

  /// No description provided for @serviceGovtFitness.
  ///
  /// In en, this message translates to:
  /// **'Physical Fitness'**
  String get serviceGovtFitness;

  /// No description provided for @serviceGovtScholarships.
  ///
  /// In en, this message translates to:
  /// **'Scholarships'**
  String get serviceGovtScholarships;

  /// No description provided for @serviceGovtAdmissions.
  ///
  /// In en, this message translates to:
  /// **'School Admissions'**
  String get serviceGovtAdmissions;

  /// No description provided for @serviceGovtSkillCertificates.
  ///
  /// In en, this message translates to:
  /// **'Skill Certificates'**
  String get serviceGovtSkillCertificates;

  /// No description provided for @serviceGovtDigitalLibrary.
  ///
  /// In en, this message translates to:
  /// **'Digital Library'**
  String get serviceGovtDigitalLibrary;

  /// No description provided for @serviceGovtPropertyTax.
  ///
  /// In en, this message translates to:
  /// **'Property Tax'**
  String get serviceGovtPropertyTax;

  /// No description provided for @serviceGovtEncumbrance.
  ///
  /// In en, this message translates to:
  /// **'Encumbrance'**
  String get serviceGovtEncumbrance;

  /// No description provided for @serviceGovtSurveyMutation.
  ///
  /// In en, this message translates to:
  /// **'Survey & Mutation'**
  String get serviceGovtSurveyMutation;

  /// No description provided for @serviceGovtAadhaar.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Services'**
  String get serviceGovtAadhaar;

  /// No description provided for @serviceGovtVoterId.
  ///
  /// In en, this message translates to:
  /// **'Voter ID'**
  String get serviceGovtVoterId;

  /// No description provided for @serviceGovtPension.
  ///
  /// In en, this message translates to:
  /// **'Pension Services'**
  String get serviceGovtPension;

  /// No description provided for @serviceGovtRti.
  ///
  /// In en, this message translates to:
  /// **'RTI Applications'**
  String get serviceGovtRti;

  /// Label for related updates section in govt services
  ///
  /// In en, this message translates to:
  /// **'RELATED UPDATES'**
  String get serviceGovtRelatedUpdates;

  /// Generic 'View Details' action label used in services
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get serviceActionViewDetails;

  /// No description provided for @serviceMarketplaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get serviceMarketplaceTitle;

  /// No description provided for @serviceMarketplaceSalesToday.
  ///
  /// In en, this message translates to:
  /// **'Sales Today'**
  String get serviceMarketplaceSalesToday;

  /// No description provided for @serviceMarketplaceOrdersPending.
  ///
  /// In en, this message translates to:
  /// **'{count} Orders Pending'**
  String serviceMarketplaceOrdersPending(Object count);

  /// No description provided for @serviceMarketplaceActionListItem.
  ///
  /// In en, this message translates to:
  /// **'List Item'**
  String get serviceMarketplaceActionListItem;

  /// No description provided for @serviceMarketplaceActionOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get serviceMarketplaceActionOrders;

  /// No description provided for @serviceMarketplaceActionLogistics.
  ///
  /// In en, this message translates to:
  /// **'Logistics'**
  String get serviceMarketplaceActionLogistics;

  /// No description provided for @serviceMarketplaceActionMyStore.
  ///
  /// In en, this message translates to:
  /// **'My Store'**
  String get serviceMarketplaceActionMyStore;

  /// No description provided for @serviceMarketplaceSectionServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get serviceMarketplaceSectionServices;

  /// No description provided for @serviceMarketplaceCatalog.
  ///
  /// In en, this message translates to:
  /// **'Product Catalog'**
  String get serviceMarketplaceCatalog;

  /// No description provided for @serviceMarketplaceReviews.
  ///
  /// In en, this message translates to:
  /// **'Customer Reviews'**
  String get serviceMarketplaceReviews;

  /// No description provided for @serviceMarketplaceSupport.
  ///
  /// In en, this message translates to:
  /// **'Seller Support'**
  String get serviceMarketplaceSupport;

  /// No description provided for @serviceMarketplaceAiDemandForecast.
  ///
  /// In en, this message translates to:
  /// **'Demand Forecast'**
  String get serviceMarketplaceAiDemandForecast;

  /// No description provided for @serviceMarketplaceAiDemandForecastDesc.
  ///
  /// In en, this message translates to:
  /// **'Stock up on \"Organic Rice\". High demand expected this weekend.'**
  String get serviceMarketplaceAiDemandForecastDesc;

  /// No description provided for @serviceLogisticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Logistics'**
  String get serviceLogisticsTitle;

  /// No description provided for @serviceLogisticsActiveShipments.
  ///
  /// In en, this message translates to:
  /// **'Active Shipments'**
  String get serviceLogisticsActiveShipments;

  /// No description provided for @serviceLogisticsDeliveryAlert.
  ///
  /// In en, this message translates to:
  /// **'Next delivery expected by {time} today'**
  String serviceLogisticsDeliveryAlert(Object time);

  /// No description provided for @serviceLogisticsActionTrackAll.
  ///
  /// In en, this message translates to:
  /// **'Track All Shipments'**
  String get serviceLogisticsActionTrackAll;

  /// No description provided for @serviceLogisticsActionBookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get serviceLogisticsActionBookNow;

  /// No description provided for @serviceLogisticsActionTrack.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get serviceLogisticsActionTrack;

  /// No description provided for @serviceLogisticsActionCalcFare.
  ///
  /// In en, this message translates to:
  /// **'Calc Fare'**
  String get serviceLogisticsActionCalcFare;

  /// No description provided for @serviceLogisticsActionMyOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get serviceLogisticsActionMyOrders;

  /// No description provided for @serviceLogisticsSectionServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get serviceLogisticsSectionServices;

  /// No description provided for @serviceLogisticsWarehousing.
  ///
  /// In en, this message translates to:
  /// **'Warehousing Services'**
  String get serviceLogisticsWarehousing;

  /// No description provided for @serviceLogisticsFleet.
  ///
  /// In en, this message translates to:
  /// **'Fleet Management'**
  String get serviceLogisticsFleet;

  /// No description provided for @serviceLogisticsPastShipments.
  ///
  /// In en, this message translates to:
  /// **'Past Shipments'**
  String get serviceLogisticsPastShipments;

  /// No description provided for @serviceLogisticsAiRouteOptimization.
  ///
  /// In en, this message translates to:
  /// **'Route Optimization'**
  String get serviceLogisticsAiRouteOptimization;

  /// No description provided for @serviceLogisticsAiRouteOptimizationDesc.
  ///
  /// In en, this message translates to:
  /// **'Save 20 mins on the Trip #{tripId} via {highway}.'**
  String serviceLogisticsAiRouteOptimizationDesc(Object highway, Object tripId);

  /// No description provided for @serviceSportTitle.
  ///
  /// In en, this message translates to:
  /// **'Sporting & Mental Health'**
  String get serviceSportTitle;

  /// No description provided for @serviceSportActiveStreak.
  ///
  /// In en, this message translates to:
  /// **'Active Streak'**
  String get serviceSportActiveStreak;

  /// No description provided for @serviceSportDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get serviceSportDays;

  /// No description provided for @serviceSportStreakMotivation.
  ///
  /// In en, this message translates to:
  /// **'Keep it up! Physical health boosts mental wealth.'**
  String get serviceSportStreakMotivation;

  /// No description provided for @serviceSportActionWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get serviceSportActionWorkouts;

  /// No description provided for @serviceSportActionEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get serviceSportActionEvents;

  /// No description provided for @serviceSportActionCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get serviceSportActionCommunity;

  /// No description provided for @serviceSportActionBook.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get serviceSportActionBook;

  /// No description provided for @serviceSportSectionServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get serviceSportSectionServices;

  /// No description provided for @serviceSportFacilities.
  ///
  /// In en, this message translates to:
  /// **'Local Sports Facilities'**
  String get serviceSportFacilities;

  /// No description provided for @serviceSportWellnessGuides.
  ///
  /// In en, this message translates to:
  /// **'Mental Wellness Guides'**
  String get serviceSportWellnessGuides;

  /// No description provided for @serviceSportMeditation.
  ///
  /// In en, this message translates to:
  /// **'Meditation Zone'**
  String get serviceSportMeditation;

  /// No description provided for @serviceSportAiWellnessTip.
  ///
  /// In en, this message translates to:
  /// **'Wellness Tip'**
  String get serviceSportAiWellnessTip;

  /// No description provided for @serviceSportAiWellnessTipDesc.
  ///
  /// In en, this message translates to:
  /// **'Try a 10-minute walk after lunch to improve digestion and focus.'**
  String get serviceSportAiWellnessTipDesc;

  /// No description provided for @labelAiAssistants.
  ///
  /// In en, this message translates to:
  /// **'AI Assistants'**
  String get labelAiAssistants;

  /// No description provided for @labelActionView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get labelActionView;

  /// No description provided for @serviceCommonTitle.
  ///
  /// In en, this message translates to:
  /// **'Common Svcs'**
  String get serviceCommonTitle;

  /// No description provided for @serviceAgriTitle.
  ///
  /// In en, this message translates to:
  /// **'Agri Services'**
  String get serviceAgriTitle;

  /// No description provided for @serviceSmeTitle.
  ///
  /// In en, this message translates to:
  /// **'SME Services'**
  String get serviceSmeTitle;

  /// No description provided for @loansMarketplaceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get loansMarketplaceSubtitle;

  /// No description provided for @loansFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All Offers'**
  String get loansFilterAll;

  /// No description provided for @loansFilterLowestRate.
  ///
  /// In en, this message translates to:
  /// **'Lowest Rate'**
  String get loansFilterLowestRate;

  /// No description provided for @loansFilterFastest.
  ///
  /// In en, this message translates to:
  /// **'Fastest Approval'**
  String get loansFilterFastest;

  /// No description provided for @loansPreApproved.
  ///
  /// In en, this message translates to:
  /// **'Pre-Approved'**
  String get loansPreApproved;

  /// No description provided for @loansLabelFee.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get loansLabelFee;

  /// No description provided for @loansInterestRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Interest Rate'**
  String get loansInterestRateLabel;

  /// No description provided for @loansActionCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get loansActionCompare;

  /// No description provided for @loansActionSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get loansActionSelected;

  /// No description provided for @loansCompareBanksSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} banks selected'**
  String loansCompareBanksSelected(int count);

  /// No description provided for @loansCompareOffersTitle.
  ///
  /// In en, this message translates to:
  /// **'Compare Offers'**
  String get loansCompareOffersTitle;

  /// No description provided for @loansActionViewComparison.
  ///
  /// In en, this message translates to:
  /// **'View Comparison'**
  String get loansActionViewComparison;

  /// No description provided for @loansComparePlansTitle.
  ///
  /// In en, this message translates to:
  /// **'Compare Plans'**
  String get loansComparePlansTitle;

  /// No description provided for @loansCompareInterestRate.
  ///
  /// In en, this message translates to:
  /// **'INTEREST RATE (ROI)'**
  String get loansCompareInterestRate;

  /// No description provided for @loansCompareProcessingFee.
  ///
  /// In en, this message translates to:
  /// **'PROCESSING FEE'**
  String get loansCompareProcessingFee;

  /// No description provided for @loansCompareMaxAmount.
  ///
  /// In en, this message translates to:
  /// **'MAX AMOUNT'**
  String get loansCompareMaxAmount;

  /// No description provided for @loansCompareFeatures.
  ///
  /// In en, this message translates to:
  /// **'FEATURES'**
  String get loansCompareFeatures;

  /// No description provided for @loansBestRate.
  ///
  /// In en, this message translates to:
  /// **'Best Rate'**
  String get loansBestRate;

  /// No description provided for @loansPerAnnum.
  ///
  /// In en, this message translates to:
  /// **'per annum'**
  String get loansPerAnnum;

  /// No description provided for @loansCheckEligibilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Check Eligibility'**
  String get loansCheckEligibilityTitle;

  /// No description provided for @loansEligibilityHeadline.
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself'**
  String get loansEligibilityHeadline;

  /// No description provided for @loansEligibilitySubheadline.
  ///
  /// In en, this message translates to:
  /// **'We\'ll find the best loan offers for your profile.'**
  String get loansEligibilitySubheadline;

  /// No description provided for @loansLabelMonthlyIncome.
  ///
  /// In en, this message translates to:
  /// **'Monthly Income'**
  String get loansLabelMonthlyIncome;

  /// No description provided for @loansLabelEmploymentType.
  ///
  /// In en, this message translates to:
  /// **'Employment Type'**
  String get loansLabelEmploymentType;

  /// No description provided for @loansLabelCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get loansLabelCity;

  /// No description provided for @loansLabelPan.
  ///
  /// In en, this message translates to:
  /// **'ID Number (Optional)'**
  String get loansLabelPan;

  /// No description provided for @loansActionCheckOffers.
  ///
  /// In en, this message translates to:
  /// **'Check Offers'**
  String get loansActionCheckOffers;

  /// No description provided for @loansAiAnalysisTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Analysis'**
  String get loansAiAnalysisTitle;

  /// No description provided for @loansAiBestMatch.
  ///
  /// In en, this message translates to:
  /// **'Best Match Found'**
  String get loansAiBestMatch;

  /// No description provided for @loansAiBestMatchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Highest approval chance for your profile'**
  String get loansAiBestMatchSubtitle;

  /// No description provided for @loansActionProceedWithOffer.
  ///
  /// In en, this message translates to:
  /// **'Proceed with this Offer'**
  String get loansActionProceedWithOffer;

  /// No description provided for @loansCompareWithOthers.
  ///
  /// In en, this message translates to:
  /// **'Or compare with others'**
  String get loansCompareWithOthers;

  /// No description provided for @loansActionViewComparisonTable.
  ///
  /// In en, this message translates to:
  /// **'View Comparison Table'**
  String get loansActionViewComparisonTable;

  /// No description provided for @loansCompareTitle.
  ///
  /// In en, this message translates to:
  /// **'Compare Loans'**
  String get loansCompareTitle;

  /// No description provided for @loansApplicationTitle.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get loansApplicationTitle;

  /// No description provided for @loansStepPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get loansStepPersonal;

  /// No description provided for @loansStepKyc.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get loansStepKyc;

  /// No description provided for @loansStepReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get loansStepReview;

  /// No description provided for @loansSubmittedTitle.
  ///
  /// In en, this message translates to:
  /// **'Application Submitted!'**
  String get loansSubmittedTitle;

  /// No description provided for @loansSubmittedDescription.
  ///
  /// In en, this message translates to:
  /// **'Your application ID is #CO-88291. We will update you shortly.'**
  String get loansSubmittedDescription;

  /// No description provided for @loansActionBackToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get loansActionBackToHome;

  /// No description provided for @loansStepIndicator.
  ///
  /// In en, this message translates to:
  /// **'STEP {step} OF {total}'**
  String loansStepIndicator(int step, int total);

  /// No description provided for @loansExistingCustomerQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you an existing customer of {bankName}?'**
  String loansExistingCustomerQuestion(String bankName);

  /// No description provided for @loansExistingCustomerYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, I have an account'**
  String get loansExistingCustomerYes;

  /// No description provided for @loansExistingCustomerYesDesc.
  ///
  /// In en, this message translates to:
  /// **'Faster approval. We\'ll pre-fill your details from KYC records.'**
  String get loansExistingCustomerYesDesc;

  /// No description provided for @loansExistingCustomerNo.
  ///
  /// In en, this message translates to:
  /// **'No, I am a new customer'**
  String get loansExistingCustomerNo;

  /// No description provided for @loansExistingCustomerNoDesc.
  ///
  /// In en, this message translates to:
  /// **'We\'ll need a few more details to set up your profile.'**
  String get loansExistingCustomerNoDesc;

  /// No description provided for @loansLabelNrc.
  ///
  /// In en, this message translates to:
  /// **'NRC / ID Number'**
  String get loansLabelNrc;

  /// No description provided for @loansLabelEmploymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Employment Status'**
  String get loansLabelEmploymentStatus;

  /// No description provided for @loansEmploymentFullTime.
  ///
  /// In en, this message translates to:
  /// **'Full Time Employed'**
  String get loansEmploymentFullTime;

  /// No description provided for @loansEmploymentPartTime.
  ///
  /// In en, this message translates to:
  /// **'Part Time Employed'**
  String get loansEmploymentPartTime;

  /// No description provided for @loansEmploymentSelfEmployed.
  ///
  /// In en, this message translates to:
  /// **'Self Employed / Business'**
  String get loansEmploymentSelfEmployed;

  /// No description provided for @loansEmploymentRetired.
  ///
  /// In en, this message translates to:
  /// **'Retired'**
  String get loansEmploymentRetired;

  /// No description provided for @loansFormInfoNote.
  ///
  /// In en, this message translates to:
  /// **'Please ensure all details match your official documents. This helps in faster processing.'**
  String get loansFormInfoNote;

  /// No description provided for @loansDocInfoNote.
  ///
  /// In en, this message translates to:
  /// **'Since you selected {bankName}, we can fetch your bank statement automatically if you provide consent.'**
  String loansDocInfoNote(String bankName);

  /// No description provided for @loansUploadPayslip.
  ///
  /// In en, this message translates to:
  /// **'Upload Payslip / Proof of Income'**
  String get loansUploadPayslip;

  /// No description provided for @loansUploadPayslipSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Latest 3 months • PDF or JPG'**
  String get loansUploadPayslipSubtitle;

  /// No description provided for @loansUploadNrc.
  ///
  /// In en, this message translates to:
  /// **'Upload NRC Copy'**
  String get loansUploadNrc;

  /// No description provided for @loansUploadNrcSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Front and Back • PDF or JPG'**
  String get loansUploadNrcSubtitle;

  /// No description provided for @loansApplicantDetails.
  ///
  /// In en, this message translates to:
  /// **'Applicant Details'**
  String get loansApplicantDetails;

  /// No description provided for @loansActionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get loansActionEdit;

  /// No description provided for @loansLabelNrcNumber.
  ///
  /// In en, this message translates to:
  /// **'NRC Number'**
  String get loansLabelNrcNumber;

  /// No description provided for @loansLabelEmployment.
  ///
  /// In en, this message translates to:
  /// **'Employment'**
  String get loansLabelEmployment;

  /// No description provided for @loansLabelDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get loansLabelDocuments;

  /// No description provided for @loansDocsUploaded.
  ///
  /// In en, this message translates to:
  /// **'{count} Uploaded'**
  String loansDocsUploaded(int count);

  /// No description provided for @loansTermsConfirmation.
  ///
  /// In en, this message translates to:
  /// **'I confirm the details provided are accurate and authorize {bankName} to access my credit report for processing this application. I agree to the'**
  String loansTermsConfirmation(String bankName);

  /// No description provided for @loansTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get loansTermsOfService;

  /// No description provided for @loansSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Application Submitted!'**
  String get loansSuccessTitle;

  /// No description provided for @loansSuccessDescription.
  ///
  /// In en, this message translates to:
  /// **'Your application for {loanType} with {bankName} has been submitted successfully.'**
  String loansSuccessDescription(String loanType, String bankName);

  /// No description provided for @loansReferenceIdLabel.
  ///
  /// In en, this message translates to:
  /// **'REFERENCE ID'**
  String get loansReferenceIdLabel;

  /// No description provided for @loansActionBackToLoansHub.
  ///
  /// In en, this message translates to:
  /// **'Back to Loans Hub'**
  String get loansActionBackToLoansHub;

  /// No description provided for @loansActionTrackStatus.
  ///
  /// In en, this message translates to:
  /// **'Track Status'**
  String get loansActionTrackStatus;

  /// No description provided for @loansActionBackToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Back to Dashboard'**
  String get loansActionBackToDashboard;

  /// No description provided for @loansActionSubmitApplication.
  ///
  /// In en, this message translates to:
  /// **'Submit Application'**
  String get loansActionSubmitApplication;

  /// No description provided for @loansActionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get loansActionContinue;

  /// No description provided for @loansLabelTenureYears.
  ///
  /// In en, this message translates to:
  /// **'Tenure (Years)'**
  String get loansLabelTenureYears;

  /// No description provided for @genericServiceGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get genericServiceGetStarted;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bem', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bem':
      return AppLocalizationsBem();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
