enum AgentTaskType { onboarding, collection, kyc, partnerVisit }
enum AgentTaskStatus { pending, inProgress, completed }

class AgentTaskEntity {
  final String id;
  final String title;
  final String subtitle;
  final AgentTaskType type;
  final AgentTaskStatus status;
  final String dueDate;

  const AgentTaskEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.status,
    this.dueDate = 'Today',
  });

  AgentTaskEntity copyWith({
    String? id,
    String? title,
    String? subtitle,
    AgentTaskType? type,
    AgentTaskStatus? status,
    String? dueDate,
  }) {
    return AgentTaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      type: type ?? this.type,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}

