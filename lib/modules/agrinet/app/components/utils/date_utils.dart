class DateFormatter {
  /// Converts timestamp → DD/MM/YYYY
  static String ddMMyyyy(int? millis) {
    if (millis == null || millis == 0) return "";

    final date = DateTime.fromMillisecondsSinceEpoch(millis);

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;

    return "$day/$month/$year";
  }

  /// Converts DateTime → DD/MM/YYYY
  static String fromDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;

    return "$day/$month/$year";
  }
}
