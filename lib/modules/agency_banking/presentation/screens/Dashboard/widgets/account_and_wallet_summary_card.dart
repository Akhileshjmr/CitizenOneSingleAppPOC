import 'package:citizenone_app/modules/agency_banking/data/models/CommAccountRequest.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/BankSelectionScreen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/left_menu_screen/history/transaction_history_screen.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/ModuleCode.dart';
import '../../../../data/models/CommWalletAccountRequest.dart';
import '../../../../utils/AESEncryption.dart';
import '../../../../utils/Loader.dart';
import '../../../blocs/account_search_bloc/account_search_bloc.dart';
import '../../../blocs/account_search_bloc/account_search_event.dart';
import '../../../blocs/account_search_bloc/account_search_state.dart';
import '../../../blocs/wallet_account_search/wallet_account_search_bloc.dart';
import '../../../blocs/wallet_account_search/wallet_account_search_event.dart';
import '../../../blocs/wallet_account_search/wallet_account_search_state.dart';

class AccountAndWalletSummaryCard extends StatefulWidget {
  final String accountTitle;
  final String accountType;
  final String accountNumber;
  final String accountBalance;
  final String viewBalanceText;
  final String? createUpiText;
  final String walletTitle;
  final String walletType; // ✅ Added wallet type
  final String walletNumber;
  final String walletBalance;
  final String walletViewBalanceText;
  final String? createWalletPinText;
  final String? option1;
  final String? option2;
  final String? option3;
  final LoginUserReqResInfo loginResponse;
  final bool showAccount;
  final bool showWallet;
  final BankOption? selectedBank;

  const AccountAndWalletSummaryCard({
    super.key,
    required this.showAccount,
    required this.showWallet,
    required this.accountTitle,
    required this.accountType,
    required this.accountNumber,
    required this.accountBalance,
    required this.viewBalanceText,
    this.createUpiText,
    required this.walletTitle,
    required this.walletType, // ✅ required
    required this.walletNumber,
    required this.walletBalance,
    required this.walletViewBalanceText,
    this.createWalletPinText,
    this.option1,
    this.option2,
    this.option3,
    required this.loginResponse,
    this.selectedBank,
  });

  @override
  State<AccountAndWalletSummaryCard> createState() =>
      _AccountAndWalletSummaryCardState();
}

class _AccountAndWalletSummaryCardState
    extends State<AccountAndWalletSummaryCard> {
  bool _showAccountBalance = false;
  bool _showWalletBalance = false;
  bool _hideAccountBalance = false;
  bool _hideWalletBalance = false;
  String? balance;
  String? accountBalance;
  bool get _isBankAccountLinked {
    return widget.loginResponse.headerInfo.cb_account_no != null &&
        widget.loginResponse.headerInfo.cb_account_no!.isNotEmpty;
  }

  Color get _brandColor => /*widget.selectedBank?.themeColor ??*/
      AppColors.k613AF5; //AppColors.loginBackground;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// 🏦 Account Balance Listener
        BlocListener<AccountSearchBloc, AccountSearchState>(
          listener: (context, state) {
            if (state is AccountSearchLoading) {
              context.read<LoadingCubit>().show();
            } else {
              context.read<LoadingCubit>().hide();
            }
            if (state is AccountSearchSuccess) {
              setState(() {
                _showAccountBalance = true;
                accountBalance = state.commAccountRequest.availabeBal;
              });
            }
            if (state is AccountSearchFailure) {
              showCustomBottomPopup(context, state.error);
            }
          },
        ),
        BlocListener<WalletSearchBloc, WalletSearchState>(
            listener: (context, state) {
          if (state is WalletSearchLoading) {
            context.read<LoadingCubit>().show();
          } else {
            context.read<LoadingCubit>().hide();
          }
          if (state is WalletSearchSuccess) {
            setState(() {
              _showWalletBalance = true;
              balance = state.commWalletAccountRequest.availabeBal;
            });
          } else if (state is WalletSearchFailure) {
            showCustomBottomPopup(context, state.error);
          }
        }),
      ],
      child: Stack(
        children: [
          _buildScaffoldContent(context),
          const GlobalLoader(), // overlay always available
        ],
      ),
    );
  }

  Widget _buildScaffoldContent(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [_brandColor, _brandColor.withOpacity(0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _brandColor.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showAccount) _buildAccountBlock(context),
          if (widget.showAccount && widget.showWallet)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Divider(color: Colors.white24, height: 1),
            ),
          if (widget.showWallet) _buildWalletBlock(context),
        ],
      ),
    );
  }

  Widget _buildAccountBlock(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AESEncryptionService.decrypt(
                  widget.selectedBank?.bankName ?? widget.accountTitle,
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (_isBankAccountLinked && _showAccountBalance)
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  _hideAccountBalance
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _hideAccountBalance = !_hideAccountBalance;
                  });
                },
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          widget.accountType,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 10),
        if (_isBankAccountLinked) ...[
          Text(
            AESEncryptionService.decrypt(widget.accountNumber),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _accountBalanceDisplayText(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _pillButton(
                  text: widget.viewBalanceText,
                  filled: false,
                  onTap: () {
                    CommAccountRequest accRequest = CommAccountRequest();
                    accRequest.headerInfo = widget.loginResponse.headerInfo;
                    accRequest.service_id = "ACC_SEARCH";
                    accRequest.accountNum =
                        widget.loginResponse.headerInfo.cb_account_no ?? "";

                    context.read<AccountSearchBloc>().add(
                          AccountSearchSubmitted(accRequest),
                        );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _pillButton(
                  text: "Mini Statement",
                  filled: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryScreen(
                          loginResponse: widget.loginResponse,
                          selectedBank: widget.selectedBank ?? BankOption(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ] else ...[
          const SizedBox(height: 4),
          const Text(
            "Account is not linked for the bank",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildWalletBlock(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.walletTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (_showWalletBalance)
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  _hideWalletBalance
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _hideWalletBalance = !_hideWalletBalance;
                  });
                },
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          widget.walletType,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 10),
        Text(
          AESEncryptionService.decrypt(widget.walletNumber),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _walletBalanceDisplayText(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _pillButton(
          text: widget.walletViewBalanceText,
          filled: false,
          onTap: () {
            CommWalletAccountRequest request = CommWalletAccountRequest();
            request.mobileno = widget.loginResponse.headerInfo.userName;
            request.moduleCode =
                AESEncryptionService.encrypt(ModuleCode.deposit);
            request.headerInfo = widget.loginResponse.headerInfo;
            context
                .read<WalletSearchBloc>()
                .add(WalletSearchSubmitted(request));
          },
        ),
      ],
    );
  }

  String _accountBalanceDisplayText() {
    if (!_showAccountBalance || _hideAccountBalance) return "••••••";
    return "${AESEncryptionService.decrypt(widget.loginResponse.headerInfo.currency)} "
        "${(double.tryParse(AESEncryptionService.decrypt(accountBalance.toString())) ?? 0.0).toStringAsFixed(2)}";
  }

  String _walletBalanceDisplayText() {
    if (!_showWalletBalance || _hideWalletBalance) return "••••••";
    return "${AESEncryptionService.decrypt(widget.loginResponse.headerInfo.currency)} "
        "${(double.tryParse(AESEncryptionService.decrypt(balance.toString())) ?? 0.0).toStringAsFixed(2)}";
  }

  Widget _pillButton({
    required String text,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 38,
      child: filled
          ? ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: _brandColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                text,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            )
          : OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                text,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
    );
  }
}
