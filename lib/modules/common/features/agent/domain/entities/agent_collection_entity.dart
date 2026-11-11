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

  AgentCollectionEntity copyWith({
    String? id,
    String? merchantName,
    String? amountDue,
    String? dueDate,
    CollectionStatus? status,
    String? location,
    String? phone,
    String? lastCollectedDate,
  }) {
    return AgentCollectionEntity(
      id: id ?? this.id,
      merchantName: merchantName ?? this.merchantName,
      amountDue: amountDue ?? this.amountDue,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      lastCollectedDate: lastCollectedDate ?? this.lastCollectedDate,
    );
  }
}

