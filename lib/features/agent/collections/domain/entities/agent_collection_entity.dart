enum CollectionStatus { pending, overdue, collected }

class AgentCollectionEntity {
  final String id;
  final String merchantName;
  final String amountDue;
  final String dueDate;
  final CollectionStatus status;
  final String location;
  final String? phone;
  final String? lastCollectedDate;

  const AgentCollectionEntity({
    required this.id,
    required this.merchantName,
    required this.amountDue,
    required this.dueDate,
    required this.status,
    required this.location,
    this.phone,
    this.lastCollectedDate,
  });
}
