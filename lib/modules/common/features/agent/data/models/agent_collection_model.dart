import '../../domain/entities/agent_collection_entity.dart';

class AgentCollectionModel {
  final String id;
  final String merchantName;
  final String amountDue;
  final String dueDate;
  final String status;
  final String location;
  final String? phone;
  final String? lastCollectedDate;

  const AgentCollectionModel({
    required this.id,
    required this.merchantName,
    required this.amountDue,
    required this.dueDate,
    required this.status,
    required this.location,
    this.phone,
    this.lastCollectedDate,
  });

  factory AgentCollectionModel.fromJson(Map<String, dynamic> json) {
    return AgentCollectionModel(
      id: json['id']?.toString() ?? '',
      merchantName: json['merchantName'] as String? ?? '',
      amountDue: json['amountDue'] as String? ?? '',
      dueDate: json['dueDate'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      location: json['location'] as String? ?? '',
      phone: json['phone'] as String?,
      lastCollectedDate: json['lastCollectedDate'] as String?,
    );
  }

  AgentCollectionEntity toEntity() {
    CollectionStatus parsedStatus;
    switch (status.toLowerCase()) {
      case 'overdue':
        parsedStatus = CollectionStatus.overdue;
        break;
      case 'collected':
        parsedStatus = CollectionStatus.collected;
        break;
      default:
        parsedStatus = CollectionStatus.pending;
    }

    return AgentCollectionEntity(
      id: id,
      merchantName: merchantName,
      amountDue: amountDue,
      dueDate: dueDate,
      status: parsedStatus,
      location: location,
      phone: phone,
      lastCollectedDate: lastCollectedDate,
    );
  }
}

