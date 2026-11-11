import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/core/theme/theme_cubit.dart';
import 'package:citizenone_app/features/auth/domain/entities/user_role.dart';
import 'package:citizenone_app/features/auth/presentation/state/auth_cubit.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/features/customer/services/presentation/state/services_cubit.dart'
    as hub;

class ServicesHubScreen extends StatefulWidget {
  const ServicesHubScreen({super.key});

  @override
  State<ServicesHubScreen> createState() => _ServicesHubScreenState();
}

class _ServicesHubScreenState extends State<ServicesHubScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure services are loaded when hub is first visited
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<hub.ServicesCubit>().loadServices();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return Scaffold(
      backgroundColor: tokens.background,
      body: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                context.l10n.dashboardSectionAllServices,
                style: AppTextStyle.headlineSmall,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 24),

              BlocBuilder<hub.ServicesCubit, hub.ServicesState>(
                builder: (context, state) {
                  if (state is hub.ServicesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is hub.ServicesError) {
                    return Center(
                      child: AppText(state.message, color: tokens.error),
                    );
                  }
                  if (state is hub.ServicesLoaded) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = 4;
                        if (constraints.maxWidth > 500) crossAxisCount = 6;
                        if (constraints.maxWidth > 700) crossAxisCount = 8;

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 16,
                                mainAxisExtent: 110,
                              ),
                          itemCount: state.services.length,
                          itemBuilder: (context, index) {
                            final service = state.services[index];
                            return _ServiceItem(
                              title: context.l10n.translate(service.titleKey),
                              icon: _getIcon(service.id),
                              color: _getColor(service.id),
                              serviceId: service.id,
                            );
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final String title;
  final String icon;
  final Color color;
  final String serviceId;

  const _ServiceItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.serviceId,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return GestureDetector(
      onTap: () async {
        final authCubit = context.read<AuthCubit>();
        final themeCubit = context.read<ThemeCubit>();

        themeCubit.setServiceTheme(serviceId);
        await context.push(
          _resolveServiceRoute(serviceId, authCubit.state.selectedRole),
        );

        if (context.mounted) {
          themeCubit.setRoleTheme(authCubit.state.selectedRole.name);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(child: SvgPicture.asset(icon)),
          ),
          const SizedBox(height: 8),
          AppText(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyle.caption,
            color: tokens.textPrimary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

String _resolveServiceRoute(String serviceId, UserRole role) {
  // Services with fixed canonical routes (not role-dependent)
  const fixedRoutes = {
    'loans': '/common/loans',
    'common': '/common/services/common',
    'agri': '/farmer/services/agri',
    'sme': '/agent/services/sme',
  };
  if (fixedRoutes.containsKey(serviceId)) {
    return fixedRoutes[serviceId]!;
  }
  final rolePath = switch (role) {
    UserRole.agent => 'agent',
    UserRole.farmer => 'farmer',
    UserRole.citizen => 'customer',
  };
  return '/$rolePath/services/$serviceId';
}

String _getIcon(String name) {
  switch (name) {
    case 'wealth':
      return AppAssets.iconSavings;
    case 'health':
      return AppAssets.iconFavoriteBorder;
    case 'sport':
      return AppAssets.iconExercise;
    case 'bills':
      return AppAssets.iconPay;
    case 'insurance':
      return AppAssets.iconShield;
    case 'gov':
      return AppAssets.iconAccountBalance;
    case 'common':
      return AppAssets.iconGrid;
    case 'banking':
      return AppAssets.iconBuilding;
    case 'mobile':
      return AppAssets.iconMobile;
    case 'market':
      return AppAssets.iconShoppingBag;
    case 'agri':
      return AppAssets.iconAgriculture;
    case 'logistics':
      return AppAssets.iconTruck;
    case 'sme':
      return AppAssets.iconBusinessCenter;
    default:
      return AppAssets.iconSavings;
  }
}

Color _getColor(String id) {
  switch (id) {
    case 'wealth':
      return AppColors.serviceWealth;
    case 'health':
      return AppColors.serviceHealth;
    case 'sport':
      return AppColors.serviceSport;
    case 'bills':
      return AppColors.serviceBills;
    case 'insurance':
      return AppColors.serviceInsurance;
    case 'gov':
      return AppColors.serviceGovt;
    case 'common':
      return AppColors.serviceCommon;
    case 'banking':
      return AppColors.serviceBanking;
    case 'mobile':
      return AppColors.serviceMobile;
    case 'market':
      return AppColors.serviceMarket;
    case 'agri':
      return AppColors.serviceAgri;
    case 'logistics':
      return AppColors.serviceLogistics;
    case 'sme':
      return AppColors.serviceSme;
    default:
      return AppColors.primary;
  }
}
