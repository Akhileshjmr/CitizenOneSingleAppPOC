import 'package:flutter/material.dart';
import 'package:citizenone_app/l10n/app_localizations.dart';

/// Convenience extension on [BuildContext] for accessing [AppLocalizations].
///
/// Usage:
/// ```dart
/// Text(context.l10n.navHome)
/// ```
///
/// This extension follows ISP — it adds only the accessor that is universally
/// needed and nothing more. Individual features do not need to import the
/// full AppLocalizations class path.
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension AppLocalizationsTranslateX on AppLocalizations {
  String translate(String key) {
    switch (key) {
      case 'serviceWealthTitle': return serviceWealthTitle;
      case 'serviceHealthTitle': return serviceHealthTitle;
      case 'serviceSportTitle': return serviceSportTitle;
      case 'serviceBillPayTitle': return serviceBillPayTitle;
      case 'serviceInsuranceTitle': return serviceInsuranceTitle;
      case 'serviceGovtTitle': return serviceGovtTitle;
      case 'serviceCommonTitle': return serviceCommonTitle;
      case 'serviceBankingTitle': return serviceBankingTitle;
      case 'serviceMobileTitle': return serviceMobileTitle;
      case 'serviceMarketplaceTitle': return serviceMarketplaceTitle;
      case 'serviceAgriTitle': return serviceAgriTitle;
      case 'serviceLogisticsTitle': return serviceLogisticsTitle;
      case 'serviceSmeTitle': return serviceSmeTitle;
      default: return key;
    }
  }
}
