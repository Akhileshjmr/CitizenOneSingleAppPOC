import 'package:citizenone_app/features/agent/customers/domain/entities/agent_customer_entity.dart';

class AgentCustomersState {
  final bool isLoading;
  final List<AgentCustomerEntity> customers;
  final CustomerStatus? filterStatus;
  final String searchQuery;
  final String? errorMessage;

  const AgentCustomersState({
    this.isLoading = false,
    this.customers = const [],
    this.filterStatus,
    this.searchQuery = '',
    this.errorMessage,
  });

  List<AgentCustomerEntity> get filteredCustomers {
    var list = filterStatus == null
        ? customers
        : customers.where((c) => c.status == filterStatus).toList();
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list
          .where((c) =>
              c.name.toLowerCase().contains(q) ||
              c.phone.contains(q) ||
              (c.businessType?.toLowerCase().contains(q) ?? false))
          .toList();
    }
    return list;
  }

  AgentCustomersState copyWith({
    bool? isLoading,
    List<AgentCustomerEntity>? customers,
    CustomerStatus? filterStatus,
    bool clearFilter = false,
    String? searchQuery,
    String? errorMessage,
  }) {
    return AgentCustomersState(
      isLoading: isLoading ?? this.isLoading,
      customers: customers ?? this.customers,
      filterStatus: clearFilter ? null : (filterStatus ?? this.filterStatus),
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
