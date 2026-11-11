import 'package:intl/intl.dart';

/// Datetime Extensions
extension DateTimeExtenstionS on DateTime {

  String get ddMMYYYYSuffix => DateFormat('dd/MM/yyyy').format(this);

  int get age {
    final DateTime currentDate = DateTime.now();
    int age = currentDate.year - year;
    final int month1 = currentDate.month;
    final int month2 = month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      final int day1 = currentDate.day;
      final int day2 = day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }


  String get dayName => DateFormat('EEE').format(this);

  String get ddMMSuffix => DateFormat('dd MMM').format(this);

  String get yyyyMMDDTTsuffix => DateFormat('yyyy-MM-dd').format(this);


  /// To get the date formatted in 18 Dec, 1996
  String get ddMMMyyyy => DateFormat('dd MMM, yyyy').format(this);

  String get getMonthYear => DateFormat('MMM, yyyy').format(this);

  String get getMonthName => DateFormat('MMMM').format(this);

  String get dd_MM_yyyy => DateFormat('dd-MM-yyyy').format(this);

  String get weekName => DateFormat('EEE').format(this);

  String get ddDay => DateFormat('dd').format(this);

  String get dateWithTime => DateFormat('yyyy-MM-dd HH:mm:ss.sss').format(this);

  String get mmmYYYY => DateFormat('MMMM yyyy').format(this);

  String get dateWithNoTime => DateFormat('yyyy-MM-dd 00:00:00.000').format(this);

  String get cDDMMMYYYY => DateFormat('dd MMM yyyy').format(this);


}
