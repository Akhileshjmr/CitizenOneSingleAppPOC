import 'package:flutter/material.dart';
import 'package:citizenone_app/design_system/design_system.dart';

class AgencyTransactionsScreen extends StatefulWidget {
  const AgencyTransactionsScreen({super.key});

  @override
  State<AgencyTransactionsScreen> createState() => _AgencyTransactionsScreenState();
}

class _AgencyTransactionsScreenState extends State<AgencyTransactionsScreen> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _transactions = [
    {
      'id': 'TXN-DEP-88392',
      'type': 'Cash Deposit',
      'account': '1002938475',
      'customer': 'Mulenga Banda',
      'amount': '500.00',
      'fee': '5.00',
      'time': 'Today, 14:32',
      'status': 'COMPLETED',
      'isCredit': true,
    },
    {
      'id': 'TXN-WTH-88381',
      'type': 'Cash Withdrawal',
      'account': '1003847291',
      'customer': 'Chileshe Mwamba',
      'amount': '250.00',
      'fee': '7.50',
      'time': 'Today, 13:10',
      'status': 'COMPLETED',
      'isCredit': false,
    },
    {
      'id': 'TXN-DEP-88370',
      'type': 'Cash Deposit',
      'account': '1009948271',
      'customer': 'Grace Tembo',
      'amount': '1,200.00',
      'fee': '12.00',
      'time': 'Today, 11:45',
      'status': 'COMPLETED',
      'isCredit': true,
    },
    {
      'id': 'TXN-LON-88344',
      'type': 'Micro Loan Disbursal',
      'account': '1008837261',
      'customer': 'Moses Zulu',
      'amount': '3,500.00',
      'fee': '35.00',
      'time': 'Yesterday, 16:20',
      'status': 'COMPLETED',
      'isCredit': false,
    },
    {
      'id': 'TXN-WTH-88320',
      'type': 'Cash Withdrawal',
      'account': '1004738290',
      'customer': 'Patricia Phiri',
      'amount': '150.00',
      'fee': '5.00',
      'time': 'Yesterday, 10:15',
      'status': 'COMPLETED',
      'isCredit': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    final filteredList = _transactions.where((txn) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Deposits') return txn['type'].toString().contains('Deposit');
      if (_selectedFilter == 'Withdrawals') return txn['type'].toString().contains('Withdrawal');
      if (_selectedFilter == 'Loans') return txn['type'].toString().contains('Loan');
      return true;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Today\'s Commission', style: AppTypography.caption),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('SETTLED', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('ZMW 64.50', style: AppTypography.display.copyWith(color: primaryColor, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Terminal Volume: ZMW 5,600.00 across 5 transactions', style: AppTypography.caption),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Deposits', 'Withdrawals', 'Loans'].map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    selectedColor: primaryColor.withValues(alpha: 0.15),
                    labelStyle: TextStyle(
                      color: isSelected ? primaryColor : Colors.grey.shade700,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedFilter = filter);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Activity Audit Log (${filteredList.length})', style: AppTypography.subtitle.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.sm),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredList.length,
            separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final txn = filteredList[index];
              final isCredit = txn['isCredit'] as bool;
              return AppCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: isCredit ? Colors.green.shade50 : Colors.blue.shade50,
                    child: Icon(
                      isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                      color: isCredit ? Colors.green : Colors.blue,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    txn['type'] as String,
                    style: AppTypography.body.copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${txn['customer']} (A/C: ${txn['account']})', style: AppTypography.caption),
                      Text('${txn['id']} • ${txn['time']}', style: AppTypography.caption.copyWith(fontSize: 10)),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${isCredit ? '+' : '-'}ZMW ${txn['amount']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCredit ? Colors.green.shade700 : Colors.blue.shade700,
                        ),
                      ),
                      Text('Fee: ZMW ${txn['fee']}', style: AppTypography.caption.copyWith(fontSize: 10)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

