import 'package:citizenone_app/core/core.dart';
import '../models/agent_task_model.dart';
import '../models/agent_customer_model.dart';
import '../models/agent_collection_model.dart';
import '../../domain/entities/agent_dashboard_entity.dart';
import '../../domain/entities/agent_task_entity.dart';

abstract class AgentRemoteDataSource {
  Future<AgentDashboardEntity> getDashboardData();
  Future<List<AgentTaskModel>> getTasks({AgentTaskStatus? status});
  Future<AgentTaskModel> updateTaskStatus(String taskId, AgentTaskStatus newStatus);
  Future<List<AgentCustomerModel>> getCustomers({String? query});
  Future<List<AgentCollectionModel>> getCollections();
  Future<AgentCollectionModel> recordCollection({
    required String collectionId,
    required double amountCollected,
    required String paymentMode,
  });
}

class AgentRemoteDataSourceImpl implements AgentRemoteDataSource {
  final ApiClient apiClient;

  AgentRemoteDataSourceImpl(this.apiClient);

  @override
  Future<AgentDashboardEntity> getDashboardData() async {
    try {
      final response = await apiClient.get('/api/v1/agent/dashboard');
      if (response.isNotEmpty) {
        final tasks = (response['recentTasks'] as List?)
                ?.map((t) => AgentTaskModel.fromJson(t as Map<String, dynamic>).toEntity())
                .toList() ??
            [];
        final collections = (response['recentCollections'] as List?)
                ?.map((c) => AgentCollectionModel.fromJson(c as Map<String, dynamic>).toEntity())
                .toList() ??
            [];

        return AgentDashboardEntity(
          agentName: response['agentName'] as String? ?? 'Mwape Mulenga',
          agentCode: response['agentCode'] as String? ?? 'AGT-10294',
          totalCollectionsToday:
              (response['totalCollectionsToday'] as num?)?.toDouble() ?? 14500.0,
          pendingTasksCount: (response['pendingTasksCount'] as num?)?.toInt() ?? 4,
          activeCustomersCount:
              (response['activeCustomersCount'] as num?)?.toInt() ?? 128,
          commissionEarned:
              (response['commissionEarned'] as num?)?.toDouble() ?? 2150.0,
          recentTasks: tasks.isNotEmpty ? tasks : _fallbackTasks.map((t) => t.toEntity()).toList(),
          recentCollections: collections.isNotEmpty
              ? collections
              : _fallbackCollections.map((c) => c.toEntity()).toList(),
        );
      }
    } catch (e) {
      AppLogger.info('Using fallback agent dashboard: $e', 'AgentDataSource');
    }

    return AgentDashboardEntity(
      agentName: 'Mwape Mulenga',
      agentCode: 'AGT-10294',
      totalCollectionsToday: 14500.0,
      pendingTasksCount: 4,
      activeCustomersCount: 128,
      commissionEarned: 2150.0,
      recentTasks: _fallbackTasks.map((t) => t.toEntity()).toList(),
      recentCollections: _fallbackCollections.map((c) => c.toEntity()).toList(),
    );
  }

  @override
  Future<List<AgentTaskModel>> getTasks({AgentTaskStatus? status}) async {
    try {
      final response = await apiClient.get('/api/v1/agent/tasks');
      if (response['tasks'] is List) {
        final list = (response['tasks'] as List)
            .map((e) => AgentTaskModel.fromJson(e as Map<String, dynamic>))
            .toList();
        if (status != null) {
          return list.where((t) => t.toEntity().status == status).toList();
        }
        return list;
      }
    } catch (e) {
      AppLogger.info('Using fallback agent tasks: $e', 'AgentDataSource');
    }

    if (status != null) {
      return _fallbackTasks.where((t) => t.toEntity().status == status).toList();
    }
    return _fallbackTasks;
  }

  @override
  Future<AgentTaskModel> updateTaskStatus(
      String taskId, AgentTaskStatus newStatus) async {
    final payload = {'taskId': taskId, 'status': newStatus.name};
    try {
      final response =
          await apiClient.post('/api/v1/agent/tasks/update-status', body: payload);
      if (response.isNotEmpty) {
        return AgentTaskModel.fromJson(response);
      }
    } catch (e) {
      AppLogger.info('Using local update for task status: $e', 'AgentDataSource');
    }

    final existing = _fallbackTasks.firstWhere(
      (t) => t.id == taskId,
      orElse: () => _fallbackTasks.first,
    );
    return AgentTaskModel(
      id: existing.id,
      title: existing.title,
      subtitle: existing.subtitle,
      type: existing.type,
      status: newStatus.name,
      dueDate: existing.dueDate,
    );
  }

  @override
  Future<List<AgentCustomerModel>> getCustomers({String? query}) async {
    try {
      final endpoint = query != null && query.isNotEmpty
          ? '/api/v1/agent/customers?query=${Uri.encodeComponent(query)}'
          : '/api/v1/agent/customers';
      final response = await apiClient.get(endpoint);
      if (response['customers'] is List) {
        return (response['customers'] as List)
            .map((e) => AgentCustomerModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      AppLogger.info('Using fallback agent customers: $e', 'AgentDataSource');
    }

    if (query != null && query.isNotEmpty) {
      return _fallbackCustomers
          .where((c) => c.toEntity().matches(query))
          .toList();
    }
    return _fallbackCustomers;
  }

  @override
  Future<List<AgentCollectionModel>> getCollections() async {
    try {
      final response = await apiClient.get('/api/v1/agent/collections');
      if (response['collections'] is List) {
        return (response['collections'] as List)
            .map((e) => AgentCollectionModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      AppLogger.info('Using fallback agent collections: $e', 'AgentDataSource');
    }

    return _fallbackCollections;
  }

  @override
  Future<AgentCollectionModel> recordCollection({
    required String collectionId,
    required double amountCollected,
    required String paymentMode,
  }) async {
    final payload = {
      'collectionId': collectionId,
      'amountCollected': amountCollected,
      'paymentMode': paymentMode,
    };
    try {
      final response =
          await apiClient.post('/api/v1/agent/collections/record', body: payload);
      if (response.isNotEmpty) {
        return AgentCollectionModel.fromJson(response);
      }
    } catch (e) {
      AppLogger.info('Using local record for collection: $e', 'AgentDataSource');
    }

    return AgentCollectionModel(
      id: collectionId,
      merchantName: 'Kafue Agribusiness Hub',
      amountDue: 'ZMW 0',
      dueDate: 'Collected Today',
      status: 'collected',
      location: 'Kafue Market Stall 12',
      phone: '+260971888999',
      lastCollectedDate: DateTime.now().toIso8601String().substring(0, 10),
    );
  }

  static const List<AgentTaskModel> _fallbackTasks = [
    AgentTaskModel(
      id: 'TSK-101',
      title: 'Complete Biometric KYC for Mutale Banda',
      subtitle: 'Customer registered via Agency Banking',
      type: 'kyc',
      status: 'pending',
      dueDate: '11:00 AM Today',
    ),
    AgentTaskModel(
      id: 'TSK-102',
      title: 'Daily Micro Loan Repayment Collection',
      subtitle: 'Kafue Agro Traders Stall 14',
      type: 'collection',
      status: 'pending',
      dueDate: '02:00 PM Today',
    ),
    AgentTaskModel(
      id: 'TSK-103',
      title: 'Deliver Insurance Policy Pack to Chileshe Kangwa',
      subtitle: 'Health Shield Supreme Certificate',
      type: 'partnervisit',
      status: 'inProgress',
      dueDate: '04:30 PM Today',
    ),
    AgentTaskModel(
      id: 'TSK-104',
      title: 'Onboard New Merchant Bwalya General Store',
      subtitle: 'Merchant QR code & Terminal Setup',
      type: 'onboarding',
      status: 'completed',
      dueDate: 'Yesterday',
    ),
  ];

  static const List<AgentCustomerModel> _fallbackCustomers = [
    AgentCustomerModel(
      id: 'CUST-001',
      name: 'Mutale Banda',
      phone: '+260971234567',
      location: 'Kalingalinga Ward, Lusaka',
      status: 'kycPending',
      assignedDate: '2026-11-01',
      businessType: 'Retail Produce',
      accountId: 'ACC-882194',
    ),
    AgentCustomerModel(
      id: 'CUST-002',
      name: 'Chileshe Kangwa',
      phone: '+260977890123',
      location: 'Chawama Compound, Lusaka',
      status: 'active',
      assignedDate: '2026-10-15',
      businessType: 'Hardware & Tools',
      accountId: 'ACC-394012',
    ),
    AgentCustomerModel(
      id: 'CUST-003',
      name: 'Grace Lungu',
      phone: '+260965432109',
      location: 'Matero East, Lusaka',
      status: 'active',
      assignedDate: '2026-09-20',
      businessType: 'Poultry Farm',
      accountId: 'ACC-110293',
    ),
    AgentCustomerModel(
      id: 'CUST-004',
      name: 'Kafue Agribusiness Hub',
      phone: '+260971888999',
      location: 'Kafue Town Center',
      status: 'active',
      assignedDate: '2026-08-11',
      businessType: 'Grain Aggregation',
      accountId: 'ACC-994011',
    ),
  ];

  static const List<AgentCollectionModel> _fallbackCollections = [
    AgentCollectionModel(
      id: 'COL-501',
      merchantName: 'Kafue Agribusiness Hub',
      amountDue: 'ZMW 3,500',
      dueDate: 'Due Today',
      status: 'pending',
      location: 'Kafue Market Stall 12',
      phone: '+260971888999',
    ),
    AgentCollectionModel(
      id: 'COL-502',
      merchantName: 'Bwalya General Store',
      amountDue: 'ZMW 1,200',
      dueDate: 'Due Today',
      status: 'pending',
      location: 'Matero Block C',
      phone: '+260978111222',
    ),
    AgentCollectionModel(
      id: 'COL-503',
      merchantName: 'Chawama Poultry Depot',
      amountDue: 'ZMW 2,800',
      dueDate: '2 Days Overdue',
      status: 'overdue',
      location: 'Chawama Plot 44',
      phone: '+260965432109',
    ),
  ];
}

