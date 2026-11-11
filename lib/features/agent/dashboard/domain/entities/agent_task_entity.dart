/// Agent-specific task entity.
/// Lives in the domain layer — no Flutter, no external dependencies.
class AgentTaskEntity {
  final String id;
  final String title;
  final String subtitle;
  final AgentTaskType type;
  final AgentTaskStatus status;

  const AgentTaskEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.status,
  });
}

enum AgentTaskType { onboarding, collection, kyc, partnerVisit }

enum AgentTaskStatus { pending, inProgress, completed }
