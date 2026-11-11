import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import '../cubits/insurance_partner_cubit.dart';
import '../../domain/entities/insurance_partner_entity.dart';

class InsurancePartnersScreen extends StatefulWidget {
  const InsurancePartnersScreen({super.key});

  @override
  State<InsurancePartnersScreen> createState() => _InsurancePartnersScreenState();
}

class _InsurancePartnersScreenState extends State<InsurancePartnersScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<InsurancePartnerCubit>().loadPartners();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authorized Insurance Partners'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AppTextField(
              controller: _searchController,
              label: 'Search Partners',
              hint: 'Search partners by name or service key...',
              prefixIcon: const Icon(Icons.search),
              onChanged: (val) {
                context.read<InsurancePartnerCubit>().filterPartners(val);
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<InsurancePartnerCubit, InsurancePartnerState>(
              builder: (context, state) {
                if (state is InsurancePartnerLoading) {
                  return const Center(child: AppLoader());
                }

                if (state is InsurancePartnerError) {
                  return AppErrorView(
                    message: state.message,
                    onRetry: () =>
                        context.read<InsurancePartnerCubit>().loadPartners(),
                  );
                }

                if (state is InsurancePartnerLoaded) {
                  if (state.filteredPartners.isEmpty) {
                    return Center(
                      child: Text(
                        'No insurance partners match "${state.searchQuery}"',
                        style: AppTypography.body2,
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: state.filteredPartners.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final partner = state.filteredPartners[index];
                      return _PartnerCard(
                        partner: partner,
                        onSelect: () {
                          context.read<InsurancePartnerCubit>().selectPartner(partner);
                          context.push('/insurance/plans?vendorCode=${partner.vendorCode}');
                        },
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PartnerCard extends StatelessWidget {
  final InsurancePartnerEntity partner;
  final VoidCallback onSelect;

  const _PartnerCard({
    required this.partner,
    required this.onSelect,
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
              children: [
                CircleAvatar(
                  backgroundColor: AppPalette.neutral200,
                  child: Text(
                    partner.vendorKey,
                    style: AppTypography.title3.copyWith(
                      color: AppPalette.insurance,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        partner.vendorName,
                        style: AppTypography.title2.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Vendor Code: ${partner.vendorCode} • ${partner.vendorMob}',
                        style: AppTypography.body3.copyWith(
                          color: AppPalette.neutral500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              partner.vendorDesc,
              style: AppTypography.body2,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  label: 'Select & View Plans',
                  onPressed: onSelect,
                  size: AppButtonSize.small,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
