enum CustomerStatus { active, kycPending, onboarding, inactive }

class AgentCustomerEntity {
  final String id;
  final String name;
  final String phone;
  final String location;
  final CustomerStatus status;
  final String assignedDate;
  final String? businessType;
  final String? accountId;

  const AgentCustomerEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.location,
    required this.status,
    required this.assignedDate,
    this.businessType,
    this.accountId,
  });

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return name.toLowerCase().contains(q) ||
        phone.contains(q) ||
        location.toLowerCase().contains(q) ||
        (accountId != null && accountId!.toLowerCase().contains(q));
  }
}

