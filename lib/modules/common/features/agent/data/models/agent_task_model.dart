import '../../domain/entities/agent_task_entity.dart';

class AgentTaskModel {
  final String id;
  final String title;
  final String subtitle;
  final String type;
  final String status;
  final String dueDate;

  const AgentTaskModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.status,
    required this.dueDate,
  });

  factory AgentTaskModel.fromJson(Map<String, dynamic> json) {
    return AgentTaskModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      type: json['type'] as String? ?? 'onboarding',
      status: json['status'] as String? ?? 'pending',
      dueDate: json['dueDate'] as String? ?? 'Today',
    );
  }

  AgentTaskEntity toEntity() {
    AgentTaskType parsedType;
    switch (type.toLowerCase()) {
      case 'collection':
        parsedType = AgentTaskType.collection;
        break;
      case 'kyc':
        parsedType = AgentTaskType.kyc;
        break;
      case 'partnervisit':
      case 'partner_visit':
        parsedType = AgentTaskType.partnerVisit;
        break;
      default:
        parsedType = AgentTaskType.onboarding;
    }

    AgentTaskStatus parsedStatus;
    switch (status.toLowerCase()) {
      case 'inprogress':
      case 'in_progress':
        parsedStatus = AgentTaskStatus.inProgress;
        break;
      case 'completed':
        parsedStatus = AgentTaskStatus.completed;
        break;
      default:
        parsedStatus = AgentTaskStatus.pending;
    }

    return AgentTaskEntity(
      id: id,
      title: title,
      subtitle: subtitle,
      type: parsedType,
      status: parsedStatus,
      dueDate: dueDate,
    );
  }
}

