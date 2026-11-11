import 'package:citizenone_app/modules/agency_banking/data/models/AccountInfo.dart';
import 'package:citizenone_app/modules/agency_banking/widgets/dash_board_screen/AccountSummaryCard.dart';
import 'package:flutter/material.dart';
class MyAccounts extends StatelessWidget {
  final List<AccountInfo> accounts;

  const MyAccounts({super.key, required this.accounts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Accounts")),
      body: ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          final acc = accounts[index];
          return AccountSummaryCard(
            title: acc.title,
            accountType: acc.accountType,
            accountNumber: acc.accountNumber,
            viewBalanceText: acc.viewBalanceText,
            createUpiText: acc.createUpiText,
            option1: acc.option1,
            option2: acc.option2,
            option3: acc.option3,
            balance: acc.balance,
          );
        },
      ),
    );
  }
}
