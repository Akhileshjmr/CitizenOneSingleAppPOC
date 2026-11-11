import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/BankSelectionScreen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/left_menu_screen/history/transaction_history_screen.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommDateTimeUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../constants/ModuleCode.dart';
import '../../../../data/models/CommTransactionDetails.dart';
import '../../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../../theme/colors/Appcolors.dart';
import '../../../../utils/AESEncryption.dart';
import '../../../../utils/CommSuccessDialogues.dart';
import '../../../../utils/Loader.dart';
import '../../../blocs/transaction_receipt_bloc/transaction_receipt_bloc.dart';
import '../../../blocs/transaction_receipt_bloc/transaction_receipt_event.dart';
import '../../../blocs/transaction_receipt_bloc/transaction_receipt_state.dart';
import '../../dashboard_screen/main_menu_screen/agent_application/transactions/download_receipt_screen.dart';

class MobileRecentTransaction extends StatefulWidget {
  final List<dynamic> transactions; // Replace dynamic with your model
  final LoginUserReqResInfo loginResponse;
  final BankOption selectedBank;
  final bool isLoading;

  const MobileRecentTransaction({
    super.key,
    required this.transactions,
    required this.loginResponse,
    required this.selectedBank,
    this.isLoading = false,
  });

  @override
  State<MobileRecentTransaction> createState() =>
      _MobileRecentTransactionState();
}

class _MobileRecentTransactionState extends State<MobileRecentTransaction> {
  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '',
      decimalDigits: 2,
    );

    return BlocListener<TransactionReceiptBloc, TransactionReceiptState>(
      listener: (context, state) {
        if (state is TransactionReceiptLoading) {
          context.read<LoadingCubit>().show();
        } else {
          context.read<LoadingCubit>().hide();
        }

        if (state is TransactionReceiptSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DownloadReceiptScreen(
                transactionPdf: state.transactionDetails.transactionPdf!,
                loginResponse: widget.loginResponse,
                selectedBank: widget.selectedBank,
              ),
            ),
          );
        } else if (state is TransactionReceiptFailure) {
          showCustomBottomPopup(context, state.error);
        }
      },
      child: Stack(
        children: [
          _buildRecentTransactionsUI(currencyFormatter),
          if (widget.isLoading)
            Positioned.fill(
              child: Container(
                // Use margin to match the UI underneath so the overlay fits perfectly
                margin: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  color: AppColors.loginBackground, //Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: LoadingAnimationWidget.progressiveDots(
                    color: AppColors.fbTooLite,
                    size: 40,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryScreen(
          loginResponse: widget.loginResponse,
          selectedBank: widget.selectedBank,
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Recent Transaction",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () => _openHistory(context),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "View All",
                style: TextStyle(
                  color: AppColors.k613AF5,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 2),
              Icon(Icons.arrow_forward, size: 14, color: AppColors.k613AF5),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactionsUI(NumberFormat currencyFormatter) {
    if (widget.transactions.isEmpty && !widget.isLoading) {
      return Container(
          width: double.infinity,
          margin: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeader(context),
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        "No recent transactions",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ])));
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(context),
            const SizedBox(height: 10),
            ...widget.transactions.map((txn) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.k613AF5.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: AppColors.k613AF5,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // LEFT SIDE (takes remaining space)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AESEncryptionService.decrypt(
                                txn.dCustomerName ?? 'Unknown'),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AESEncryptionService.decrypt(
                              txn.txnId ?? '',
                            ),
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            getModuleName(
                              AESEncryptionService.decrypt(txn.moduleType),
                            ),
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            CommDateTimeUtils.formatTimestampToDateString(
                                    txn.txnDate) ??
                                '',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // RIGHT SIDE (sticks to screen end)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${AESEncryptionService.decrypt(txn.dTxnCcy ?? '')} ${currencyFormatter.format(double.tryParse(txn.dAmount?.toString() ?? '0') ?? 0)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFFE53935),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero, // 🔥 removes right gap
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            CommTransactionDetails details =
                                CommTransactionDetails();
                            details.headerInfo =
                                widget.loginResponse.headerInfo;
                            details.transId = txn.txnId;

                            context
                                .read<TransactionReceiptBloc>()
                                .add(TransactionReceiptSubmitted(details));
                          },
                          child: const Text(
                            'View Receipt',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
            if (widget.isLoading && widget.transactions.isEmpty)
              const SizedBox(height: 60), // Space for dots if list is empty
          ],
        ),
      ),
    );
  }

  String getModuleName(String? type) {
    switch (type) {
      case ModuleCode.fundTransfer:
        return 'Fund Transfer';
      case ModuleCode.deposit:
        return 'Deposit';
      case ModuleCode.withdrawal:
        return 'Withdraw';
      case ModuleCode.cbsToWallet:
        return 'Wallet Topup';
      case ModuleCode.walletToCbs:
        return 'Wallet Redeem';
      default:
        return 'Unknown';
    }
  }
}
