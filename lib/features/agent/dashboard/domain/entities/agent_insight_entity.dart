/// Agent AI insight entity.
/// Lives in the domain layer — no Flutter, no external dependencies.
class AgentInsightEntity {
  final String id;
  final String title;
  final String description;
  final String actionLabel;
  final AgentInsightType type;

  const AgentInsightEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.type,
  });
}

enum AgentInsightType { highDemand, pendingCollection, kycAlert, salesOpportunity }
