import 'package:citizenone_app/features/agent/collections/domain/entities/agent_collection_entity.dart';
import 'package:citizenone_app/features/agent/collections/domain/repositories/agent_collections_repository.dart';

class GetAgentCollectionsUseCase {
  final AgentCollectionsRepository _repository;

  const GetAgentCollectionsUseCase(this._repository);

  Future<List<AgentCollectionEntity>> call() => _repository.getCollections();
}
