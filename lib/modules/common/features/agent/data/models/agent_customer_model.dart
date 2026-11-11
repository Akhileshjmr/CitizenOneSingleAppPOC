import '../../domain/entities/agent_customer_entity.dart';

class AgentCustomerModel {
  final String id;
  final String name;
  final String phone;
  final String location;
  final String status;
  final String assignedDate;
  final String? businessType;
  final String? accountId;

  const AgentCustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.location,
    required this.status,
    required this.assignedDate,
    this.businessType,
    this.accountId,
  });

  factory AgentCustomerModel.fromJson(Map<String, dynamic> json) {
    return AgentCustomerModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      location: json['location'] as String? ?? '',
      status: json['status'] as String? ?? 'active',
      assignedDate: json['assignedDate'] as String? ?? '',
      businessType: json['businessType'] as String?,
      accountId: json['accountId'] as String?,
    );
  }

  AgentCustomerEntity toEntity() {
    CustomerStatus parsedStatus;
    switch (status.toLowerCase()) {
      case 'kycpending':
      case 'kyc_pending':
        parsedStatus = CustomerStatus.kycPending;
        break;
      case 'onboarding':
        parsedStatus = CustomerStatus.onboarding;
        break;
      case 'inactive':
        parsedStatus = CustomerStatus.inactive;
        break;
      default:
        parsedStatus = CustomerStatus.active;
    }

    return AgentCustomerEntity(
      id: id,
      name: name,
      phone: phone,
      location: location,
      status: parsedStatus,
      assignedDate: assignedDate,
      businessType: businessType,
      accountId: accountId,
    );
  }
}

