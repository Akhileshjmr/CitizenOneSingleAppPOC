import 'package:citizenone_app/features/agent/tasks/domain/entities/agent_task_detail_entity.dart';
import 'package:citizenone_app/features/agent/tasks/domain/repositories/agent_tasks_repository.dart';

class AgentTasksRepositoryImpl implements AgentTasksRepository {
  @override
  Future<List<AgentTaskDetailEntity>> getAllTasks() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockTasks;
  }

  @override
  Future<bool> markTaskComplete(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }
}

const _mockTasks = [
  AgentTaskDetailEntity(
    id: 'task_001',
    title: 'KYC Verification',
    description: 'Complete KYC documents review and approval.',
    type: AgentTaskType.kyc,
    status: AgentTaskStatus.pending,
    customerName: 'Mary Banda',
    dueDate: 'Today, 3:00 PM',
    location: 'Sector 4, Lusaka',
  ),
  AgentTaskDetailEntity(
    id: 'task_002',
    title: 'New Merchant Onboarding',
    description: 'Register merchant on CitizenOne platform.',
    type: AgentTaskType.onboarding,
    status: AgentTaskStatus.pending,
    customerName: 'Chanda Mwale',
    dueDate: 'Today, 5:00 PM',
    location: 'Kabulonga, Lusaka',
  ),
  AgentTaskDetailEntity(
    id: 'task_003',
    title: 'Loan Repayment Collection',
    description: 'Collect ZK 12,000 monthly loan instalment.',
    type: AgentTaskType.collection,
    status: AgentTaskStatus.pending,
    customerName: 'Green Grocers Ltd',
    dueDate: 'Today, 2:00 PM',
    amount: 'ZK 12,000',
    location: 'Cairo Road, Lusaka',
  ),
  AgentTaskDetailEntity(
    id: 'task_004',
    title: 'Partner Bank Visit',
    description: 'Meet Zanaco branch manager for quarterly review.',
    type: AgentTaskType.partnerVisit,
    status: AgentTaskStatus.inProgress,
    customerName: 'Zanaco Bank',
    dueDate: 'Tomorrow, 10:00 AM',
    location: 'Zanaco HQ, Lusaka',
  ),
  AgentTaskDetailEntity(
    id: 'task_005',
    title: 'Merchant Onboarding',
    description: 'Second onboarding session — documents pending.',
    type: AgentTaskType.onboarding,
    status: AgentTaskStatus.inProgress,
    customerName: 'Bwalya Phiri',
    dueDate: 'Tomorrow, 1:00 PM',
    location: 'Chilenje, Lusaka',
  ),
  AgentTaskDetailEntity(
    id: 'task_006',
    title: 'KYC Approved',
    description: 'Documents verified and account activated.',
    type: AgentTaskType.kyc,
    status: AgentTaskStatus.completed,
    customerName: 'Ngosa Mulenga',
    dueDate: 'Yesterday',
    location: 'Woodlands, Lusaka',
  ),
];
