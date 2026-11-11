// =============================================================================
// AppConstants  —  Application-wide invariants
// -----------------------------------------------------------------------------
// Anything that's truly global: API base URLs, asset paths, timeouts, regex
// validators, currency defaults. Keep these here so they're discoverable.
// =============================================================================

class AppConstants {
  AppConstants._();

  static const String appName = 'CitizenOne';
  static const String defaultCurrency = 'USD';
  static const String defaultLocale = 'en_US';
  static const String packageName = 'poc_atomic_molecule';

  // POC: pretend we have an API. The mocked datasource ignores this string.
  static const String apiBaseUrl = 'https://api.bank.example/v1';
  static const Duration networkTimeout = Duration(seconds: 30);

  // ---- Validation ------------------------------------------------------
  static final RegExp emailRegex =
      RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
  static const int minPasswordLength = 8;

  // ---- Animation -------------------------------------------------------
  static const Duration shortAnimation = Duration(milliseconds: 180);
  static const Duration mediumAnimation = Duration(milliseconds: 300);

  // Secure storage Keys

  static const String vendorCode = 'insuranceVendorCode';
  static const String agentCode = 'insuranceAgentCode';
  static const String agentMobNo = 'insuranceAgentMobNo';
  static const String vendorKey = 'insuranceVendorKey';
  static const String vendorMob = 'insuranceVendorMob';
  static const String vendorLogo = 'insuranceVendorLogo';
}
