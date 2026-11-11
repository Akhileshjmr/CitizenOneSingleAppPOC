import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/agent_collection_entity.dart';
import '../../domain/usecases/get_agent_collections_usecase.dart';

abstract class AgentCollectionsState extends Equatable {
  const AgentCollectionsState();
  @override
  List<Object?> get props => [];
}

class AgentCollectionsInitial extends AgentCollectionsState {}

class AgentCollectionsLoading extends AgentCollectionsState {}

class AgentCollectionsLoaded extends AgentCollectionsState {
  final List<AgentCollectionEntity> collections;
  const AgentCollectionsLoaded(this.collections);

  @override
  List<Object?> get props => [collections];
}

class AgentCollectionRecordSuccess extends AgentCollectionsState {
  final AgentCollectionEntity collection;
  const AgentCollectionRecordSuccess(this.collection);

  @override
  List<Object?> get props => [collection];
}

class AgentCollectionsError extends AgentCollectionsState {
  final String message;
  const AgentCollectionsError(this.message);

  @override
  List<Object?> get props => [message];
}

class AgentCollectionsCubit extends Cubit<AgentCollectionsState> {
  final GetAgentCollectionsUseCase getCollectionsUseCase;
  final RecordCollectionUseCase recordCollectionUseCase;

  AgentCollectionsCubit({
    required this.getCollectionsUseCase,
    required this.recordCollectionUseCase,
  }) : super(AgentCollectionsInitial());

  Future<void> loadCollections() async {
    emit(AgentCollectionsLoading());
    try {
      final list = await getCollectionsUseCase();
      emit(AgentCollectionsLoaded(list));
    } catch (e) {
      emit(AgentCollectionsError(e.toString()));
    }
  }

  Future<void> recordCollection({
    required String collectionId,
    required double amount,
    required String paymentMode,
  }) async {
    emit(AgentCollectionsLoading());
    try {
      final updated = await recordCollectionUseCase(
        collectionId: collectionId,
        amountCollected: amount,
        paymentMode: paymentMode,
      );
      emit(AgentCollectionRecordSuccess(updated));
    } catch (e) {
      emit(AgentCollectionsError(e.toString()));
    }
  }

  void reset() {
    emit(AgentCollectionsInitial());
  }
}

