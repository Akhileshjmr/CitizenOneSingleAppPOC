import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/BankSelectionScreen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/SectionLabel.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/account_and_wallet_summary_card.dart';
import 'package:flutter/material.dart';

class WalletCardSection extends StatelessWidget {
  final LoginUserReqResInfo loginResponse;
  final BankOption? selectedBank;
  const WalletCardSection({
    super.key,
    required this.loginResponse,
    this.selectedBank,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(""),
        const SizedBox(height: 8),

        /// Account + Wallet Summary
        /*AccountAndWalletSummaryCard(
            accountTitle: "Account",
            accountType: "Savings A/C",
            accountNumber: loginResponse.headerInfo.cb_account_no ?? "",
            accountBalance: "",
            viewBalanceText: "View Balance",
            //createUpiText: "Create UPI ID",
            walletTitle: "Wallet",
            walletType: "Wallet A/C",
            walletNumber: loginResponse.headerInfo.wallet_account_no ?? "",
            walletBalance: "",
            walletViewBalanceText: "View Wallet Balance",
            loginResponse: loginResponse
            //createWalletPinText: "Create Wallet PIN",
            //option1: "Statement",
            //option2: "Debit Card",
            //option3: "Services",
            ),*/
        AccountAndWalletSummaryCard(
          loginResponse: loginResponse,
          selectedBank: selectedBank,
          showAccount: true,
          showWallet: false,
          accountTitle: "Account",
          accountType: "Savings A/C",
          accountNumber: loginResponse.headerInfo.cb_account_no ?? "",
          accountBalance: "",
          viewBalanceText: "View Balance",
          walletTitle: "Wallet",
          walletType: "Wallet A/C",
          walletNumber: loginResponse.headerInfo.wallet_account_no ?? "",
          walletBalance: "Mini Statement",
          walletViewBalanceText: "View Balance",
        )

        /// View All Accounts navigation
        /*ViewAllHeader(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyAccounts(
                  accounts: [
                    AccountInfo(
                      title: "Business Account",
                      accountType: "Business A/C",
                      accountNumber: commWalletAccountRequest.headerInfo.wallet_account_no,
                      viewBalanceText: "View Balance",
                      createUpiText: "Create UPI",
                      option1: "Statement",
                      option2: "Debit Card",
                      option3: "Services",
                      balance: commWalletAccountRequest.availabeBal,
                    ),
                    AccountInfo(
                      title: "Wallet Account",
                      accountType: "Wallet A/C",
                      accountNumber: commWalletAccountRequest.accountNum,
                      viewBalanceText: "View Balance",
                      createUpiText: "Create UPI",
                      option1: "Statement",
                      option2: "Debit Card",
                      option3: "Services",
                      balance: commWalletAccountRequest.availabeBal,
                    ),
                  ],
                ),
              ),
            );
          },
        ),*/
      ],
    );
  }
}
