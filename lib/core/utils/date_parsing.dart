/// Parses the agent user service's date strings, which are usually
/// `"yyyy-MM-dd HH:mm:ss"` but occasionally arrive as ISO-8601. Returns
/// `null` for empty/unparseable input rather than throwing.
DateTime? parseFlexibleDate(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  final iso = DateTime.tryParse(raw);
  if (iso != null) return iso;

  final parts = raw.split(' ');
  if (parts.length != 2) return null;
  final dateParts = parts[0].split('-');
  final timeParts = parts[1].split(':');
  if (dateParts.length != 3 || timeParts.length < 2) return null;

  return DateTime(
    int.parse(dateParts[0]),
    int.parse(dateParts[1]),
    int.parse(dateParts[2]),
    int.parse(timeParts[0]),
    int.parse(timeParts[1]),
    timeParts.length > 2 ? int.parse(timeParts[2]) : 0,
  );
}
