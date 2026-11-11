import '../entities/agent_collection_entity.dart';
import '../repositories/agent_repository.dart';

class GetAgentCollectionsUseCase {
  final AgentRepository repository;

  GetAgentCollectionsUseCase(this.repository);

  Future<List<AgentCollectionEntity>> call() {
    return repository.getCollections();
  }
}

class RecordCollectionUseCase {
  final AgentRepository repository;

  RecordCollectionUseCase(this.repository);

  Future<AgentCollectionEntity> call({
    required String collectionId,
    required double amountCollected,
    required String paymentMode,
  }) {
    return repository.recordCollection(
      collectionId: collectionId,
      amountCollected: amountCollected,
      paymentMode: paymentMode,
    );
  }
}

