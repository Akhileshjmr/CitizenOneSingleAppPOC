import 'dart:convert';

import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../theme/colors/Appcolors.dart';
import '../../Dashboard/widgets/account_desktop_shell.dart';

/// Cached across the whole KYC desktop flow so every [KycDesktopScaffold]
/// (one per screen) shares a single SharedPreferences read instead of
/// re-fetching/re-decoding on every rebuild or screen transition.
Future<LoginUserReqResInfo?>? _cachedLoginResponseFuture;

Future<LoginUserReqResInfo?> _loadLoginResponse() {
  return _cachedLoginResponseFuture ??= () async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('loginResponse');
      if (raw == null) return null;
      return LoginUserReqResInfo.fromJson(jsonDecode(raw));
    } catch (_) {
      return null;
    }
  }();
}

/// Desktop chrome shared by every KYC screen — wraps the same
/// [AccountDesktopScaffold] sidebar shell used by Select Partner/Profile/
/// Security, without requiring any KYC screen to take a `loginResponse`
/// constructor param (KYC screens are pushed with no args throughout the
/// existing navigation graph, and that must stay unchanged). The logged-in
/// user is instead read from `SharedPreferences` purely for sidebar chrome;
/// if that data isn't available yet the content still renders, just without
/// the sidebar (same look as the tablet layout), so the KYC flow never
/// blocks on this.
class KycDesktopScaffold extends StatelessWidget {
  final String pageTitle;
  final String? pageSubtitle;
  final Widget child;
  final double maxContentWidth;
  final bool showBackButton;
  final bool scrollable;
  final VoidCallback? onBack;

  const KycDesktopScaffold({
    super.key,
    required this.pageTitle,
    required this.child,
    this.pageSubtitle,
    this.maxContentWidth = 815,
    this.showBackButton = true,
    this.scrollable = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LoginUserReqResInfo?>(
      future: _loadLoginResponse(),
      builder: (context, snapshot) {
        final login = snapshot.data;
        if (snapshot.connectionState != ConnectionState.done ||
            login == null) {
          return _FallbackScaffold(
            pageTitle: pageTitle,
            maxContentWidth: maxContentWidth,
            showBackButton: showBackButton,
            scrollable: scrollable,
            onBack: onBack,
            child: child,
          );
        }
        return AccountDesktopScaffold(
          loginResponse: login,
          activeItem: AccountNavItem.kyc,
          pageTitle: pageTitle,
          pageSubtitle: pageSubtitle,
          maxContentWidth: maxContentWidth,
          onBack: onBack,
          showBackButton: showBackButton,
          scrollable: scrollable,
          child: child,
        );
      },
    );
  }
}

/// Sidebar-less fallback used when the cached login response isn't
/// available — same "light canvas + centered card" language as the tablet
/// layout, capped at the same max width the desktop card would have used
/// (clamped to 600, matching `Responsive.contentMaxWidth`'s web value) so it
/// never reads as an oversized tablet card on a desktop-sized viewport.
class _FallbackScaffold extends StatelessWidget {
  final String pageTitle;
  final double maxContentWidth;
  final bool showBackButton;
  final bool scrollable;
  final VoidCallback? onBack;
  final Widget child;

  const _FallbackScaffold({
    required this.pageTitle,
    required this.maxContentWidth,
    required this.showBackButton,
    required this.scrollable,
    required this.onBack,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final body = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth.clamp(0, 600)),
        child: child,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        automaticallyImplyLeading: showBackButton,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: onBack ?? () => Navigator.maybePop(context),
              )
            : null,
        title: Text(
          pageTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.k0F0F0F,
          ),
        ),
      ),
      body: scrollable
          ? SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 28,
              ),
              child: body,
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 28,
              ),
              child: body,
            ),
    );
  }
}
