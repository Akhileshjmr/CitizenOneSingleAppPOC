import 'package:citizenone_app/features/agent/dashboard/domain/entities/agent_insight_entity.dart';
import 'package:citizenone_app/features/agent/dashboard/domain/repositories/agent_dashboard_repository.dart';

/// Use case: Fetch AI-driven insights for the agent dashboard.
/// Single responsibility — one action per use case (ISP).
class GetAgentInsightsUseCase {
  final AgentDashboardRepository _repository;

  GetAgentInsightsUseCase(this._repository);

  Future<List<AgentInsightEntity>> call() {
    return _repository.getAiInsights();
  }
}
