import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:citizenone_app/core/core.dart';
import '../cubit/insurance_cubit.dart';
import '../cubit/insurance_state.dart';

class PolicyPurchaseScreen extends StatefulWidget {
  const PolicyPurchaseScreen({super.key});

  @override
  State<PolicyPurchaseScreen> createState() => _PolicyPurchaseScreenState();
}

class _PolicyPurchaseScreenState extends State<PolicyPurchaseScreen> {
  String _selectedPolicy = 'Health Shield Protection';
  double _premium = 45.00;

  void _submit() {
    context.read<InsuranceCubit>().purchase(
          policyName: _selectedPolicy,
          premiumAmount: _premium,
        );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return BlocBuilder<InsuranceCubit, InsuranceState>(
      builder: (context, state) {
        if (state is InsuranceLoading) {
          return const AppLoader(message: 'Activating Insurance Policy...');
        }

        if (state is InsuranceSuccess) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shield, size: 64, color: primaryColor),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Policy Activated!',
                      style: AppTypography.title.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Policy ID: ${state.policy.policyId}',
                        style: AppTypography.caption),
                    Text('Coverage: ${state.policy.policyName}',
                        style: AppTypography.subtitle),
                    Text(
                      'Premium: ${DateFormatter.formatCurrency(state.policy.premiumAmount)} / month',
                      style: AppTypography.body,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(
                      label: 'Purchase Another Plan',
                      backgroundColor: primaryColor,
                      onPressed: () => context.read<InsuranceCubit>().reset(),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: primaryColor.withValues(alpha: 0.15),
                          child: Icon(Icons.security, color: primaryColor),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Insurance & Protection Portal',
                                style: AppTypography.title.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Select your preferred coverage plan below.',
                                style: AppTypography.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedPolicy,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Insurance Protection Plan',
                        prefixIcon: Icon(Icons.shield_outlined, color: primaryColor),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'Health Shield Protection',
                            child: Text('Health Shield Protection (\$45/mo)')),
                        DropdownMenuItem(
                            value: 'Micro-Crop Insurance',
                            child: Text('Micro-Crop Insurance (\$25/mo)')),
                        DropdownMenuItem(
                            value: 'Life & Accident Cover',
                            child: Text('Life & Accident Cover (\$60/mo)')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedPolicy = val;
                            if (val.contains('45')) _premium = 45.0;
                            if (val.contains('25')) _premium = 25.0;
                            if (val.contains('60')) _premium = 60.0;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Monthly Premium:'),
                          Text(
                            DateFormatter.formatCurrency(_premium),
                            style: AppTypography.title.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        label: 'Subscribe Policy Plan',
                        backgroundColor: primaryColor,
                        onPressed: _submit,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
