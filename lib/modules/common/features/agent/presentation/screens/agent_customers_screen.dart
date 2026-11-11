import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import '../cubits/agent_customers_cubit.dart';
import '../../domain/entities/agent_customer_entity.dart';

class AgentCustomersScreen extends StatefulWidget {
  const AgentCustomersScreen({super.key});

  @override
  State<AgentCustomersScreen> createState() => _AgentCustomersScreenState();
}

class _AgentCustomersScreenState extends State<AgentCustomersScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AgentCustomersCubit>().loadCustomers();
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
        title: const Text('Customer Directory'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AppTextField(
              controller: _searchController,
              label: 'Search Directory',
              hint: 'Search by customer name, phone, account or ward...',
              prefixIcon: const Icon(Icons.search),
              onChanged: (val) {
                context.read<AgentCustomersCubit>().searchCustomers(val);
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<AgentCustomersCubit, AgentCustomersState>(
              builder: (context, state) {
                if (state is AgentCustomersLoading) {
                  return const Center(child: AppLoader());
                }

                if (state is AgentCustomersError) {
                  return AppErrorView(
                    message: state.message,
                    onRetry: () =>
                        context.read<AgentCustomersCubit>().loadCustomers(),
                  );
                }

                if (state is AgentCustomersLoaded) {
                  if (state.filteredCustomers.isEmpty) {
                    return Center(
                      child: Text(
                        'No customers found matching "${state.searchQuery}"',
                        style: AppTypography.body2,
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: state.filteredCustomers.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final customer = state.filteredCustomers[index];
                      return _CustomerCard(customer: customer);
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

class _CustomerCard extends StatelessWidget {
  final AgentCustomerEntity customer;

  const _CustomerCard({required this.customer});

  Color _statusColor(CustomerStatus status) {
    switch (status) {
      case CustomerStatus.active:
        return AppPalette.success;
      case CustomerStatus.kycPending:
        return AppPalette.warning;
      case CustomerStatus.onboarding:
        return AppPalette.info;
      case CustomerStatus.inactive:
        return AppPalette.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppPalette.primary.withValues(alpha: 0.12),
              child: Text(
                customer.name.substring(0, 1),
                style: AppTypography.title3.copyWith(
                  color: AppPalette.primary,
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
                    customer.name,
                    style: AppTypography.title3.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${customer.phone} • ${customer.location}',
                    style: AppTypography.body3.copyWith(
                      color: AppPalette.neutral500,
                    ),
                  ),
                  if (customer.businessType != null)
                    Text(
                      'Business: ${customer.businessType}',
                      style: AppTypography.label3.copyWith(
                        color: AppPalette.neutral600,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: _statusColor(customer.status).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                customer.status.name.toUpperCase(),
                style: AppTypography.label3.copyWith(
                  color: _statusColor(customer.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

