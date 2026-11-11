// =============================================================================
// DashboardMappers  —  PRESENTATION HELPERS
// -----------------------------------------------------------------------------
// Translate domain entities into design-system view-models. This is the
// only place feature-specific knowledge meets the design system. Doing it
// here means organisms stay generic and entities stay UI-free.
// =============================================================================

import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../design_system/organisms/notification_section.dart';
import '../../../../design_system/organisms/transaction_list_section.dart';
import '../../domain/entities/notification_item.dart';
import '../../domain/entities/transaction.dart';

class DashboardMappers {
  DashboardMappers._();

  static IconData iconForCategory(TransactionCategory c) {
    switch (c) {
      case TransactionCategory.groceries:
        return Icons.local_grocery_store_outlined;
      case TransactionCategory.restaurant:
        return Icons.restaurant_outlined;
      case TransactionCategory.transport:
        return Icons.directions_car_outlined;
      case TransactionCategory.utilities:
        return Icons.bolt_outlined;
      case TransactionCategory.payroll:
        return Icons.payments_outlined;
      case TransactionCategory.refund:
        return Icons.replay_outlined;
      case TransactionCategory.transfer:
        return Icons.swap_horiz_outlined;
      case TransactionCategory.shopping:
        return Icons.shopping_bag_outlined;
      case TransactionCategory.subscription:
        return Icons.subscriptions_outlined;
      case TransactionCategory.other:
        return Icons.receipt_long_outlined;
    }
  }

  static IconData iconForNotification(NotificationKind k) {
    switch (k) {
      case NotificationKind.transaction:
        return Icons.account_balance_wallet_outlined;
      case NotificationKind.security:
        return Icons.shield_outlined;
      case NotificationKind.promo:
        return Icons.campaign_outlined;
      case NotificationKind.system:
        return Icons.info_outline_rounded;
    }
  }

  static TransactionDisplay toTransactionDisplay(Transaction t) =>
      TransactionDisplay(
        id: t.id,
        title: t.title,
        subtitle: t.merchant,
        amountLabel: Formatters.currency(t.amount),
        dateLabel: Formatters.relativeDate(t.date),
        icon: iconForCategory(t.category),
        isCredit: t.isCredit,
      );

  static NotificationDisplay toNotificationDisplay(NotificationItem n) =>
      NotificationDisplay(
        id: n.id,
        title: n.title,
        message: n.message,
        timestampLabel: Formatters.relativeDate(n.createdAt),
        icon: iconForNotification(n.kind),
        isUnread: !n.isRead,
      );
}
