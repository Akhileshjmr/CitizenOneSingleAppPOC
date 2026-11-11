// Aggregate domain entity returned by GetDashboardSnapshot.
import 'package:equatable/equatable.dart';
import 'bank_account.dart';
import 'notification_item.dart';
import 'transaction.dart';
import 'user_profile.dart';

class DashboardSnapshot extends Equatable {
  const DashboardSnapshot({
    required this.user,
    required this.primaryAccount,
    required this.accounts,
    required this.recentTransactions,
    required this.notifications,
    required this.lastSyncedAt,
  });

  final UserProfile user;
  final BankAccount primaryAccount;
  final List<BankAccount> accounts;
  final List<Transaction> recentTransactions;
  final List<NotificationItem> notifications;
  final DateTime lastSyncedAt;

  int get unreadNotificationCount =>
      notifications.where((n) => !n.isRead).length;

  @override
  List<Object?> get props => [
        user,
        primaryAccount,
        accounts,
        recentTransactions,
        notifications,
        lastSyncedAt,
      ];
}
