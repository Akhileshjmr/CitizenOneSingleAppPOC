class Formatter {
  static String formatNationalId(String value) {
  final raw = value.replaceAll('/', '');

  if (raw.length <= 6) return raw;
  if (raw.length <= 8) {
    return '${raw.substring(0, 6)}/${raw.substring(6)}';
  }

  return '${raw.substring(0, 6)}/${raw.substring(6, 8)}/${raw.substring(8)}';
}
}