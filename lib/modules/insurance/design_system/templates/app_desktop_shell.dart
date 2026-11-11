// =============================================================================
// AppDesktopShell  —  TEMPLATE (desktop-only)
// -----------------------------------------------------------------------------
// Combines AppSidebar + AppDesktopHeader around a route's content. Used by
// the outer ShellRoute in core/router/app_router.dart, which renders this
// only when `!context.isMobile` — on mobile the ShellRoute is a pure
// pass-through and this widget is never built.
//
// AppRoutes.transactionProcessingPage is the one exception: it swaps the
// normal sidebar + header for TransactionProcessingDesktopHeader with no
// sidebar at all (see that widget for why), rather than disabling the
// normal chrome in place. Every other route keeps the normal shell exactly
// as before.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/constants/routes_constants.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/organisms/app_desktop_header.dart';
import 'package:citizenone_app/modules/insurance/design_system/organisms/app_sidebar.dart';
import 'package:citizenone_app/modules/insurance/design_system/organisms/transaction_processing_desktop_header.dart';

class AppDesktopShell extends StatelessWidget {
  const AppDesktopShell({
    super.key,
    required this.currentPath,
    required this.child,
  });

  final String currentPath;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isTransactionProcessing =
        currentPath == AppRoutes.transactionProcessingPage;
    final isPolicyKeyFactSuccess =
        currentPath == AppRoutes.keyFactsSmsSuccessPage;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: (isTransactionProcessing || isPolicyKeyFactSuccess)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TransactionProcessingDesktopHeader(),
                  Expanded(child: child),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppSidebar(currentPath: currentPath),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AppDesktopHeader(),
                        Expanded(child: child),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
