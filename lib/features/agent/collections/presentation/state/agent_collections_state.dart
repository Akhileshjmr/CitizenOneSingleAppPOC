import 'package:citizenone_app/features/agent/collections/domain/entities/agent_collection_entity.dart';

class AgentCollectionsState {
  final bool isLoading;
  final List<AgentCollectionEntity> collections;
  final CollectionStatus? filterStatus;
  final String? errorMessage;

  const AgentCollectionsState({
    this.isLoading = false,
    this.collections = const [],
    this.filterStatus,
    this.errorMessage,
  });

  List<AgentCollectionEntity> get filteredCollections => filterStatus == null
      ? collections
      : collections.where((c) => c.status == filterStatus).toList();

  int get overdueCount =>
      collections.where((c) => c.status == CollectionStatus.overdue).length;

  int get pendingCount =>
      collections.where((c) => c.status == CollectionStatus.pending).length;

  AgentCollectionsState copyWith({
    bool? isLoading,
    List<AgentCollectionEntity>? collections,
    CollectionStatus? filterStatus,
    bool clearFilter = false,
    String? errorMessage,
  }) {
    return AgentCollectionsState(
      isLoading: isLoading ?? this.isLoading,
      collections: collections ?? this.collections,
      filterStatus:
          clearFilter ? null : (filterStatus ?? this.filterStatus),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
