import 'package:citizenone_app/design_system/models/quick_action_item.dart';
import 'package:citizenone_app/design_system/organisms/quick_actions_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/theme/tokens/dimensions.dart';
import 'package:citizenone_app/components/shared/section_header.dart';
import 'package:citizenone_app/features/auth/presentation/state/auth_cubit.dart';
import 'package:citizenone_app/features/customer/dashboard/presentation/state/services_cubit.dart';
import 'package:citizenone_app/core/theme/theme_cubit.dart';
import 'package:citizenone_app/features/customer/dashboard/presentation/widgets/hero_card.dart';
import 'package:citizenone_app/features/customer/dashboard/presentation/widgets/quick_actions.dart';
import 'package:citizenone_app/features/customer/dashboard/presentation/widgets/recent_activity.dart';
import 'package:citizenone_app/features/customer/dashboard/presentation/screens/partner_selection_screen.dart';
import 'package:citizenone_app/features/customer/dashboard/presentation/widgets/agent_task_alert.dart';
import 'package:citizenone_app/features/customer/dashboard/presentation/widgets/agent_insights.dart';
import 'package:citizenone_app/features/customer/dashboard/presentation/widgets/customer_insights.dart';
import 'package:citizenone_app/features/customer/dashboard/presentation/widgets/bank_partner_card.dart';
import 'package:citizenone_app/features/customer/dashboard/presentation/widgets/partner_services_grid.dart';
import 'package:citizenone_app/features/customer/dashboard/presentation/widgets/insurance_services_grid.dart';
import 'package:citizenone_app/features/customer/dashboard/presentation/widgets/mno_services_grid.dart';
import 'package:citizenone_app/features/auth/domain/entities/user_role.dart';
import 'package:citizenone_app/components/foundation/responsive.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';

class SuperHomeScreen extends StatefulWidget {
  const SuperHomeScreen({super.key});

  @override
  State<SuperHomeScreen> createState() => _SuperHomeScreenState();
}

class _SuperHomeScreenState extends State<SuperHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final authState = context.read<AuthCubit>().state;
      final role = authState.selectedRole;

      // 1. Load services
      context.read<ServicesCubit>().loadServices(role);

      // 2. Reset theme to Role Theme (Fixes theme persistence on Web/Tablet)
      context.read<ThemeCubit>().setRoleTheme(role.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final role = authState.selectedRole;
    final workContext = authState.workContext;
    final servicesState = context.watch<ServicesCubit>().state;
    final services = servicesState.services;

    double horizontalPadding = ResponsiveLayout.isDesktop(context) ? 64 : 20;

    if (workContext == 'Partner' && authState.selectedPartner == null) {
      return const PartnerSelectionScreen();
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
                    if (role == UserRole.agent &&
                        authState.selectedPartner != null &&
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
                      HeroCard(role: role),
                    ],
                    if (role == UserRole.agent &&
                        authState.selectedPartner == null) ...[
                      const SizedBox(height: 16),
                      const AgentTaskAlert(),
                    ],
                  ],
                ),
              ),
            ),

            // 2. Quick Actions
            SliverToBoxAdapter(
              child: SizedBox(
                height: ResponsiveLayout.isDesktop(context)
                    ? 40
                    : AppDimensions.paddingXl,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: context.l10n.dashboardSectionQuickActions,
                    ),
                    QuickActions(role: role),
                  ],
                ),
              ),
            ),

            if (role == UserRole.agent &&
                authState.selectedPartner != null &&
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

            if (workContext != 'Partner') ...[
              SliverToBoxAdapter(
                child: SizedBox(
                  height: ResponsiveLayout.isDesktop(context)
                      ? 48
                      : AppDimensions.paddingXl,
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 28)),

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
                    final color = service.color;
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
                          // colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
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
              SliverToBoxAdapter(child: SizedBox(height: 28)),
              if (role != UserRole.agent) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: const CustomerInsights(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: ResponsiveLayout.isDesktop(context)
                        ? 32
                        : AppDimensions.paddingMd,
                  ),
                ),
              ],
            ],

            if (role == UserRole.agent) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: const AgentInsights(),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: ResponsiveLayout.isDesktop(context)
                      ? 32
                      : AppDimensions.sectionVerticalSpacing,
                ),
              ),
            ],

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
