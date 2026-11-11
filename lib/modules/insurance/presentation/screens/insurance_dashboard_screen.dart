import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import '../cubits/insurance_categories_cubit.dart';
import '../cubits/active_policies_cubit.dart';
import '../../domain/entities/insurance_category_entity.dart';

class InsuranceDashboardScreen extends StatefulWidget {
  const InsuranceDashboardScreen({super.key});

  @override
  State<InsuranceDashboardScreen> createState() =>
      _InsuranceDashboardScreenState();
}

class _InsuranceDashboardScreenState extends State<InsuranceDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<InsuranceCategoriesCubit>().loadCategories();
    context.read<ActivePoliciesCubit>().loadPolicies();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Insurance Services'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.handshake_outlined),
            tooltip: 'Insurance Partners',
            onPressed: () => context.push('/insurance/partners'),
          ),
          IconButton(
            icon: const Icon(Icons.assignment_turned_in_outlined),
            tooltip: 'Active Policies',
            onPressed: () => context.push('/insurance/active-policies'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final catCubit = context.read<InsuranceCategoriesCubit>();
          final polCubit = context.read<ActivePoliciesCubit>();
          await catCubit.loadCategories();
          await polCubit.loadPolicies();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroBanner(context),
              const SizedBox(height: AppSpacing.lg),
              _buildQuickActions(context),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Explore Coverage Categories',
                style: AppTypography.title2.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildCategorySection(context),
              const SizedBox(height: AppSpacing.lg),
              _buildActivePoliciesPreview(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppPalette.insurance,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
                ),
                child: const Icon(Icons.verified_user, color: Colors.white, size: 20),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'GUARANTEED CIVIC PROTECTION',
                style: AppTypography.label1.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Protect What Matters Most',
            style: AppTypography.headline3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Instant health, crop, motor & life cover with 98.4% verified settlement ratio.',
            style: AppTypography.body2.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              AppButton(
                label: 'View Partners',
                onPressed: () => context.push('/insurance/partners'),
                variant: AppButtonVariant.outlined,
                backgroundColor: Colors.white,
              ),
              const SizedBox(width: AppSpacing.sm),
              AppButton(
                label: 'File a Claim',
                onPressed: () => context.push('/insurance/claims'),
                variant: AppButtonVariant.text,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: Icons.shield_outlined,
            title: 'Browse Plans',
            subtitle: 'Compare & Buy',
            color: AppPalette.insurance,
            onTap: () => context.push('/insurance/plans'),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.assignment_outlined,
            title: 'My Policies',
            subtitle: 'Renew & View',
            color: AppPalette.info,
            onTap: () => context.push('/insurance/active-policies'),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.support_agent_outlined,
            title: 'File Claim',
            subtitle: 'Track Status',
            color: AppPalette.warning,
            onTap: () => context.push('/insurance/claims'),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    return BlocBuilder<InsuranceCategoriesCubit, InsuranceCategoriesState>(
      builder: (context, state) {
        if (state is InsuranceCategoriesLoading) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: AppLoader(),
          ));
        }

        if (state is InsuranceCategoriesError) {
          return AppErrorView(
            message: state.message,
            onRetry: () =>
                context.read<InsuranceCategoriesCubit>().loadCategories(),
          );
        }

        if (state is InsuranceCategoriesLoaded) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.15,
            ),
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final cat = state.categories[index];
              return _CategoryGridTile(
                category: cat,
                onTap: () {
                  context.push('/insurance/plans?categoryCode=${cat.code}');
                },
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildActivePoliciesPreview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Active Policies',
              style: AppTypography.title2.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/insurance/active-policies'),
              child: const Text('See All'),
            ),
          ],
        ),
        BlocBuilder<ActivePoliciesCubit, ActivePoliciesState>(
          builder: (context, state) {
            if (state is ActivePoliciesLoading) {
              return const Center(child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: AppLoader(),
              ));
            }

            if (state is ActivePoliciesLoaded) {
              if (state.policies.isEmpty) {
                return const AppCard(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Text('No active policies found. Purchase your first plan above!'),
                  ),
                );
              }

              final policy = state.policies.first;
              return AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppPalette.neutral100,
                          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
                        ),
                        child: const Icon(Icons.check_circle,
                            color: AppPalette.success, size: 28),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              policy.policyName,
                              style: AppTypography.title3.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${policy.providerName} • Expires ${policy.expiryDate}',
                              style: AppTypography.body3.copyWith(
                                color: AppPalette.neutral500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppPalette.neutral200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          policy.status,
                          style: AppTypography.label2.copyWith(
                            color: AppPalette.neutral800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
      child: AppCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: AppSpacing.xs),
              Text(
                title,
                style: AppTypography.label1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: AppTypography.label3.copyWith(
                  color: AppPalette.neutral500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryGridTile extends StatelessWidget {
  final InsuranceCategoryEntity category;
  final VoidCallback onTap;

  const _CategoryGridTile({
    required this.category,
    required this.onTap,
  });

  IconData _iconForCategory(String code) {
    switch (code.toUpperCase()) {
      case 'HEALTH':
        return Icons.medical_services_outlined;
      case 'MOTOR':
        return Icons.directions_car_outlined;
      case 'AGRI':
        return Icons.agriculture_outlined;
      case 'LIFE':
        return Icons.favorite_border;
      default:
        return Icons.security_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = _iconForCategory(category.code);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
      child: AppCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppPalette.neutral100,
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
                ),
                child: Icon(icon, color: AppPalette.insurance, size: 24),
              ),
              const Spacer(),
              Text(
                category.name,
                style: AppTypography.title3.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                category.desc ?? '${category.subCategories.length} plan types available',
                style: AppTypography.label3.copyWith(
                  color: AppPalette.neutral500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
