import '../entities/agent_dashboard_entity.dart';
import '../entities/agent_task_entity.dart';
import '../entities/agent_customer_entity.dart';
import '../entities/agent_collection_entity.dart';

abstract class AgentRepository {
  Future<AgentDashboardEntity> getDashboardData();
  Future<List<AgentTaskEntity>> getTasks({AgentTaskStatus? status});
  Future<AgentTaskEntity> updateTaskStatus(String taskId, AgentTaskStatus newStatus);
  Future<List<AgentCustomerEntity>> getCustomers({String? query});
  Future<List<AgentCollectionEntity>> getCollections();
  Future<AgentCollectionEntity> recordCollection({
    required String collectionId,
    required double amountCollected,
    required String paymentMode,
  });
}

