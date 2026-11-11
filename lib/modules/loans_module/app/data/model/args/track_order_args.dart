/// Specifications for customer interest
class TrackOrderArgs {

  /// Specifications to open the PDF
  TrackOrderArgs({
    required this.key,
    required this.categoryType,
    required this.isLoanStatus,
  });

  /// request secure key
  final String key;
  final String categoryType;
  final bool isLoanStatus;
}