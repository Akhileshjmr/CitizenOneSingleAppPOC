// =============================================================================
// Formatters  —  Display helpers (currency, dates, masking)
// -----------------------------------------------------------------------------
// Pure utility — no widgets. Consumed by molecules (BalanceCard,
// AmountInputField) and presentation pages.
// =============================================================================

import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static String currency(num value, {String symbol = '\$', int decimals = 2}) {
    final f = NumberFormat.currency(symbol: symbol, decimalDigits: decimals);
    return f.format(value);
  }

  static String compactCurrency(num value, {String symbol = '\$'}) {
    final f = NumberFormat.compactCurrency(symbol: symbol, decimalDigits: 1);
    return f.format(value);
  }

  static String maskAccount(String account) {
    if (account.length <= 4) return account;
    final tail = account.substring(account.length - 4);
    return '•••• $tail';
  }

  static String relativeDate(DateTime when, {DateTime? now}) {
    final n = now ?? DateTime.now();
    final diff = n.difference(when);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat.yMMMd().format(when);
  }

  static String fullDate(DateTime when) =>
      DateFormat('MMM d, y • h:mm a').format(when);
}
