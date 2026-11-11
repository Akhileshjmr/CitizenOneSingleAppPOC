import 'package:flutter_test/flutter_test.dart';
import 'package:citizenone_app/core/core.dart';
import 'package:citizenone_app/modules/common/common_module.dart';
import 'package:citizenone_app/modules/common/features/agent/domain/entities/agent_task_entity.dart';
import 'package:citizenone_app/modules/common/features/agent/domain/usecases/get_agent_dashboard_usecase.dart';
import 'package:citizenone_app/modules/common/features/agent/domain/usecases/get_agent_tasks_usecase.dart';
import 'package:citizenone_app/modules/common/features/agent/domain/usecases/get_agent_customers_usecase.dart';
import 'package:citizenone_app/modules/common/features/agent/domain/usecases/get_agent_collections_usecase.dart';
import 'package:citizenone_app/modules/common/features/agent/data/datasources/agent_remote_datasource.dart';
import 'package:citizenone_app/modules/common/features/agent/data/repositories/agent_repository_impl.dart';
import 'package:citizenone_app/modules/common/features/agent/presentation/cubits/agent_dashboard_cubit.dart';
import 'package:citizenone_app/modules/common/features/agent/presentation/cubits/agent_tasks_cubit.dart';
import 'package:citizenone_app/modules/common/features/agent/presentation/cubits/agent_customers_cubit.dart';
import 'package:citizenone_app/modules/common/features/agent/presentation/cubits/agent_collections_cubit.dart';

void main() {
  group('Agent Clean Architecture & Cubit Tests', () {
    late ApiClient apiClient;
    late AgentRemoteDataSource dataSource;
    late AgentRepositoryImpl repository;

    setUp(() {
      apiClient = ApiClient();
      dataSource = AgentRemoteDataSourceImpl(apiClient);
      repository = AgentRepositoryImpl(dataSource);
    });

    test('AgentDashboardCubit loads agent operations metrics successfully',
        () async {
      final useCase = GetAgentDashboardUseCase(repository);
      final cubit = AgentDashboardCubit(useCase);

      expect(cubit.state, isA<AgentDashboardInitial>());

      await cubit.loadDashboard();

      expect(cubit.state, isA<AgentDashboardLoaded>());
      final loaded = cubit.state as AgentDashboardLoaded;
      expect(loaded.dashboard.agentName, equals('Mwape Mulenga'));
      expect(loaded.dashboard.totalCollectionsToday, equals(14500.0));
      expect(loaded.dashboard.recentTasks.isNotEmpty, isTrue);
    });

    test('AgentTasksCubit loads and toggles task completion state', () async {
      final getUseCase = GetAgentTasksUseCase(repository);
      final updateUseCase = UpdateTaskStatusUseCase(repository);
      final cubit = AgentTasksCubit(
        getTasksUseCase: getUseCase,
        updateTaskStatusUseCase: updateUseCase,
      );

      await cubit.loadTasks();

      expect(cubit.state, isA<AgentTasksLoaded>());
      final initialTasks = (cubit.state as AgentTasksLoaded).tasks;
      expect(initialTasks.isNotEmpty, isTrue);

      final task = initialTasks.first;
      await cubit.toggleTaskStatus(task.id, task.status);

      final updatedTasks = (cubit.state as AgentTasksLoaded).tasks;
      final updatedTask = updatedTasks.firstWhere((t) => t.id == task.id);
      expect(updatedTask.status, equals(AgentTaskStatus.completed));
    });

    test('AgentCustomersCubit searches customers by name and query', () async {
      final useCase = GetAgentCustomersUseCase(repository);
      final cubit = AgentCustomersCubit(useCase);

      await cubit.loadCustomers();

      expect(cubit.state, isA<AgentCustomersLoaded>());
      final loaded = cubit.state as AgentCustomersLoaded;
      expect(loaded.customers.length, equals(4));

      cubit.searchCustomers('grace');
      final filtered = cubit.state as AgentCustomersLoaded;
      expect(filtered.filteredCustomers.length, equals(1));
      expect(filtered.filteredCustomers.first.name, contains('Grace'));
    });

    test('AgentCollectionsCubit records field collection successfully', () async {
      final getUseCase = GetAgentCollectionsUseCase(repository);
      final recordUseCase = RecordCollectionUseCase(repository);
      final cubit = AgentCollectionsCubit(
        getCollectionsUseCase: getUseCase,
        recordCollectionUseCase: recordUseCase,
      );

      await cubit.loadCollections();

      expect(cubit.state, isA<AgentCollectionsLoaded>());
      final collections = (cubit.state as AgentCollectionsLoaded).collections;
      expect(collections.isNotEmpty, isTrue);

      await cubit.recordCollection(
        collectionId: 'COL-501',
        amount: 3500.0,
        paymentMode: 'CASH',
      );

      expect(cubit.state, isA<AgentCollectionRecordSuccess>());
      final success = cubit.state as AgentCollectionRecordSuccess;
      expect(success.collection.id, equals('COL-501'));
    });

    test('CommonModule symmetrical session lifecycle teardown', () async {
      final module = CommonModule();
      module.initialize(apiClient: apiClient);

      expect(module.id, equals('common'));
      expect(module.routes.length, greaterThanOrEqualTo(7));

      // Trigger session logout
      module.onSessionStateChanged(false, null);
      // dispose executes cleanly
      await module.dispose();
    });
  });
}

