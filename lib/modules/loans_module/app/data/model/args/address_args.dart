/// Specifications for customer interest
class AddressDetailArgs {
  /// Specifications to open the PDF
  AddressDetailArgs({required this.isAddressList});

  /// request secure key
  final bool isAddressList;
}

class groceryDetailArgs {
  /// Specifications to open the PDF
  groceryDetailArgs({required this.isAddressList, required this.catagory});

  /// request secure key
  final bool isAddressList;
  final String catagory;
}

/// Specifications for customer interest
class AutoFilterArgs {
  /// Specifications to open the PDF
  AutoFilterArgs({
    required this.Manufacture,
    required this.FuelType,
    required this.bodyType,
    required this.MaxValue,
    required this.MinValue,
    required this.SortByType,
    required this.argType,
  });

  /// request secure key
  final List<String> Manufacture;
  final List<String> FuelType;
  final List<String> bodyType;
  final String MaxValue;
  final String MinValue;
  final String SortByType;
  final String argType;
}
