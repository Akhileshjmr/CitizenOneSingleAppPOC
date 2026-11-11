import 'package:citizenone_app/modules/agency_banking/constants/ModuleCode.dart' show ModuleCode;
import 'package:citizenone_app/modules/agency_banking/data/models/AccountTransHistory.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/transaction_history/transaction_history_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/transaction_history/transaction_history_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/transaction_history/transaction_history_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/transaction_receipt_bloc/transaction_receipt_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/transaction_receipt_bloc/transaction_receipt_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/transaction_receipt_bloc/transaction_receipt_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/BankSelectionScreen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/dashboard_screen/main_menu_screen/agent_application/transactions/download_receipt_screen.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AESEncryption.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:citizenone_app/modules/agency_banking/data/models/CommTransactionDetails.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommDateTimeUtils.dart';
import 'package:citizenone_app/modules/agency_banking/utils/RandomNumberGenerator.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../utils/CommDialog.dart';
import '../../../../utils/Loader.dart';

bool isReceiptScreenOpen = false; // 🔒 GLOBAL LOCK

class HistoryScreen extends StatefulWidget {
  final LoginUserReqResInfo loginResponse;
  final BankOption selectedBank;
  final bool skipDialog; // <<< NEW

  const HistoryScreen({
    required this.loginResponse,
    required this.selectedBank,
    this.skipDialog = false,
  });

  @override
  _HistoryScreen createState() => _HistoryScreen();
}

class _HistoryScreen extends State<HistoryScreen> {
  String txnRefNo = RandomNumberGenerator.generateId('AGB', 13);

  late String transactionPdf;
  bool showTransactionButton = false;
  late final bool ca;

  bool receiptScreenOpened = false;
  bool dialogShown = false;

  // ---------------- MOBILE SEARCH & QUICK FILTERS (presentational, reuse existing bloc/event) ----------------
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'Recent';
  DateTime? _customFromDate;
  DateTime? _customToDate;
  final TextEditingController _customFromController = TextEditingController();
  final TextEditingController _customToController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final request = AccountTransHistory()
      ..headerInfo = widget.loginResponse.headerInfo;

    context.read<HistoryTransactionHistoryBloc>().add(
          TransactionHistorySubmitted(request),
        );
  }

  void _fetchHistory({DateTime? fdate, DateTime? tdate}) {
    final request = AccountTransHistory()
      ..headerInfo = widget.loginResponse.headerInfo
      ..fdate = fdate
      ..tdate = tdate;

    context.read<HistoryTransactionHistoryBloc>().add(
          TransactionHistorySubmitted(request),
        );
  }

  void _applyQuickFilter(String filter) {
    setState(() => _selectedFilter = filter);

    final now = DateTime.now();
    switch (filter) {
      case 'Recent':
        _fetchHistory();
        break;
      case 'Week':
        _fetchHistory(fdate: now.subtract(const Duration(days: 7)), tdate: now);
        break;
      case 'Month':
        _fetchHistory(fdate: now.subtract(const Duration(days: 30)), tdate: now);
        break;
      case 'Custom':
        // Reveals the From/To pickers; fetch happens once both are chosen.
        break;
    }
  }

  Future<void> _pickCustomDate(bool isFromDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isFromDate
          ? (_customFromDate ?? DateTime.now())
          : (_customToDate ?? (_customFromDate ?? DateTime.now())),
      firstDate:
          isFromDate ? DateTime(2000) : (_customFromDate ?? DateTime(2000)),
      lastDate: DateTime.now(),
    );

    if (pickedDate == null) return;

    setState(() {
      final fmt = "${pickedDate.day.toString().padLeft(2, '0')}/"
          "${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
      if (isFromDate) {
        _customFromDate = pickedDate;
        _customFromController.text = fmt;
        if (_customToDate != null && pickedDate.isAfter(_customToDate!)) {
          _customToDate = null;
          _customToController.clear();
        }
      } else {
        _customToDate = pickedDate;
        _customToController.text = fmt;
      }
    });

    if (_customFromDate != null && _customToDate != null) {
      _fetchHistory(fdate: _customFromDate, tdate: _customToDate);
    }
  }

  List<dynamic> _filterBySearch(List<dynamic> transactions) {
    if (_searchQuery.trim().isEmpty) return transactions;
    final query = _searchQuery.trim().toLowerCase();

    return transactions.where((txn) {
      final name =
          AESEncryptionService.decrypt(txn.cCustomerName ?? '').toLowerCase();
      final refNo = (txn.txnId ?? '').toString().toLowerCase();
      return name.contains(query) || refNo.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _customFromController.dispose();
    _customToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// Transaction History Listener
        BlocListener<HistoryTransactionHistoryBloc, TransactionHistoryState>(
          listener: (context, state) {
            if (state is TransactionHistoryLoading) {
              context.read<LoadingCubit>().show();
            } else {
              context.read<LoadingCubit>().hide();
            }

            if (state is TransactionHistorySuccess &&
                !dialogShown &&
                !widget.skipDialog) {
              setState(() {
                showTransactionButton = true;
                dialogShown = true;
              });
              showDialog(
                context: context,
                builder: (_) => TransactionHistoryDialog(
                  loginResponse: widget.loginResponse,
                ),
              );
            }

            if (state is TransactionHistoryFailure) {
              // showCustomBottomPopup(context, state.error);
            }
          },
        ),

        /// Transaction Receipt Listener
        BlocListener<TransactionReceiptBloc, TransactionReceiptState>(
          listener: (context, state) {
            if (state is TransactionReceiptLoading) {
              context.read<LoadingCubit>().show();
              return;
            } else {
              context.read<LoadingCubit>().hide();
            }

            if (state is TransactionReceiptSuccess) {
              if (!mounted || receiptScreenOpened) return;

              receiptScreenOpened = true;
              transactionPdf = state.transactionDetails.transactionPdf ?? '';

              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (_) => DownloadReceiptScreen(
                    transactionPdf: transactionPdf,
                    selectedBank: widget.selectedBank,
                    loginResponse: widget.loginResponse,
                    fromHistory: true,
                  ),
                ),
              )
                  .then((_) {
                receiptScreenOpened = false;
              });
            }

            if (state is TransactionReceiptFailure) {
              if (!mounted) return;
              showCustomBottomPopup(context, state.error);
            }
          },
        ),
      ],
      child: Stack(
        children: [
          Scaffold(
            backgroundColor:
                MediaQuery.of(context).size.width < 600 ? AppColors.loginBackground : null,
            appBar: _buildAppBar(context),
            body: BlocBuilder<HistoryTransactionHistoryBloc,
                TransactionHistoryState>(
              builder: (context, state) {
                final bool hasHistory = state is TransactionHistorySuccess &&
                    state.transHistory.eStatementEntities?.isNotEmpty == true;
                final bool noRecords = (state is TransactionHistorySuccess &&
                        (state.transHistory.eStatementEntities?.isEmpty ??
                            true)) ||
                    (state is TransactionHistoryFailure &&
                        state.error.toUpperCase().contains('NO RECORDS FOUND'));

                final transactions = hasHistory
                    ? state.transHistory.eStatementEntities ?? []
                    : [];

                if (MediaQuery.of(context).size.width < 600) {
                  return _buildMobileBody(transactions, hasHistory, noRecords);
                }

                return Padding(
                  padding: const EdgeInsets.only(right: 2, bottom: 10, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showTransactionButton)
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => TransactionHistoryDialog(
                                  loginResponse: widget.loginResponse,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Show Transaction History",
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.fbLiteDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      if (noRecords)
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.receipt_long,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "No recent transactions",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (hasHistory)
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(right: 2, bottom: 5),
                            child: Column(
                              children: [
                                Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 8),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        for (int index = 0;
                                            index < transactions.length;
                                            index++) ...[
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: Colors.teal,
                                                child: Text(
                                                  getInitial(transactions[index]
                                                      .dCustomerName),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Paid to",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 3),
                                                    Text(
                                                      AESEncryptionService
                                                          .decrypt(
                                                        transactions[index]
                                                                .cCustomerName ??
                                                            '',
                                                      ),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(height: 3),
                                                    Text(
                                                      getModuleName(
                                                        AESEncryptionService
                                                            .decrypt(
                                                          transactions[index]
                                                                  .moduleType ??
                                                              '',
                                                        ),
                                                      ),
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    AESEncryptionService
                                                        .decrypt(
                                                      transactions[index]
                                                              .dTxnCcy ??
                                                          '',
                                                    ),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    transactions[index]
                                                            .dAmount
                                                            ?.toStringAsFixed(
                                                                0) ??
                                                        '0',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 5),
                                            child: Row(
                                              children: [
                                                // LEFT SIDE (takes space)
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.check_circle,
                                                        color: Colors.green,
                                                        size: 16,
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        CommDateTimeUtils
                                                                .formatTimestampToDateString(
                                                              transactions[
                                                                      index]
                                                                  .txnDate,
                                                            ) ??
                                                            'Unknown Date',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                // RIGHT SIDE (sticks to end)
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    padding: EdgeInsets
                                                        .zero, // 🔥 IMPORTANT
                                                    minimumSize: Size.zero,
                                                    tapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                  ),
                                                  onPressed: () {
                                                    CommTransactionDetails
                                                        transactionDetails =
                                                        CommTransactionDetails();
                                                    transactionDetails
                                                            .headerInfo =
                                                        widget.loginResponse
                                                            .headerInfo;
                                                    transactionDetails.transId =
                                                        transactions[index]
                                                            .txnId;

                                                    context
                                                        .read<
                                                            TransactionReceiptBloc>()
                                                        .add(
                                                          TransactionReceiptSubmitted(
                                                              transactionDetails),
                                                        );
                                                  },
                                                  child: const Text(
                                                    'View Receipt',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (index < transactions.length - 1)
                                            const Divider(),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          /// Global Loader Overlay
          const GlobalLoader(),
        ],
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

  String getInitial(String? name) {
    if (name == null) return '';

    final cleaned = name
        .replaceAll(
          RegExp(r'^(MR\.?|MRS\.?|MS\.?|DR\.?)\s+', caseSensitive: false),
          '',
        )
        .trim();

    if (cleaned.isEmpty) return '';

    return cleaned[0].toUpperCase();
  }

  // ---------------- MOBILE UI ----------------

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    if (MediaQuery.of(context).size.width >= 600) {
      return const CustomAppBar(title: "Transaction History");
    }
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Transaction History",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "View all Recent transaction history",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.black),
          onPressed: () => showLogoutDialog(context),
        ),
      ],
    );
  }

  Widget _buildFilterPill(String label) {
    final bool selected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => _applyQuickFilter(label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.k0D1F4D : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.k0D1F4D),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.k0D1F4D,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildMobileFilterCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: "Search Ref No, Name, s...",
              hintStyle: const TextStyle(color: AppColors.textHint),
              prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.primaryInputBackground,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.k613AF5),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildFilterPill("Recent"),
              _buildFilterPill("Week"),
              _buildFilterPill("Month"),
              _buildFilterPill("Custom"),
            ],
          ),
          if (_selectedFilter == "Custom") ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("From Date",
                          style: TextStyle(
                              fontSize: 14, color: AppColors.textPrimary)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _customFromController,
                        readOnly: true,
                        onTap: () => _pickCustomDate(true),
                        decoration: InputDecoration(
                          hintText: "DD/MM/YYYY",
                          suffixIcon: const Icon(Icons.calendar_today_outlined,
                              size: 18),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: AppColors.borderLight),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("To Date",
                          style: TextStyle(
                              fontSize: 14, color: AppColors.textPrimary)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _customToController,
                        readOnly: true,
                        onTap: _customFromDate != null
                            ? () => _pickCustomDate(false)
                            : null,
                        decoration: InputDecoration(
                          hintText: "DD/MM/YYYY",
                          suffixIcon: const Icon(Icons.calendar_today_outlined,
                              size: 18),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: AppColors.borderLight),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMobileTransactionCard(dynamic txn) {
    final name = AESEncryptionService.decrypt(txn.cCustomerName ?? '');
    final moduleName = getModuleName(
      AESEncryptionService.decrypt(txn.moduleType ?? ''),
    );
    final currency = AESEncryptionService.decrypt(txn.dTxnCcy ?? '');
    final amount = txn.dAmount?.toStringAsFixed(2) ?? '0';
    final date = CommDateTimeUtils.formatTimestampToDateString(txn.txnDate) ??
        'Unknown Date';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.kEEF2FF,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_outline,
                    color: AppColors.green, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      moduleName,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "$currency $amount",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.borderLight),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              GestureDetector(
                onTap: () {
                  CommTransactionDetails transactionDetails =
                      CommTransactionDetails();
                  transactionDetails.headerInfo = widget.loginResponse.headerInfo;
                  transactionDetails.transId = txn.txnId;

                  context.read<TransactionReceiptBloc>().add(
                        TransactionReceiptSubmitted(transactionDetails),
                      );
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "View Receipt",
                      style: TextStyle(
                        color: AppColors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Icon(Icons.chevron_right, color: AppColors.green, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileBody(
      List<dynamic> transactions, bool hasHistory, bool noRecords) {
    final filtered = _filterBySearch(transactions);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMobileFilterCard(),
          const SizedBox(height: 16),
          if (noRecords)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 60),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.receipt_long, size: 60, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      "No recent transactions",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (hasHistory)
            if (filtered.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    "No transactions match your search",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              )
            else
              ...filtered.map(_buildMobileTransactionCard),
        ],
      ),
    );
  }
}

class TransactionHistoryDialog extends StatefulWidget {
  final LoginUserReqResInfo loginResponse;
  const TransactionHistoryDialog({required this.loginResponse});

  @override
  _TransactionHistoryDialogState createState() =>
      _TransactionHistoryDialogState();
}

class _TransactionHistoryDialogState extends State<TransactionHistoryDialog> {
  DateTime? fromDate;
  DateTime? toDate;
  final Color myHexColor = const Color(0xff5c7d33);

  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  String _fmt(DateTime d) => "${d.day}/${d.month}/${d.year}";

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isFromDate
          ? (fromDate ?? DateTime.now())
          : (toDate ?? (fromDate ?? DateTime.now())),
      firstDate: isFromDate ? DateTime(2000) : (fromDate ?? DateTime(2000)),
      lastDate: DateTime.now(), // Disable future dates
    );

    if (pickedDate != null) {
      setState(() {
        if (isFromDate) {
          fromDate = pickedDate;
          _fromController.text = _fmt(pickedDate);
          // Reset 'To' date if 'From' date is later
          if (toDate != null && pickedDate.isAfter(toDate!)) {
            toDate = null;
            _toController.clear();
          }
        } else {
          toDate = pickedDate;
          _toController.text = _fmt(pickedDate);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 350, // Limit width
          maxHeight: 400, // Limit height
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            // Just in case content overflows
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Transaction History",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        onTap: () => _selectDate(context, true),
                        decoration: InputDecoration(
                          labelText: "From",
                          hintText: fromDate != null
                              ? _fmt(fromDate!)
                              : "Select Date",
                          suffixIcon: const Icon(Icons.calendar_month),
                          border: const OutlineInputBorder(),
                        ),
                        controller: _fromController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        onTap: fromDate != null
                            ? () => _selectDate(context, false)
                            : null,
                        decoration: InputDecoration(
                          labelText: "To",
                          hintText:
                              toDate != null ? _fmt(toDate!) : "Select Date",
                          suffixIcon: const Icon(Icons.calendar_month),
                          border: const OutlineInputBorder(),
                        ),
                        controller: _toController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: buildActionButton(
                    label: 'Search',
                    onPressed: (fromDate != null && toDate != null)
                        ? () {
                            AccountTransHistory transactionHistory =
                                AccountTransHistory();
                            transactionHistory.headerInfo =
                                widget.loginResponse.headerInfo;
                            transactionHistory.fdate = fromDate;
                            transactionHistory.tdate = toDate;

                            context.read<HistoryTransactionHistoryBloc>().add(
                                  TransactionHistorySubmitted(
                                      transactionHistory),
                                );

                            Navigator.pop(context);
                          }
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: buildActionButton(
                    label: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
