import 'package:citizenone_app/modules/agency_banking/data/models/CommAccountRequest.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/CommWalletAccountRequest.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/account_balance_bloc/account_balance_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/account_balance_bloc/account_balance_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/account_balance_bloc/account_balance_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_account_balance/wallet_balance_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_account_balance/wallet_balance_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_account_balance/wallet_balance_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/BaseScreen/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../utils/UICleanupHelper.dart';

class BalanceScreen extends StatefulWidget {
  final String balanceType;
  final LoginUserReqResInfo loginResponse;
  const BalanceScreen({required this.balanceType, required this.loginResponse});

  @override
  _BalanceScreen createState() => _BalanceScreen();
}

class _BalanceScreen extends State<BalanceScreen> {
  Color myHexColor = const Color(0xff5c7d33);
  CommAccountRequest? accountRequest;
  CommWalletAccountRequest? walletAccountRequest;

  @override
  void initState() {
    super.initState();
    _fetchBalance(); // Trigger the event to fetch data
  }

  void _fetchBalance() {
    if (widget.balanceType == "Account") {
      CommAccountRequest accountRequest = CommAccountRequest();
      accountRequest.headerInfo = widget.loginResponse.headerInfo;
      accountRequest.selfAccountCheck = "Y";
      context.read<AccountBalanceBloc>().add(
            AccountBalanceSubmitted(accountRequest),
          );
    }

    if (widget.balanceType == "Wallet") {
      CommWalletAccountRequest walletAccountRequest =
          CommWalletAccountRequest();
      walletAccountRequest.headerInfo = widget.loginResponse.headerInfo;
      walletAccountRequest.selfAccountCheck = "Y";
      walletAccountRequest.moduleCode = "N";
      context.read<WalletBalanceBloc>().add(
            WalletBalanceSubmitted(walletAccountRequest),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.balanceType == "Wallet" ? "Wallet Balance" : "Account Balance",
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AccountBalanceBloc, AccountBalanceState>(
            listener: (context, state) {
              if (state is AccountBalanceSuccess) {
                setState(() {
                  accountRequest =
                      state.commAccountRequest; // Store API response
                });
              } else if (state is AccountBalanceFailure) {
                showCustomBottomPopup(context, state.error);
              }
            },
          ),
          BlocListener<WalletBalanceBloc, WalletBalanceState>(
            listener: (context, state) {
              if (state is WalletBalanceSuccess) {
                setState(() {
                  walletAccountRequest =
                      state.commWalletAccountRequest; // Store API response
                });
              } else if (state is WalletBalanceFailure) {
                showCustomBottomPopup(context, state.error);
              }
            },
          ),
        ],
        child: Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 70,
              ),
              const SizedBox(height: 20),
              const Text(
                "Available Balance fetched successfully",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Siinqee Bank of Ethiopia-0008",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Available Balance",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.balanceType == "Wallet"
                    ? "ETB ${walletAccountRequest?.availabeBal ?? '0.0'}"
                    : "ETB ${accountRequest?.availabeBal ?? '0.0'}",
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
