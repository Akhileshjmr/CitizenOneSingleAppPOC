import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/di/di_setup.dart';
import 'package:citizenone_app/core/theme/tokens/dimensions.dart';
import 'package:citizenone_app/components/foundation/responsive.dart';
import 'package:citizenone_app/features/auth/presentation/state/auth_cubit.dart';
import 'package:citizenone_app/features/customer/dashboard/presentation/state/services_cubit.dart';
import 'package:citizenone_app/features/shared/dashboard/presentation/widgets/hero_card.dart';
import 'package:citizenone_app/design_system/models/quick_action_item.dart';
import 'package:citizenone_app/design_system/organisms/quick_actions_widget.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:citizenone_app/features/shared/dashboard/presentation/widgets/recent_activity.dart';
import 'package:citizenone_app/features/shared/dashboard/presentation/widgets/bank_partner_card.dart';
import 'package:citizenone_app/features/shared/dashboard/presentation/widgets/partner_services_grid.dart';
import 'package:citizenone_app/features/shared/dashboard/presentation/widgets/insurance_services_grid.dart';
import 'package:citizenone_app/features/shared/dashboard/presentation/widgets/mno_services_grid.dart';
import 'package:citizenone_app/features/agent/insurance_partners/presentation/screens/insurance_partner_selection_screen.dart';
import 'package:citizenone_app/features/auth/domain/entities/user_role.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Agent-specific imports
import 'package:citizenone_app/features/agent/dashboard/presentation/state/agent_dashboard_cubit.dart';
import 'package:citizenone_app/features/agent/dashboard/presentation/widgets/agent_task_alert_widget.dart';
import 'package:citizenone_app/features/agent/dashboard/presentation/widgets/agent_insights_widget.dart';

/// Entry point for the /agent route.
///
/// Provides [AgentDashboardCubit] from DI and composes the
/// agent dashboard layout. Uses SuperHomeScreen-style structure
/// but with agent-specific state and widgets.
class AgentDashboardScreen extends StatelessWidget {
  const AgentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AgentDashboardCubit>(
      create: (_) => sl<AgentDashboardCubit>()..loadDashboard(),
      child: const _AgentDashboardView(),
    );
  }
}

/// Internal stateful view — separated to keep [AgentDashboardScreen]
/// clean and focused on DI wiring only (SRP).
class _AgentDashboardView extends StatefulWidget {
  const _AgentDashboardView();

  @override
  State<_AgentDashboardView> createState() => _AgentDashboardViewState();
}

class _AgentDashboardViewState extends State<_AgentDashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServicesCubit>().loadServices(UserRole.agent);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final workContext = authState.workContext;
    final servicesState = context.watch<ServicesCubit>().state;
    final services = servicesState.services;

    final tokens = context.appTokens;
    final l10n = context.l10n;

    final double horizontalPadding = ResponsiveLayout.isDesktop(context)
        ? 64
        : 20;

    final List<_QuickActionConfig> quickActionConfigs = [
      _QuickActionConfig(
        title: l10n.quickActionOnboard,
        iconAsset: AppAssets.iconPersonAddAlt,
        brandColor: tokens.brandIndigo,
        onTap: () => context.push('/agent/customers'),
      ),
      _QuickActionConfig(
        title: l10n.quickActionCollect,
        iconAsset: AppAssets.iconAccountBalanceWallet,
        brandColor: tokens.brandGreen,
        onTap: () => context.push('/agent/collections'),
      ),
      _QuickActionConfig(
        title: l10n.quickActionTodayTasks,
        iconAsset: AppAssets.iconNote,
        brandColor: tokens.warning,
        onTap: () => context.push('/agent/tasks'),
      ),
      _QuickActionConfig(
        title: l10n.quickActionSupport,
        iconAsset: AppAssets.iconSupport,
        brandColor: tokens.brandIndigo,
        onTap: () {},
      ),
    ];

    // Partner context: show partner selection if no partner selected
    if (workContext == 'Partner' && authState.selectedPartner == null) {
      return const InsurancePartnerSelectionScreen();
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveLayout.isDesktop(context)
              ? 1400
              : double.infinity,
        ),
        child: CustomScrollView(
          slivers: [
            // 1. Hero / Partner Header
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    if (authState.selectedPartner != null &&
                        workContext == 'Partner') ...[
                      BankPartnerCard(
                        partnerName: authState.selectedPartner!,
                        partnerIcon:
                            authState.partnerIcon ?? LucideIcons.landmark,
                        partnerType: authState.partnerType,
                        onSwitch: () =>
                            context.read<AuthCubit>().clearPartner(),
                      ),
                    ] else ...[
                      HeroCard(role: UserRole.agent),
                    ],
                    if (authState.selectedPartner == null) ...[
                      const SizedBox(height: 16),
                      // Agent-specific task alert — driven by AgentDashboardCubit
                      const AgentTaskAlertWidget(),
                    ],
                  ],
                ),
              ),
            ),

            // 2. Quick Actions
            SliverToBoxAdapter(
              child: SizedBox(
                height: ResponsiveLayout.isDesktop(context)
                    ? 32
                    : AppDimensions.sectionVerticalSpacing,
              ),
            ),
            SliverToBoxAdapter(
              child: QuickActionsWidget(
                sectionTitle: 'Quick Actions',
                sectionPadding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                ),
                itemsPerRow: 4,
                items: quickActionConfigs.map((config) {
                  return QuickActionItem(
                    title: config.title,
                    icon: Container(
                      width: 52,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: config.brandColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: SvgPicture.asset(
                        config.iconAsset,
                        colorFilter: ColorFilter.mode(
                          config.brandColor,
                          BlendMode.srcIn,
                        ),
                        width: 24,
                        height: 24,
                      ),
                    ),
                    onTap: config.onTap,
                  );
                }).toList(),
              ),
            ),

            // 3. Partner Services Grid (Partner context only)
            if (authState.selectedPartner != null &&
                workContext == 'Partner') ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 32,
                  ),
                  child: authState.partnerType == 'Bank'
                      ? const PartnerServicesGrid()
                      : authState.partnerType == 'Insurance'
                      ? const InsuranceServicesGrid()
                      : authState.partnerType == 'MNO'
                      ? const MnoServicesGrid()
                      : const PartnerServicesGrid(),
                ),
              ),
            ],

            // 4. All Services (CitizenOne context)
            if (workContext != 'Partner') ...[
              SliverToBoxAdapter(
                child: SizedBox(
                  height: ResponsiveLayout.isDesktop(context)
                      ? 48
                      : AppDimensions.sectionVerticalSpacing,
                ),
              ),
              SliverToBoxAdapter(
                child: QuickActionsWidget(
                  sectionTitle: 'All Services',
                  viewAllText: 'View All',
                  onViewAllTap: () => context.push('/services'),
                  showContainerBackground: false,
                  sectionPadding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                  ),
                  itemsPerRow: 4,
                  items: services.map((service) {
                    final color = service.color ?? tokens.primary;
                    return QuickActionItem(
                      title: service.title,
                      icon: Container(
                        width: 52,
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1F212121),
                              offset: Offset(0, 2),
                              blurRadius: 3,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: SvgPicture.asset(
                          service.icon,
                          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                          width: 24,
                          height: 24,
                          placeholderBuilder: (_) =>
                              Icon(Icons.apps_rounded, size: 24, color: color),
                          errorBuilder: (_, __, ___) =>
                              Icon(Icons.apps_rounded, size: 24, color: color),
                        ),
                      ),
                      onTap: () {
                        if (service.route.isNotEmpty) {
                          context.push(service.route);
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: ResponsiveLayout.isDesktop(context)
                      ? 40
                      : AppDimensions.sectionVerticalSpacing,
                ),
              ),
            ],

            // 5. AI Insights — driven by AgentDashboardCubit
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: const AgentInsightsWidget(),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: ResponsiveLayout.isDesktop(context)
                    ? 32
                    : AppDimensions.sectionVerticalSpacing,
              ),
            ),

            // 6. Recent Activity
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: const RecentActivity(),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppDimensions.scrollBottomPadding),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionConfig {
  final String title;
  final String iconAsset;
  final Color brandColor;
  final VoidCallback onTap;

  const _QuickActionConfig({
    required this.title,
    required this.iconAsset,
    required this.brandColor,
    required this.onTap,
  });
}
