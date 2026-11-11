// =============================================================================
// DashboardLocalDatasource  —  DATA LAYER
// -----------------------------------------------------------------------------
// In a real app this might be a SQLite-backed cache. For the POC it's an
// in-memory generator producing realistic dummy banking data. The interface
// is what matters — swapping to a real implementation requires zero use
// case or BLoC changes.
// =============================================================================

import '../models/bank_account_model.dart';
import '../models/dashboard_snapshot_model.dart';
import '../models/notification_item_model.dart';
import '../models/transaction_model.dart';
import '../models/user_profile_model.dart';

abstract class DashboardLocalDatasource {
  Future<DashboardSnapshotModel> getSnapshot();
}

class DashboardLocalDatasourceImpl implements DashboardLocalDatasource {
  const DashboardLocalDatasourceImpl();

  @override
  Future<DashboardSnapshotModel> getSnapshot() async {
    // Simulate network/disk latency so loading skeletons get a chance to render.
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final now = DateTime.now();

    const user = UserProfileModel(
      id: 'usr_001',
      fullName: 'Akhilesh Singh',
      email: 'akhilesh@bankalpha.com',
      phone: '+1 415 555 0142',
      avatarUrl: null,
    );

    final accounts = <BankAccountModel>[
      BankAccountModel(
        id: 'acc_001',
        label: 'Everyday Checking',
        accountNumber: '4429 8821 0033 7711',
        type: 'checking',
        balance: 12480.42,
        currency: 'USD',
      ),
      BankAccountModel(
        id: 'acc_002',
        label: 'Wealth Savings',
        accountNumber: '5510 4421 8819 0042',
        type: 'savings',
        balance: 56250.18,
        currency: 'USD',
      ),
      BankAccountModel(
        id: 'acc_003',
        label: 'Platinum Card',
        accountNumber: '4111 1111 1111 4429',
        type: 'credit',
        balance: -842.95,
        currency: 'USD',
      ),
    ];

    final transactions = <TransactionModel>[
      TransactionModel(
        id: 'tx_101',
        title: 'Whole Foods Market',
        merchant: 'Whole Foods',
        amount: 84.20,
        currency: 'USD',
        date: now.subtract(const Duration(hours: 2)),
        category: 'groceries',
        status: 'settled',
        isCredit: false,
        accountId: 'acc_001',
        reference: 'POS-77821',
      ),
      TransactionModel(
        id: 'tx_102',
        title: 'Salary — May',
        merchant: 'CitizenOne Payroll',
        amount: 5400.00,
        currency: 'USD',
        date: now.subtract(const Duration(days: 1, hours: 6)),
        category: 'payroll',
        status: 'settled',
        isCredit: true,
        accountId: 'acc_001',
        reference: 'PAY-2026-05',
      ),
      TransactionModel(
        id: 'tx_103',
        title: 'Uber Ride',
        merchant: 'Uber',
        amount: 18.74,
        currency: 'USD',
        date: now.subtract(const Duration(days: 1, hours: 19)),
        category: 'transport',
        status: 'settled',
        isCredit: false,
        accountId: 'acc_001',
      ),
      TransactionModel(
        id: 'tx_104',
        title: 'Netflix Subscription',
        merchant: 'Netflix',
        amount: 17.99,
        currency: 'USD',
        date: now.subtract(const Duration(days: 2, hours: 4)),
        category: 'subscription',
        status: 'settled',
        isCredit: false,
        accountId: 'acc_001',
      ),
      TransactionModel(
        id: 'tx_105',
        title: 'PG&E Utility Bill',
        merchant: 'Pacific Gas & Electric',
        amount: 134.50,
        currency: 'USD',
        date: now.subtract(const Duration(days: 3)),
        category: 'utilities',
        status: 'pending',
        isCredit: false,
        accountId: 'acc_001',
      ),
      TransactionModel(
        id: 'tx_106',
        title: 'Amazon Refund',
        merchant: 'Amazon',
        amount: 42.00,
        currency: 'USD',
        date: now.subtract(const Duration(days: 4)),
        category: 'refund',
        status: 'settled',
        isCredit: true,
        accountId: 'acc_001',
      ),
    ];

    final notifications = <NotificationItemModel>[
      NotificationItemModel(
        id: 'ntf_201',
        title: 'Salary credited',
        message: 'Your May salary of \$5,400.00 has been credited.',
        createdAt: now.subtract(const Duration(hours: 30)),
        kind: 'transaction',
        isRead: false,
      ),
      NotificationItemModel(
        id: 'ntf_202',
        title: 'New device sign-in',
        message: 'A new sign-in was detected from MacBook Pro · San Francisco.',
        createdAt: now.subtract(const Duration(hours: 6)),
        kind: 'security',
        isRead: false,
      ),
      NotificationItemModel(
        id: 'ntf_203',
        title: 'Statement ready',
        message: 'Your April statement for Everyday Checking is available.',
        createdAt: now.subtract(const Duration(days: 2)),
        kind: 'system',
        isRead: true,
      ),
    ];

    return DashboardSnapshotModel(
      user: user,
      primaryAccount: accounts.first,
      accounts: accounts,
      recentTransactions: transactions,
      notifications: notifications,
      lastSyncedAt: now,
    );
  }
}
