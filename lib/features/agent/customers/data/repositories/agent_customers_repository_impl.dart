import 'package:citizenone_app/features/agent/customers/domain/entities/agent_customer_entity.dart';
import 'package:citizenone_app/features/agent/customers/domain/repositories/agent_customers_repository.dart';

class AgentCustomersRepositoryImpl implements AgentCustomersRepository {
  @override
  Future<List<AgentCustomerEntity>> getAssignedCustomers() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockCustomers;
  }
}

const _mockCustomers = [
  AgentCustomerEntity(
    id: 'cust_001',
    name: 'Mary Banda',
    phone: '+260 97 123 4567',
    location: 'Sector 4, Lusaka',
    status: CustomerStatus.kycPending,
    assignedDate: '12 May 2025',
    businessType: 'Retail',
    accountId: 'CO-4829-A',
  ),
  AgentCustomerEntity(
    id: 'cust_002',
    name: 'Chanda Mwale',
    phone: '+260 96 234 5678',
    location: 'Kabulonga, Lusaka',
    status: CustomerStatus.onboarding,
    assignedDate: '10 May 2025',
    businessType: 'Food & Beverage',
  ),
  AgentCustomerEntity(
    id: 'cust_003',
    name: 'Green Grocers Ltd',
    phone: '+260 95 345 6789',
    location: 'Cairo Road, Lusaka',
    status: CustomerStatus.active,
    assignedDate: '02 Apr 2025',
    businessType: 'Wholesale',
    accountId: 'CO-3821-B',
  ),
  AgentCustomerEntity(
    id: 'cust_004',
    name: 'Bwalya Phiri',
    phone: '+260 97 456 7890',
    location: 'Chilenje, Lusaka',
    status: CustomerStatus.onboarding,
    assignedDate: '14 May 2025',
    businessType: 'Transport',
  ),
  AgentCustomerEntity(
    id: 'cust_005',
    name: 'Ngosa Mulenga',
    phone: '+260 96 567 8901',
    location: 'Woodlands, Lusaka',
    status: CustomerStatus.active,
    assignedDate: '20 Mar 2025',
    businessType: 'Pharmacy',
    accountId: 'CO-2741-C',
  ),
  AgentCustomerEntity(
    id: 'cust_006',
    name: 'Temwani Phiri',
    phone: '+260 95 678 9012',
    location: 'Mtendere, Lusaka',
    status: CustomerStatus.inactive,
    assignedDate: '15 Jan 2025',
    businessType: 'Salon',
    accountId: 'CO-1928-D',
  ),
];
