import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/di/di_setup.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:citizenone_app/features/agent/collections/domain/entities/agent_collection_entity.dart';
import 'package:citizenone_app/features/agent/collections/presentation/state/agent_collections_cubit.dart';
import 'package:citizenone_app/features/agent/collections/presentation/state/agent_collections_state.dart';
import 'package:citizenone_app/features/agent/collections/presentation/widgets/collection_list_tile.dart';

class AgentCollectionsScreen extends StatelessWidget {
  const AgentCollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AgentCollectionsCubit>(
      create: (_) => sl<AgentCollectionsCubit>()..loadCollections(),
      child: const _AgentCollectionsView(),
    );
  }
}

class _AgentCollectionsView extends StatelessWidget {
  const _AgentCollectionsView();

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
          'Collections',
          style: AppTextStyle.bodyLarge,
          fontWeight: FontWeight.w700,
          color: tokens.textPrimary,
        ),
      ),
      body: Column(
        children: [
          _SummaryHeader(),
          _FilterBar(),
          Expanded(
            child: BlocBuilder<AgentCollectionsCubit, AgentCollectionsState>(
              builder: (context, state) {
                if (state.isLoading) return const _CollectionsSkeleton();
                if (state.errorMessage != null) {
                  return Center(
                    child: AppText(
                      state.errorMessage!,
                      style: AppTextStyle.bodyMedium,
                      color: tokens.error,
                    ),
                  );
                }
                if (state.filteredCollections.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.circle_check,
                          size: 48,
                          color: const Color(0xFF059669),
                        ),
                        const SizedBox(height: 12),
                        AppText(
                          'All caught up!',
                          style: AppTextStyle.bodyLarge,
                          fontWeight: FontWeight.w600,
                          color: tokens.textSecondary,
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.filteredCollections.length,
                  itemBuilder: (_, i) => CollectionListTile(
                    collection: state.filteredCollections[i],
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

class _SummaryHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return BlocBuilder<AgentCollectionsCubit, AgentCollectionsState>(
      builder: (context, state) {
        return Container(
          color: tokens.surface,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  label: 'Pending',
                  value: '${state.pendingCount}',
                  color: const Color(0xFFD97706),
                  bg: const Color(0xFFFEF3C7),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  label: 'Overdue',
                  value: '${state.overdueCount}',
                  color: const Color(0xFFDC2626),
                  bg: const Color(0xFFFEE2E2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  label: 'Collected',
                  value:
                      '${state.collections.where((c) => c.status == CollectionStatus.collected).length}',
                  color: const Color(0xFF059669),
                  bg: const Color(0xFFDCFCE7),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color bg;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          AppText(
            value,
            style: AppTextStyle.displaySmall,
            fontWeight: FontWeight.w800,
            color: color,
          ),
          const SizedBox(height: 4),
          AppText(
            label,
            style: AppTextStyle.caption,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return BlocBuilder<AgentCollectionsCubit, AgentCollectionsState>(
      builder: (context, state) {
        return Container(
          color: tokens.surface,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _chip(context, 'All', null, state.filterStatus),
                const SizedBox(width: 8),
                _chip(
                  context,
                  'Pending',
                  CollectionStatus.pending,
                  state.filterStatus,
                ),
                const SizedBox(width: 8),
                _chip(
                  context,
                  'Overdue',
                  CollectionStatus.overdue,
                  state.filterStatus,
                ),
                const SizedBox(width: 8),
                _chip(
                  context,
                  'Collected',
                  CollectionStatus.collected,
                  state.filterStatus,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _chip(
    BuildContext context,
    String label,
    CollectionStatus? value,
    CollectionStatus? current,
  ) {
    final selected = value == current;
    final activeColor = value == CollectionStatus.overdue
        ? const Color(0xFFDC2626)
        : const Color(0xFF4F46E5);
    return GestureDetector(
      onTap: () => context.read<AgentCollectionsCubit>().setFilter(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? activeColor : const Color(0xFFF3F4F6),
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

class _CollectionsSkeleton extends StatelessWidget {
  const _CollectionsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (_, __) => Container(
        height: 130,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
