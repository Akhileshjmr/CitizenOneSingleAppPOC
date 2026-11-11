import 'package:citizenone_app/features/agent/collections/domain/entities/agent_collection_entity.dart';

abstract class AgentCollectionsRepository {
  Future<List<AgentCollectionEntity>> getCollections();
  Future<bool> markCollected(String id);
}
