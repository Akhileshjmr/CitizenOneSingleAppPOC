import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/di/di_setup.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:citizenone_app/features/agent/customers/domain/entities/agent_customer_entity.dart';
import 'package:citizenone_app/features/agent/customers/presentation/state/agent_customers_cubit.dart';
import 'package:citizenone_app/features/agent/customers/presentation/state/agent_customers_state.dart';
import 'package:citizenone_app/features/agent/customers/presentation/widgets/customer_list_tile.dart';

class AgentCustomersScreen extends StatelessWidget {
  const AgentCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AgentCustomersCubit>(
      create: (_) => sl<AgentCustomersCubit>()..loadCustomers(),
      child: const _AgentCustomersView(),
    );
  }
}

class _AgentCustomersView extends StatefulWidget {
  const _AgentCustomersView();

  @override
  State<_AgentCustomersView> createState() => _AgentCustomersViewState();
}

class _AgentCustomersViewState extends State<_AgentCustomersView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: tokens.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: tokens.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: AppText(
          'My Customers',
          style: AppTextStyle.bodyLarge,
          fontWeight: FontWeight.w700,
          color: tokens.textPrimary,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF4F46E5),
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: AppText(
          'New Onboarding',
          style: AppTextStyle.bodySmall,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Container(
            color: tokens.surface,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              children: [
                AppTextField(
                  controller: _searchController,
                  hintText: 'Search by name, phone, or business…',
                  prefixIcon: AppAssets.iconSearch,
                  onChanged: (q) =>
                      context.read<AgentCustomersCubit>().search(q),
                ),
                const SizedBox(height: 10),
                _SummaryRow(),
              ],
            ),
          ),
          _FilterBar(),
          Expanded(
            child: BlocBuilder<AgentCustomersCubit, AgentCustomersState>(
              builder: (context, state) {
                if (state.isLoading) return const _CustomersSkeleton();
                if (state.errorMessage != null) {
                  return Center(
                    child: AppText(
                      state.errorMessage!,
                      style: AppTextStyle.bodyMedium,
                      color: tokens.error,
                    ),
                  );
                }
                if (state.filteredCustomers.isEmpty) {
                  return Center(
                    child: AppText(
                      'No customers found',
                      style: AppTextStyle.bodyMedium,
                      color: tokens.textSecondary,
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  itemCount: state.filteredCustomers.length,
                  itemBuilder: (_, i) =>
                      CustomerListTile(customer: state.filteredCustomers[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgentCustomersCubit, AgentCustomersState>(
      builder: (context, state) {
        final total = state.customers.length;
        final active = state.customers
            .where((c) => c.status == CustomerStatus.active)
            .length;
        final pending = state.customers
            .where(
              (c) =>
                  c.status == CustomerStatus.kycPending ||
                  c.status == CustomerStatus.onboarding,
            )
            .length;

        return Row(
          children: [
            _StatBadge(
              label: 'Total',
              value: '$total',
              color: context.appTokens.textSecondary,
            ),
            const SizedBox(width: 12),
            _StatBadge(
              label: 'Active',
              value: '$active',
              color: const Color(0xFF059669),
            ),
            const SizedBox(width: 12),
            _StatBadge(
              label: 'Pending',
              value: '$pending',
              color: const Color(0xFFD97706),
            ),
          ],
        );
      },
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
          value,
          style: AppTextStyle.bodySmall,
          fontWeight: FontWeight.w800,
          color: color,
        ),
        const SizedBox(width: 4),
        AppText(
          label,
          style: AppTextStyle.caption,
          color: color.withValues(alpha: 0.8),
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return BlocBuilder<AgentCustomersCubit, AgentCustomersState>(
      builder: (context, state) {
        return Container(
          color: tokens.surface,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _chip('All', null, state.filterStatus, context),
                const SizedBox(width: 8),
                _chip(
                  'Active',
                  CustomerStatus.active,
                  state.filterStatus,
                  context,
                ),
                const SizedBox(width: 8),
                _chip(
                  'KYC Pending',
                  CustomerStatus.kycPending,
                  state.filterStatus,
                  context,
                ),
                const SizedBox(width: 8),
                _chip(
                  'Onboarding',
                  CustomerStatus.onboarding,
                  state.filterStatus,
                  context,
                ),
                const SizedBox(width: 8),
                _chip(
                  'Inactive',
                  CustomerStatus.inactive,
                  state.filterStatus,
                  context,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _chip(
    String label,
    CustomerStatus? value,
    CustomerStatus? current,
    BuildContext context,
  ) {
    final selected = value == current;
    return GestureDetector(
      onTap: () => context.read<AgentCustomersCubit>().setFilter(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF4F46E5) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: AppText(
          label,
          style: AppTextStyle.caption,
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : const Color(0xFF6B7280),
        ),
      ),
    );
  }
}

class _CustomersSkeleton extends StatelessWidget {
  const _CustomersSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, __) => Container(
        height: 90,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
