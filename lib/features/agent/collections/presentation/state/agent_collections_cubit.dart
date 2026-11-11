import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/features/agent/collections/domain/entities/agent_collection_entity.dart';
import 'package:citizenone_app/features/agent/collections/domain/usecases/get_agent_collections_usecase.dart';
import 'package:citizenone_app/features/agent/collections/presentation/state/agent_collections_state.dart';

class AgentCollectionsCubit extends Cubit<AgentCollectionsState> {
  final GetAgentCollectionsUseCase _getCollectionsUseCase;

  AgentCollectionsCubit(
      {required GetAgentCollectionsUseCase getCollectionsUseCase})
      : _getCollectionsUseCase = getCollectionsUseCase,
        super(const AgentCollectionsState());

  Future<void> loadCollections() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final collections = await _getCollectionsUseCase();
      emit(state.copyWith(collections: collections, isLoading: false));
    } catch (_) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load collections.',
      ));
    }
  }

  void setFilter(CollectionStatus? status) {
    emit(state.copyWith(
      filterStatus: status,
      clearFilter: status == null,
    ));
  }

  void markCollected(String id) {
    final updated = state.collections.map((c) {
      if (c.id == id) {
        return AgentCollectionEntity(
          id: c.id,
          merchantName: c.merchantName,
          amountDue: c.amountDue,
          dueDate: c.dueDate,
          status: CollectionStatus.collected,
          location: c.location,
          phone: c.phone,
          lastCollectedDate: 'Today',
        );
      }
      return c;
    }).toList();
    emit(state.copyWith(collections: updated));
  }
}
