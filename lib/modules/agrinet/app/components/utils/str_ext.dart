import 'package:intl/intl.dart';

import '../../data/remote/api_service/init_api_service.dart';

/// String Extension
extension StringExtenstion on String? {
  /// Add Image Url
  String get addBaseUrl => '${APIService.imageBaseUrl}$this';
}

extension StringExt on String {
  ///
  bool get isPhone {
    if (length > 16 || length < 9) {
      return false;
    }

    final RegExp phone = RegExp(r'^\+?\d{0,3}\d{9,16}$');
    return phone.hasMatch(this ?? '');
  }

  ///
  bool get areAllCharactersZero {
    for (int i = 0; i < length; i++) {
      if (this[i] != '0') {
        return false;
      }
    }
    return true;
  }
}

class DateUt {
  static String convertTimestampToDate(
    int timestamp, {
    String format = 'dd/MM/yyyy',
  }) {
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final formatter = DateFormat(format);
      return formatter.format(date);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  static String formatDateTime(
    DateTime dateTime, {
    String format = 'dd/MM/yyyy',
  }) {
    final formatter = DateFormat(format);
    return formatter.format(dateTime);
  }
}
