import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import '../cubits/policy_purchase_cubit.dart';
import '../cubits/active_policies_cubit.dart';

class PolicyPurchaseScreen extends StatefulWidget {
  final String planId;
  final String title;
  final String premium;
  final String cover;

  const PolicyPurchaseScreen({
    super.key,
    this.planId = 'PLN-002',
    this.title = 'Health Shield Supreme',
    this.premium = 'ZMW 3,500/yr',
    this.cover = 'ZMW 200,000',
  });

  @override
  State<PolicyPurchaseScreen> createState() => _PolicyPurchaseScreenState();
}

class _PolicyPurchaseScreenState extends State<PolicyPurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomineeNameController = TextEditingController(text: 'Sarah Phiri');
  final _nomineePhoneController = TextEditingController(text: '+260971234567');
  String _nomineeRelation = 'Spouse';

  @override
  void dispose() {
    _nomineeNameController.dispose();
    _nomineePhoneController.dispose();
    super.dispose();
  }

  double _parsePremium() {
    final cleaned = widget.premium
        .replaceAll('ZMW', '')
        .replaceAll('/yr', '')
        .replaceAll('/season', '')
        .replaceAll(',', '')
        .trim();
    return double.tryParse(cleaned) ?? 3500.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Insurance Policy'),
      ),
      body: BlocConsumer<PolicyPurchaseCubit, PolicyPurchaseState>(
        listener: (context, state) {
          if (state is PolicyPurchaseSuccess) {
            context.read<ActivePoliciesCubit>().addPurchasedPolicy(state.policy);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Policy ${state.policy.policyId} successfully issued! Active cover: ${state.policy.coverageType}',
                ),
                backgroundColor: AppPalette.success,
              ),
            );
            context.go('/insurance/active-policies');
          } else if (state is PolicyPurchaseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppPalette.danger,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is PolicyPurchaseLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCard(),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Nominee & Beneficiary Information',
                    style: AppTypography.title2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    controller: _nomineeNameController,
                    label: 'Full Nominee Name',
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Enter nominee name' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    initialValue: _nomineeRelation,
                    decoration: InputDecoration(
                      labelText: 'Relationship to Insured',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.borderRadiusSm),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Spouse', child: Text('Spouse')),
                      DropdownMenuItem(value: 'Child', child: Text('Child')),
                      DropdownMenuItem(value: 'Parent', child: Text('Parent')),
                      DropdownMenuItem(value: 'Sibling', child: Text('Sibling')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _nomineeRelation = val);
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    controller: _nomineePhoneController,
                    label: 'Beneficiary Contact Number',
                    keyboardType: TextInputType.phone,
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Enter phone number' : null,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildCostBreakdown(),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: isLoading
                        ? 'Processing Policy Issuance...'
                        : 'Confirm & Issue Policy (${widget.premium})',
                    isLoading: isLoading,
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        context.read<PolicyPurchaseCubit>().purchasePolicy(
                              planId: widget.planId,
                              policyName: widget.title,
                              premiumAmount: _parsePremium(),
                              coverageType: widget.cover,
                              nomineeName: _nomineeNameController.text.trim(),
                              nomineeRelation: _nomineeRelation,
                            );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard() {
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
                    widget.title,
                    style: AppTypography.title2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppPalette.neutral200,
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
                  ),
                  child: Text(
                    widget.premium,
                    style: AppTypography.title3.copyWith(
                      color: AppPalette.insurance,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Guaranteed Sum Insured: ${widget.cover}',
              style: AppTypography.body2.copyWith(
                color: AppPalette.neutral600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostBreakdown() {
    final base = _parsePremium();
    final tax = base * 0.16;
    final total = base + tax;

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Premium Breakdown',
              style: AppTypography.title3.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Annual Base Premium:'),
                Text('ZMW ${base.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Statutory Insurance Levy (16%):'),
                Text('ZMW ${tax.toStringAsFixed(2)}'),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Payable:',
                  style: AppTypography.title3.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'ZMW ${total.toStringAsFixed(2)}',
                  style: AppTypography.title3.copyWith(
                    color: AppPalette.insurance,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
