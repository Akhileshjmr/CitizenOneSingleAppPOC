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
}
