import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import '../cubits/agent_collections_cubit.dart';
import '../../domain/entities/agent_collection_entity.dart';

class AgentCollectionsScreen extends StatefulWidget {
  const AgentCollectionsScreen({super.key});

  @override
  State<AgentCollectionsScreen> createState() => _AgentCollectionsScreenState();
}

class _AgentCollectionsScreenState extends State<AgentCollectionsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AgentCollectionsCubit>().loadCollections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Field Collections & Cash In'),
      ),
      body: BlocConsumer<AgentCollectionsCubit, AgentCollectionsState>(
        listener: (context, state) {
          if (state is AgentCollectionRecordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Collection for ${state.collection.merchantName} successfully recorded! Receipt issued.',
                ),
                backgroundColor: AppPalette.success,
              ),
            );
            context.read<AgentCollectionsCubit>().loadCollections();
          } else if (state is AgentCollectionsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppPalette.danger,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AgentCollectionsLoading) {
            return const Center(child: AppLoader());
          }

          if (state is AgentCollectionsError) {
            return AppErrorView(
              message: state.message,
              onRetry: () =>
                  context.read<AgentCollectionsCubit>().loadCollections(),
            );
          }

          if (state is AgentCollectionsLoaded) {
            if (state.collections.isEmpty) {
              return const Center(child: Text('No pending collections recorded.'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: state.collections.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final item = state.collections[index];
                return _CollectionCard(
                  item: item,
                  onCollect: () => _showRecordDialog(context, item),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showRecordDialog(BuildContext context, AgentCollectionEntity item) {
    final amountController =
        TextEditingController(text: item.amountDue.replaceAll('ZMW ', '').replaceAll(',', ''));
    String mode = 'CASH';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: Text('Record Collection: ${item.merchantName}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(
                    controller: amountController,
                    label: 'Amount Collected (ZMW)',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    initialValue: mode,
                    decoration: const InputDecoration(labelText: 'Payment Mode'),
                    items: const [
                      DropdownMenuItem(value: 'CASH', child: Text('Physical Cash')),
                      DropdownMenuItem(value: 'WALLET', child: Text('Mobile Money Wallet')),
                    ],
                    onChanged: (val) {
                      if (val != null) setDialogState(() => mode = val);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
                AppButton(
                  label: 'Confirm Receipt',
                  size: AppButtonSize.small,
                  onPressed: () {
                    final amt = double.tryParse(amountController.text.trim()) ?? 0.0;
                    Navigator.of(ctx).pop();
                    context.read<AgentCollectionsCubit>().recordCollection(
                          collectionId: item.id,
                          amount: amt,
                          paymentMode: mode,
                        );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final AgentCollectionEntity item;
  final VoidCallback onCollect;

  const _CollectionCard({
    required this.item,
    required this.onCollect,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = item.status == CollectionStatus.collected;
    final isOverdue = item.status == CollectionStatus.overdue;

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
                    item.merchantName,
                    style: AppTypography.title3.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  item.amountDue,
                  style: AppTypography.title2.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDone ? AppPalette.success : AppPalette.neutral800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${item.location} • ${item.dueDate}',
              style: AppTypography.body3.copyWith(
                color: isOverdue ? AppPalette.danger : AppPalette.neutral500,
                fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (!isDone) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    label: 'Collect & Issue Receipt',
                    size: AppButtonSize.small,
                    onPressed: onCollect,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

