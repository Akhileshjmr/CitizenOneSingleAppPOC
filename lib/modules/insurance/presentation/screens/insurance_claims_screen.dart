import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import '../cubits/insurance_claim_cubit.dart';
import '../../domain/entities/insurance_claim_entity.dart';

class InsuranceClaimsScreen extends StatefulWidget {
  final String? initialPolicyId;

  const InsuranceClaimsScreen({super.key, this.initialPolicyId});

  @override
  State<InsuranceClaimsScreen> createState() => _InsuranceClaimsScreenState();
}

class _InsuranceClaimsScreenState extends State<InsuranceClaimsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _policyIdController;
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _policyIdController =
        TextEditingController(text: widget.initialPolicyId ?? 'POL-90281');
    context.read<InsuranceClaimCubit>().loadClaims();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _policyIdController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insurance Claims'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'File New Claim'),
            Tab(text: 'Claim History'),
          ],
        ),
      ),
      body: BlocConsumer<InsuranceClaimCubit, InsuranceClaimState>(
        listener: (context, state) {
          if (state is InsuranceClaimSubmissionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Claim ${state.claim.claimId} successfully submitted! Under review by ${state.claim.providerName}',
                ),
                backgroundColor: AppPalette.success,
              ),
            );
            _amountController.clear();
            _descriptionController.clear();
            context.read<InsuranceClaimCubit>().loadClaims();
            _tabController.animateTo(1);
          } else if (state is InsuranceClaimError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppPalette.danger,
              ),
            );
          }
        },
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildFilingForm(context, state is InsuranceClaimLoading),
              _buildClaimsList(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilingForm(BuildContext context, bool isLoading) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Submit a Policy Claim',
              style: AppTypography.title2.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Provide the incident details and requested reimbursement amount for fast settlement.',
              style: AppTypography.body3.copyWith(color: AppPalette.neutral500),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              controller: _policyIdController,
              label: 'Policy Number',
              validator: (val) =>
                  val == null || val.isEmpty ? 'Enter policy ID' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _amountController,
              label: 'Claim Amount (ZMW)',
              keyboardType: TextInputType.number,
              validator: (val) =>
                  val == null || val.isEmpty ? 'Enter claim amount' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _descriptionController,
              label: 'Incident & Treatment Details',
              validator: (val) => val == null || val.isEmpty
                  ? 'Enter incident description'
                  : null,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: isLoading ? 'Submitting Claim...' : 'Submit Claim Request',
              isLoading: isLoading,
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
                  context.read<InsuranceClaimCubit>().submitClaim(
                        policyId: _policyIdController.text.trim(),
                        amount: amount,
                        description: _descriptionController.text.trim(),
                      );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClaimsList(BuildContext context, InsuranceClaimState state) {
    if (state is InsuranceClaimLoading) {
      return const Center(child: AppLoader());
    }

    if (state is InsuranceClaimsLoaded) {
      if (state.claims.isEmpty) {
        return const Center(child: Text('No claims submitted yet.'));
      }

      return ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: state.claims.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final claim = state.claims[index];
          return _ClaimCard(claim: claim);
        },
      );
    }

    return Center(
      child: AppButton(
        label: 'Load Claims',
        onPressed: () => context.read<InsuranceClaimCubit>().loadClaims(),
        size: AppButtonSize.small,
      ),
    );
  }
}

class _ClaimCard extends StatelessWidget {
  final InsuranceClaimEntity claim;

  const _ClaimCard({required this.claim});

  Color _statusColor(ClaimStatus status) {
    switch (status) {
      case ClaimStatus.approved:
      case ClaimStatus.paid:
        return AppPalette.success;
      case ClaimStatus.inReview:
        return AppPalette.warning;
      case ClaimStatus.rejected:
        return AppPalette.danger;
      case ClaimStatus.submitted:
        return AppPalette.info;
    }
  }

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
                Text(
                  claim.claimId,
                  style: AppTypography.title3.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: 2),
                  decoration: BoxDecoration(
                    color: _statusColor(claim.status).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    claim.status.name.toUpperCase(),
                    style: AppTypography.label3.copyWith(
                      color: _statusColor(claim.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${claim.policyName} (${claim.policyId}) • Filed: ${claim.filingDate}',
              style: AppTypography.body3.copyWith(color: AppPalette.neutral500),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              claim.description,
              style: AppTypography.body2,
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Claimed Amount:',
                    style: AppTypography.body3.copyWith(color: AppPalette.neutral500)),
                Text(
                  claim.claimAmount,
                  style: AppTypography.title3.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppPalette.insurance,
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
