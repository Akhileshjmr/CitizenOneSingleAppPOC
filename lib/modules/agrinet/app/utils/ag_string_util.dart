class StringUtil {
  static String formatDate(int? millis) {
    if (millis == null) return '';
    final date = DateTime.fromMillisecondsSinceEpoch(millis);
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  /// Adds parentheses around the string if it is not null or empty.
  static String formatUnit(String? unit) {
    if (unit == null || unit.trim().isEmpty) return '';
    return ' ($unit)';
  }
}
