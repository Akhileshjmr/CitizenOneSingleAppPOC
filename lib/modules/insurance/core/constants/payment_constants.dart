// =============================================================================
// PaymentConstants  —  Payment-related constants
// =============================================================================

class PaymentConstants {
  PaymentConstants._();

  // Mobile Money Gateways
  static const String gatewayAirtel = 'AIRTEL';
  static const String gatewayMtn = 'MTN';
  static const String gatewayZamtel = 'ZAMTEL';

  // Payment Actions
  static const String actionCollect = 'collect';

  // Environments
  static const String environmentProd = 'PROD';
  static const String environmentUat = 'UAT';

  // Default Payment Narration
  static const String defaultNarration = 'Payment Test';

  // Payment Statuses
  static const String statusSuccessful = 'SUCCESSFUL';
  static const String statusAccepted = 'ACCEPTED';

  // Mobile Provider Display Names
  static const String providerAirtel = 'Airtel';
  static const String providerMtn = 'MTN';
  static const String providerZamtel = 'Zamtel';

  // Mapping from display name to gateway value
  static String mapProviderToGateway(String provider) {
    switch (provider) {
      case providerAirtel:
        return gatewayAirtel;
      case providerMtn:
        return gatewayMtn;
      case providerZamtel:
        return gatewayZamtel;
      default:
        return gatewayAirtel;
    }
  }
}
