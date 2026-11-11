import 'package:citizenone_app/modules/agency_banking/data/models/CommAccountRequest.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/BankSelectionScreen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/left_menu_screen/history/transaction_history_screen.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/AESEncryption.dart';
import '../../../../utils/Loader.dart';
import '../../../blocs/account_search_bloc/account_search_bloc.dart';
import '../../../blocs/account_search_bloc/account_search_event.dart';
import '../../../blocs/account_search_bloc/account_search_state.dart';

/// The desktop web dashboard's "Total Available Balance" card. Kept
/// deliberately separate from AccountAndWalletSummaryCard (the shared
/// mobile widget) so future web-only styling changes can never ripple into
/// the phone dashboard.
class WebBalanceCard extends StatefulWidget {
  final LoginUserReqResInfo loginResponse;
  final BankOption? selectedBank;

  const WebBalanceCard({
    super.key,
    required this.loginResponse,
    this.selectedBank,
  });

  @override
  State<WebBalanceCard> createState() => _WebBalanceCardState();
}

class _WebBalanceCardState extends State<WebBalanceCard> {
  bool _showBalance = false;
  bool _hideBalance = false;
  String? _accountBalance;

  bool get _isBankAccountLinked {
    return widget.loginResponse.headerInfo.cb_account_no != null &&
        widget.loginResponse.headerInfo.cb_account_no!.isNotEmpty;
  }

  Color get _brandColor => widget.selectedBank?.themeColor ?? AppColors.k613AF5;

  String get _balanceText {
    if (!_isBankAccountLinked) return "--";
    if (!_showBalance || _hideBalance) return "••••••";
    final currency =
        AESEncryptionService.decrypt(widget.loginResponse.headerInfo.currency);
    final amount = (double.tryParse(
                AESEncryptionService.decrypt(_accountBalance.toString())) ??
            0.0)
        .toStringAsFixed(2);
    return "$currency $amount";
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountSearchBloc, AccountSearchState>(
      listener: (context, state) {
        if (state is AccountSearchLoading) {
          context.read<LoadingCubit>().show();
        } else {
          context.read<LoadingCubit>().hide();
        }
        if (state is AccountSearchSuccess) {
          setState(() {
            _showBalance = true;
            _accountBalance = state.commAccountRequest.availabeBal;
          });
        } else if (state is AccountSearchFailure) {
          showCustomBottomPopup(context, state.error);
        }
      },
      child: Stack(
        children: [
          _buildCard(context),
          const GlobalLoader(),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
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
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                (widget.selectedBank?.bankName ?? "Bank").toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            "TOTAL AVAILABLE BALANCE",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                _balanceText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_isBankAccountLinked && _showBalance) ...[
                const SizedBox(width: 10),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    _hideBalance
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () {
                    setState(() {
                      _hideBalance = !_hideBalance;
                    });
                  },
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),
          if (_isBankAccountLinked)
            Row(
              children: [
                _pillButton(
                  icon: Icons.visibility_outlined,
                  text: "View Balance",
                  filled: true,
                  onTap: () {
                    CommAccountRequest accRequest = CommAccountRequest();
                    accRequest.headerInfo = widget.loginResponse.headerInfo;
                    accRequest.service_id = "ACC_SEARCH";
                    accRequest.accountNum =
                        widget.loginResponse.headerInfo.cb_account_no ?? "";

                    context
                        .read<AccountSearchBloc>()
                        .add(AccountSearchSubmitted(accRequest));
                  },
                ),
                const SizedBox(width: 12),
                _pillButton(
                  icon: Icons.description_outlined,
                  text: "Mini Statement",
                  filled: false,
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
              ],
            )
          else
            const Text(
              "Account is not linked for the bank",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  Widget _pillButton({
    required IconData icon,
    required String text,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 42,
      child: filled
          ? ElevatedButton.icon(
              onPressed: onTap,
              icon: Icon(icon, size: 18, color: _brandColor),
              label: Text(text),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: _brandColor,
                elevation: 0,
                textStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.description_outlined,
                  size: 18, color: Colors.white),
              label: Text(text),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white),
                textStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
    );
  }
}
