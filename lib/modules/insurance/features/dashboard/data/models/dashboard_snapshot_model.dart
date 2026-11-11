import '../../domain/entities/dashboard_snapshot.dart';
import 'bank_account_model.dart';
import 'notification_item_model.dart';
import 'transaction_model.dart';
import 'user_profile_model.dart';

class DashboardSnapshotModel extends DashboardSnapshot {
  const DashboardSnapshotModel({
    required UserProfileModel super.user,
    required BankAccountModel super.primaryAccount,
    required List<BankAccountModel> super.accounts,
    required List<TransactionModel> super.recentTransactions,
    required List<NotificationItemModel> super.notifications,
    required super.lastSyncedAt,
  });
}
