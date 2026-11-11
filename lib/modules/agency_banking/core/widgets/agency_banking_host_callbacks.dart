import 'package:flutter/widgets.dart';

/// Exposes host-supplied navigation callbacks to the Agency Banking widget
/// tree when it is embedded inside another app (e.g. Citizen One), so the
/// module never has to reach back into host-specific navigation/auth code
/// directly. Absent (both callbacks null) when running standalone.
class AgencyBankingHostCallbacks extends InheritedWidget {
  final VoidCallback? onExit;
  final VoidCallback? onSignOut;

  const AgencyBankingHostCallbacks({
    super.key,
    required super.child,
    this.onExit,
    this.onSignOut,
  });

  static AgencyBankingHostCallbacks? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AgencyBankingHostCallbacks>();

  @override
  bool updateShouldNotify(AgencyBankingHostCallbacks oldWidget) =>
      onExit != oldWidget.onExit || onSignOut != oldWidget.onSignOut;
}
