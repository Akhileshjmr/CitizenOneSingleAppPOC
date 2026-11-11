enum AgentTaskType { onboarding, collection, kyc, partnerVisit }

enum AgentTaskStatus { pending, inProgress, completed }

class AgentTaskDetailEntity {
  final String id;
  final String title;
  final String description;
  final AgentTaskType type;
  final AgentTaskStatus status;
  final String customerName;
  final String dueDate;
  final String? amount;
  final String? location;

  const AgentTaskDetailEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.customerName,
    required this.dueDate,
    this.amount,
    this.location,
  });
}
