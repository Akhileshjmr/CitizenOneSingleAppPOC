import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import '../cubits/active_policies_cubit.dart';
import '../../domain/entities/policy_entity.dart';

class ActivePoliciesScreen extends StatefulWidget {
  const ActivePoliciesScreen({super.key});

  @override
  State<ActivePoliciesScreen> createState() => _ActivePoliciesScreenState();
}

class _ActivePoliciesScreenState extends State<ActivePoliciesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ActivePoliciesCubit>().loadPolicies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Active Policies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Browse New Plans',
            onPressed: () => context.push('/insurance/plans'),
          ),
        ],
      ),
      body: BlocBuilder<ActivePoliciesCubit, ActivePoliciesState>(
        builder: (context, state) {
          if (state is ActivePoliciesLoading) {
            return const Center(child: AppLoader());
          }

          if (state is ActivePoliciesError) {
            return AppErrorView(
              message: state.message,
              onRetry: () => context.read<ActivePoliciesCubit>().loadPolicies(),
            );
          }

          if (state is ActivePoliciesLoaded) {
            if (state.policies.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shield_outlined,
                          size: 64, color: AppPalette.neutral400),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'No Active Policies Found',
                        style: AppTypography.title2.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'You currently do not have any active insurance policies registered.',
                        textAlign: TextAlign.center,
                        style: AppTypography.body3.copyWith(
                          color: AppPalette.neutral500,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppButton(
                        label: 'Explore Insurance Plans',
                        onPressed: () => context.push('/insurance/plans'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: state.policies.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final policy = state.policies[index];
                return _ActivePolicyCard(
                  policy: policy,
                  onFileClaim: () {
                    context.push('/insurance/claims?policyId=${policy.policyId}');
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ActivePolicyCard extends StatelessWidget {
  final PolicyEntity policy;
  final VoidCallback onFileClaim;

  const _ActivePolicyCard({
    required this.policy,
    required this.onFileClaim,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    policy.policyName,
                    style: AppTypography.title2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppPalette.neutral200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    policy.status,
                    style: AppTypography.label2.copyWith(
                      color: AppPalette.insurance,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Policy ID: ${policy.policyId} • Underwritten by ${policy.providerName}',
              style: AppTypography.body3.copyWith(color: AppPalette.neutral500),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Coverage Limit',
                        style: AppTypography.label3
                            .copyWith(color: AppPalette.neutral500)),
                    Text(policy.coverageType,
                        style: AppTypography.body2
                            .copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Annual Premium',
                        style: AppTypography.label3
                            .copyWith(color: AppPalette.neutral500)),
                    Text('ZMW ${policy.premiumAmount.toStringAsFixed(0)}',
                        style: AppTypography.body2
                            .copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Valid Until',
                        style: AppTypography.label3
                            .copyWith(color: AppPalette.neutral500)),
                    Text(policy.expiryDate,
                        style: AppTypography.body2
                            .copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: onFileClaim,
                  icon: const Icon(Icons.note_alt_outlined, size: 16),
                  label: const Text('File Claim'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
