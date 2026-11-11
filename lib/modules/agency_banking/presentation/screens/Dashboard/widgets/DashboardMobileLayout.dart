import 'package:citizenone_app/modules/agency_banking/data/models/CommAccountRequest.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/EstatementEntity.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/get_lov_bloc/get_lov_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/SectionLabel.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/WebRecentTransaction.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/WebServiceSectionCard.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/account_and_wallet_summary_card.dart';
import 'package:flutter/material.dart';

class DashboardMobileLayout extends StatelessWidget {
  final LoginUserReqResInfo loginResponse;
  final CommAccountRequest commAccountRequest;
  final GetLovBloc lovBloc;
  final AuthService authService;
  final List<EstatementEntity> transactions;

  const DashboardMobileLayout({
    super.key,
    required this.loginResponse,
    required this.commAccountRequest,
    required this.lovBloc,
    required this.authService,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel("ACCOUNTS"),
        const SizedBox(height: 8),
        AccountAndWalletSummaryCard(
          loginResponse: loginResponse,
          showAccount: true,
          showWallet: false,
          accountTitle: "My Bank",
          accountType: "Savings",
          accountNumber: loginResponse.headerInfo.cb_account_no ?? "",
          accountBalance: "",
          viewBalanceText: "View Balance",
          walletTitle: "My Wallet",
          walletType: "Wallet",
          walletNumber: loginResponse.headerInfo.wallet_account_no ?? "",
          walletBalance: "",
          walletViewBalanceText: "View Balance",
        ),
        const SizedBox(height: 20),
        const SectionLabel("SERVICES"),
        const SizedBox(height: 8),
        WebServiceSectionCard(
          permission: loginResponse.loginUserInfo.permission,
          loginResponse: loginResponse,
          commAccountRequest: commAccountRequest,
          lovBloc: lovBloc,
          authService: authService,
        ),
        const SizedBox(height: 20),
        const SectionLabel("RECENT TRANSACTIONS"),
        const SizedBox(height: 8),
        RecentTransfersSection(
          transactions: transactions,
          loginResponse: loginResponse,
        ),
      ],
    );
  }
}
