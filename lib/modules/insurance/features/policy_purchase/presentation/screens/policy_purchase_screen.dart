import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:citizenone_app/core/core.dart';
import '../cubit/insurance_cubit.dart';
import '../cubit/insurance_state.dart';
import 'package:citizenone_app/modules/insurance/theme/insurance_colors.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insurance & Coverage'),
        backgroundColor: InsuranceColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const ModuleSwitcherBar(currentModuleId: 'insurance'),
          Expanded(
            child: BlocBuilder<InsuranceCubit, InsuranceState>(
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
                      const Icon(Icons.shield,
                          size: 64, color: InsuranceColors.primary),
                      const SizedBox(height: AppSpacing.md),
                      Text('Policy Activated!',
                          style: AppTypography.title
                              .copyWith(color: InsuranceColors.primary)),
                      const SizedBox(height: AppSpacing.sm),
                      Text('Policy ID: ${state.policy.policyId}',
                          style: AppTypography.caption),
                      Text('Coverage: ${state.policy.policyName}',
                          style: AppTypography.subtitle),
                      Text(
                          'Premium: ${DateFormatter.formatCurrency(state.policy.premiumAmount)} / month',
                          style: AppTypography.body),
                      const SizedBox(height: AppSpacing.lg),
                      AppButton(
                        label: 'Purchase Another Plan',
                        backgroundColor: InsuranceColors.primary,
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
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select Insurance Protection Plan',
                      style: AppTypography.title
                          .copyWith(color: InsuranceColors.primary)),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedPolicy,
                    decoration: const InputDecoration(labelText: 'Plan Name'),
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
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      label: 'Subscribe Policy',
                      backgroundColor: InsuranceColors.primary,
                      onPressed: _submit,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  ],
),
    );
  }
}
