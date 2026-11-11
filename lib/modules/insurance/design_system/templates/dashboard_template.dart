// =============================================================================
// DashboardTemplate  —  TEMPLATE
// -----------------------------------------------------------------------------
// Templates fix the *layout* (slots) but contain no data. A page (in the
// feature layer) wires real data into a template's slots. This separation
// lets us build other dashboards (admin, business banking) re-using the
// same template by feeding different organisms.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/extensions/build_context_x.dart';
import '../../core/theme/app_spacing.dart';

class DashboardTemplate extends StatelessWidget {
  const DashboardTemplate({
    super.key,
    required this.header,
    required this.summary,
    required this.quickActions,
    required this.transactions,
    required this.notifications,
    required this.bottomNavigation,
    this.onRefresh,
  });

  final Widget header;
  final Widget summary;
  final Widget quickActions;
  final Widget transactions;
  final Widget notifications;
  final Widget bottomNavigation;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final maxWidth = context.layout.maxContentWidth;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: context.colors.primary,
          onRefresh: onRefresh ?? () async {},
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      header,
                      const SizedBox(height: AppSpacing.xl),
                      summary,
                      const SizedBox(height: AppSpacing.xl),
                      quickActions,
                      const SizedBox(height: AppSpacing.xl),
                      transactions,
                      const SizedBox(height: AppSpacing.xl),
                      notifications,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigation,
    );
  }
}
