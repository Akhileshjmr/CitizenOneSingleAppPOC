import '../../domain/entities/agent_dashboard_entity.dart';
import '../../domain/entities/agent_task_entity.dart';
import '../../domain/entities/agent_customer_entity.dart';
import '../../domain/entities/agent_collection_entity.dart';
import '../../domain/repositories/agent_repository.dart';
import '../datasources/agent_remote_datasource.dart';

class AgentRepositoryImpl implements AgentRepository {
  final AgentRemoteDataSource remoteDataSource;

  AgentRepositoryImpl(this.remoteDataSource);

  @override
  Future<AgentDashboardEntity> getDashboardData() {
    return remoteDataSource.getDashboardData();
  }

  @override
  Future<List<AgentTaskEntity>> getTasks({AgentTaskStatus? status}) async {
    final models = await remoteDataSource.getTasks(status: status);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<AgentTaskEntity> updateTaskStatus(
      String taskId, AgentTaskStatus newStatus) async {
    final model = await remoteDataSource.updateTaskStatus(taskId, newStatus);
    return model.toEntity();
  }

  @override
  Future<List<AgentCustomerEntity>> getCustomers({String? query}) async {
    final models = await remoteDataSource.getCustomers(query: query);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<AgentCollectionEntity>> getCollections() async {
    final models = await remoteDataSource.getCollections();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<AgentCollectionEntity> recordCollection({
    required String collectionId,
    required double amountCollected,
    required String paymentMode,
  }) async {
    final model = await remoteDataSource.recordCollection(
      collectionId: collectionId,
      amountCollected: amountCollected,
      paymentMode: paymentMode,
    );
    return model.toEntity();
  }
}

