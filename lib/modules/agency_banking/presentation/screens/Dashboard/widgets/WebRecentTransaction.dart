import 'package:citizenone_app/modules/agency_banking/data/models/EstatementEntity.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/BankSelectionScreen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/left_menu_screen/history/transaction_history_screen.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AESEncryption.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommDateTimeUtils.dart';
import 'package:flutter/material.dart';

class RecentTransfersSection extends StatelessWidget {
  final List<EstatementEntity> transactions;
  final LoginUserReqResInfo? loginResponse;
  final BankOption? selectedBank;

  const RecentTransfersSection({
    Key? key,
    required this.transactions,
    this.loginResponse,
    this.selectedBank,
  }) : super(key: key);

  void _openHistory(BuildContext context) {
    if (loginResponse == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryScreen(
          loginResponse: loginResponse!,
          selectedBank: selectedBank ?? BankOption(),
        ),
      ),
    );
  }

  String _decrypt(String? value) {
    if (value == null || value.isEmpty) return '';
    try {
      return AESEncryptionService.decrypt(value);
    } catch (_) {
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          ),
          const SizedBox(height: 16),
          if (transactions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                "No recent transactions",
                style: TextStyle(color: Colors.black54),
              ),
            )
          else
            ...transactions.map((txn) {
              final name = _decrypt(txn.dCustomerName);
              final ccy = _decrypt(txn.dTxnCcy);
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.15)),
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name.isNotEmpty ? name : 'Unknown',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            CommDateTimeUtils.formatTimestampToDateString(
                                    txn.txnDate) ??
                                '',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "-$ccy ${txn.dAmount?.toStringAsFixed(2) ?? '0.00'}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFFE53935),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 5,
          spreadRadius: 1,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}
