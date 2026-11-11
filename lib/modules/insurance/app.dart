// =============================================================================
// app.dart  —  Top-level MaterialApp + theme/brand orchestration
// -----------------------------------------------------------------------------
// Holds runtime UI preferences (theme mode + active brand) in
// ValueNotifiers so the design system can react to flips without us
// reaching for a heavier state-management tool. AppShell.of(context) gives
// any descendant page (e.g. Profile) a typed handle to those notifiers.
// =============================================================================

import 'package:flutter/material.dart';

import 'core/navigation/app_navigation.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';

class App extends StatefulWidget {
  const App({super.key, this.onExit, this.onSignOut});

  /// Invoked when the module is at its own root and back navigation (system
  /// back, iOS gesture, AppBar/header actions) should hand control back to
  /// whatever hosts this module. The host app supplies this at the exact
  /// call site that pushed this module (see `InsuranceModuleEntry.start`),
  /// e.g. `onExit: () => Navigator.of(routeContext).pop()` — which is always
  /// correct regardless of how deep that host's own navigation stack is,
  /// unlike guessing a Navigator from inside this widget's own subtree.
  /// Falls back to [AppNavigation.exitToParent] when not supplied (e.g. this
  /// module run standalone via `main.dart`).
  final VoidCallback? onExit;

  /// Invoked when the user taps "Sign Out" in the sidebar. This module owns
  /// no session/login of its own — the host app supplies this at the exact
  /// call site that pushed this module (see `InsuranceModuleEntry.start`) to
  /// run its own sign-out flow (clear session, call its logout API, navigate
  /// to its login screen), mirroring [onExit]. Falls back to
  /// [AppNavigation.exitToParent] when not supplied (e.g. this module run
  /// standalone via `main.dart`).
  final VoidCallback? onSignOut;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  /// Light/Dark/System
  final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.system);

  /// White-label brand toggle. False = default (BankAlpha), true = BankBeta.
  /// In a real app this would be set at build time, not at runtime — but
  /// exposing it here makes the white-label demo viscerally obvious.
  final ValueNotifier<bool> useAlternateBrand = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    appRouter.go('/');
  }

  @override
  void dispose() {
    themeMode.dispose();
    useAlternateBrand.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exitToParent =
        widget.onExit ?? () => AppNavigation.exitToParent(context);
    final signOut =
        widget.onSignOut ?? () => AppNavigation.exitToParent(context);

    return AppShell(
      themeMode: themeMode,
      useAlternateBrand: useAlternateBrand,
      onExit: exitToParent,
      onSignOut: signOut,
      child: ValueListenableBuilder<bool>(
        valueListenable: useAlternateBrand,
        builder: (context, alt, _) {
          final brand = alt ? const BankBetaBrand() : const BankAlphaBrand();
          return ValueListenableBuilder<ThemeMode>(
            valueListenable: themeMode,
            builder: (context, mode, __) => PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                if (appRouter.canPop()) {
                  appRouter.routerDelegate.navigatorKey.currentState
                      ?.maybePop();
                } else {
                  exitToParent();
                }
              },
              child: MaterialApp.router(
                title: 'CitizenOne',
                debugShowCheckedModeBanner: false,
                themeMode: mode,
                theme: AppTheme.light(brand),
                darkTheme: AppTheme.dark(brand),
                routerConfig: appRouter,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Small InheritedWidget exposing the runtime preferences to descendants.
class AppShell extends InheritedWidget {
  const AppShell({
    super.key,
    required this.themeMode,
    required this.useAlternateBrand,
    required this.onExit,
    required this.onSignOut,
    required super.child,
  });

  final ValueNotifier<ThemeMode> themeMode;
  final ValueNotifier<bool> useAlternateBrand;

  /// Shared "leave the module" action — the same one the root [PopScope] in
  /// [App] falls back to, so every exit trigger (system back, header vendor
  /// icon, Partner Selection, this module's home icon) stays in lockstep.
  final VoidCallback onExit;

  /// Shared "sign out of the host app" action — see [App.onSignOut]. Used by
  /// the sidebar's Sign Out item.
  final VoidCallback onSignOut;

  static AppShell of(BuildContext context) {
    final shell = maybeOf(context);
    assert(shell != null, 'AppShell not found in widget tree');
    return shell!;
  }

  /// Same as [of], but returns null instead of asserting when this widget is
  /// used outside the module (e.g. [InsuranceTransactionScreen] pushed
  /// directly onto a host Navigator via
  /// `InsuranceModuleEntry.openInsuranceTransactionScreen`, which never
  /// builds an [App]/[AppShell]). Callers use this to detect which of the
  /// two hosting modes they're in.
  static AppShell? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppShell>();

  /// Centralized "go back" decision for any in-module back trigger (AppBar
  /// back arrow, header icons, etc.): pop the module's own nested router if
  /// it still has somewhere to go, otherwise hand control back to the host.
  /// This mirrors the fallback branch of the root [PopScope] in [App.build]
  /// exactly, so a header/AppBar back button always ends up exactly where
  /// the system/device back button would.
  void handleBack(BuildContext context) {
    if (appRouter.canPop()) {
      appRouter.routerDelegate.navigatorKey.currentState?.maybePop();
    } else {
      onExit();
    }
  }

  @override
  bool updateShouldNotify(AppShell oldWidget) =>
      themeMode != oldWidget.themeMode ||
      useAlternateBrand != oldWidget.useAlternateBrand ||
      onExit != oldWidget.onExit ||
      onSignOut != oldWidget.onSignOut;
}
