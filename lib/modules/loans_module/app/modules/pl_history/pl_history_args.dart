enum PlHistoryType {
  loggedInCustomer,
  customerPhoneSearch,
  agentPhoneSearch,
}

class PlHistoryArgs {
  final PlHistoryType historyType;
  final String? customerPhoneNumber;
  final String? agentPhoneNumber;

  PlHistoryArgs({
    required this.historyType,
    this.customerPhoneNumber,
    this.agentPhoneNumber,
  });
}
