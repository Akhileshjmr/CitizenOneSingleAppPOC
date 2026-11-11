import 'package:intl/intl.dart';

enum Pages { deliveryTime, addAddress, summary }

// Helper extensions on DateTime
extension DateExt on DateTime {
  /// To get the date formatted in 18 Dec, 1996
  String get ddMMMyyyy => DateFormat('dd-MM-yyyy').format(this);

  /// To get the date formatted in 18 Dec, 1996
  String get ddMMyyyy => DateFormat('dd/MM/yyyy').format(this);

  /// To get the time formatted in 05:23 AM
  String get hhssjm => DateFormat.jm().format(this);
}

extension DateBirth on DateTime {
  /// To get the date formatted in 18 Dec, 1996
  String get ddMMM => DateFormat('dd-MMM').format(this);

  /// To get the time formatted in 05:23 AM
  String get hhssjmm => DateFormat.jm().format(this);
}

// Helper extensions on DateTime
extension DateExtInSec on DateTime {
  /// To get the date formatted in 18 Dec, 1996 12:23
  String get ddMMyyyyhhss => DateFormat('dd-MM-yyyy hh:ss').format(this);
}

extension DateEx on DateTime {
  /// To get the date formatted in 18 Dec, 1996
  String get yyyyMMMdd => DateFormat('yyyy-MM-dd').format(this);

  String get EddMMM => DateFormat('E, dd MMM').format(this);
}

extension DateBook on DateTime {
  /// To get the date formatted in 18 Dec, 1996
  String get EEEEddMMMyyyy => DateFormat('dd MMM yyyy').format(this);

  ///EE, dd MMM yy
}
