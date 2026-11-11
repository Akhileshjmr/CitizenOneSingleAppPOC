import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:citizenone_app/modules/insurance/app.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/responsive_widgets.dart';
import 'package:citizenone_app/modules/insurance/core/di/di_setup.dart';
import 'package:citizenone_app/modules/insurance/core/presentation/widgets/spacing.dart';
import 'package:citizenone_app/modules/insurance/core/services/secure_storage_service.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/core/utils/snack.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_alert_icon.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_button.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/design_system/organisms/search_transaction_card.dart';
import 'package:citizenone_app/modules/insurance/design_system/organisms/view_transaction_card.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/entities/insurance_transaction_entity.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_event.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_state.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/transaction_data_table.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/transaction_filter_card.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/transaction_pagination.dart';

class InsuranceTransactionScreen extends StatefulWidget {
  const InsuranceTransactionScreen({
    super.key,
    this.arguments,
    this.launchedFromCitizenOne = false,
  });

  final dynamic arguments;

  /// True only when this screen was constructed by
  /// [InsuranceModuleEntry.openInsuranceTransactionScreen] — i.e. pushed
  /// directly onto the *host* app's own Navigator (CitizenOne's Insurance
  /// sidebar), with no [App]/[AppShell]/nested module Router anywhere in
  /// this widget's ancestry. Back-button handling can't reliably infer this
  /// from the widget tree: an ancestor [GoRouter] is *always* found here
  /// (either CitizenOne's own, in this standalone case, or the module's
  /// nested one, when hosted inside [App]), and nested-router `canPop()`
  /// depth varies by how the module itself was entered. Set explicitly by
  /// the one call site that knows it's true; every other entry point (the
  /// module's own internal navigation) leaves this at its default `false`
  /// and keeps its existing back behaviour untouched.
  final bool launchedFromCitizenOne;

  @override
  State<InsuranceTransactionScreen> createState() =>
      _InsuranceTransactionScreenState();
}

class _InsuranceTransactionScreenState
    extends State<InsuranceTransactionScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  final secureStorageService = sl<SecureStorageService>();
  DateTime? _fromDate;
  DateTime? _toDate;

  final Set<String> _expandedTxnIds = {};

  String? _agentCode;
  bool _isInitialized = false;

  // ── Desktop table pagination (client-side page over the bloc's already
  // accumulated `transactions` list — see _buildDesktopBody). ──────────────
  static const int _desktopPageSize = 8;
  int _desktopPage = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_isInitialized) {
      // Extract agentCode from route arguments
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      final motorBloc = context.read<MotorInsuranceBloc>();

      if (args!.isEmpty) {
        _agentCode = await secureStorageService.getAgentCode();
        print(_agentCode);
      } else {
        _agentCode = args['agentCode'] as String?;
      }

      if (!mounted) return;
      motorBloc.add(
        FetchInsuranceTransactionsEvent(agentCode: _agentCode ?? ''),
      );
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final nearBottom =
        _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200;
    if (nearBottom) {
      context.read<MotorInsuranceBloc>().add(
        LoadMoreInsuranceTransactionsEvent(agentCode: _agentCode ?? ''),
      );
    }
  }

  void _fetchTransactions() {
    // Filters narrow the result set, so the desktop click-paginated table
    // must not stay on a page index that may no longer exist.
    if (_desktopPage != 0) {
      setState(() => _desktopPage = 0);
    }
    context.read<MotorInsuranceBloc>().add(
      FetchInsuranceTransactionsEvent(
        agentCode: _agentCode ?? '',
        fromDate: _fromDate,
        toDate: _toDate,
        search: _searchController.text.trim().isEmpty
            ? null
            : _searchController.text.trim(),
      ),
    );
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchTransactions();
    });
  }

  void _resetFilters() {
    _debounce?.cancel();
    setState(() {
      _fromDate = null;
      _toDate = null;
      _searchController.clear();
      _desktopPage = 0;
    });
    context.read<MotorInsuranceBloc>().add(
      const ClearInsuranceTransactionFiltersEvent(),
    );
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (!isFrom && _fromDate == null) {
      Snack.show(context, message: 'Please select from date');
      return;
    }

    final DateTime firstDate;
    final DateTime initialDate;

    if (isFrom) {
      firstDate = DateTime(2000);
      initialDate = _fromDate ?? today;
    } else {
      firstDate = DateTime(_fromDate!.year, _fromDate!.month, _fromDate!.day);
      if (_toDate != null && !_toDate!.isBefore(firstDate)) {
        initialDate = _toDate!;
      } else {
        initialDate = firstDate;
      }
    }

    final effectiveInitialDate = initialDate.isAfter(today)
        ? today
        : initialDate;
    final finalInitialDate = effectiveInitialDate.isBefore(firstDate)
        ? firstDate
        : effectiveInitialDate;

    final picked = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: today,
      initialDate: finalInitialDate,
    );
    if (picked == null || !mounted) return;

    setState(() {
      if (isFrom) {
        _fromDate = picked;
        if (_toDate != null && _toDate!.isBefore(picked)) {
          _toDate = null;
        }
      } else {
        _toDate = picked;
      }
    });

    _fetchTransactions();
  }

  void _toggleExpanded(String txnNumber) {
    setState(() {
      if (_expandedTxnIds.contains(txnNumber)) {
        _expandedTxnIds.remove(txnNumber);
      } else {
        _expandedTxnIds.add(txnNumber);
      }
    });
  }

  bool get _hasActiveFilter =>
      _fromDate != null || _toDate != null || _searchController.text.isNotEmpty;

  // Single authoritative "go back" decision for this screen, used by both
  // the mobile AppBar leading button and the desktop back arrow, so they
  // can never drift from one another or from system/device back:
  //  - `widget.launchedFromCitizenOne` is true only when
  //    `InsuranceModuleEntry.openInsuranceTransactionScreen` pushed this
  //    screen directly onto the *host* app's Navigator (CitizenOne's
  //    Insurance sidebar). This is decided explicitly at the one call site
  //    that knows it — NOT inferred from `GoRouter.maybeOf(context)` (an
  //    ancestor GoRouter is *always* found: either CitizenOne's own, here,
  //    or the module's nested one when hosted inside [App] — so that check
  //    can't tell the two cases apart) or from nested-router `canPop()`
  //    depth (which varies with how the module itself was entered). In this
  //    case, popping the host Navigator IS exiting to CitizenOne, exactly
  //    like the device back button already does for this flow.
  //  - Otherwise (opened inside the full module via
  //    `InsuranceModuleEntry.start`) — existing behaviour, untouched: defer
  //    to [AppShell.handleBack], which mirrors the root `PopScope` in
  //    app.dart (pop the nested router if it can, else exit to host).
  void _handleBack(BuildContext context) {
    if (widget.launchedFromCitizenOne) {
      Navigator.of(context).maybePop();
      return;
    }
    final shell = AppShell.maybeOf(context);
    if (shell == null) {
      Navigator.of(context).maybePop();
    } else {
      shell.handleBack(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!context.isMobile) {
      return _buildDesktop(context);
    }
    final hasActiveFilter = _hasActiveFilter;

    return Scaffold(
      backgroundColor: AppColors.surfaceBg,
      appBar: AppBar(
        backgroundColor: AppColors.glassWhite,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => _handleBack(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Insurance Transactions',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            Text(
              'View all insurance purchase transactions',
              style: TextStyle(
                color: AppColors.serviceHeaderTitle,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      //bottomNavigationBar: const BottomNavScaffold(currentIndex: 0),
      body: BlocConsumer<MotorInsuranceBloc, MotorInsuranceState>(
        listenWhen: (previous, current) =>
            previous.downloadInvoiceStatus != current.downloadInvoiceStatus ||
            previous.printReceiptStatus != current.printReceiptStatus,
        listener: (context, state) {
          if (state.downloadInvoiceStatus == DownloadInvoiceStatus.loading) {
            Snack.show(context, message: 'Downloading...');
          }
          if (state.downloadInvoiceStatus == DownloadInvoiceStatus.success) {
            Snack.show(context, message: 'Downloaded Successfully');
          }
          if (state.downloadInvoiceStatus == DownloadInvoiceStatus.failure) {
            Snack.show(context, message: 'Download Failed');
          }
          if (state.printReceiptStatus == PrintReceiptStatus.loading) {
            Snack.show(context, message: 'Printing...');
          }
          if (state.printReceiptStatus == PrintReceiptStatus.success) {
            Snack.show(context, message: 'Printed Successfully');
          }
          if (state.printReceiptStatus == PrintReceiptStatus.failure) {
            Snack.show(context, message: state.errorMessage.toString());
          }
          if (state.insuranceTransactionStatus ==
                  InsuranceTransactionStatus.failure &&
              state.errorMessage != null) {
            Snack.show(
              context,
              type: AppAlertType.error,
              message: 'Something went wrong while connecting internet',
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 26, 14, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SearchTransactionCard(
                    searchController: _searchController,
                    onSearch: (value) => _onSearchChanged(),
                    onFromTap: () => _pickDate(isFrom: true),
                    onToTap: () => _pickDate(isFrom: false),
                    fromDate: _fromDate,
                    toDate: _toDate,
                  ),
                  if (hasActiveFilter) ...[
                    const VSpace(12),
                    AppButton(
                      text: 'Reset Filter',
                      height: 38,
                      variant: AppButtonVariant.outline,
                      borderColor: AppColors.primary,
                      textColor: AppColors.primary,
                      onPressed: _resetFilters,
                    ),
                  ],
                  const VSpace(20),
                  _buildBody(state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Desktop / tablet: Transactions Details (sidebar destination) ────────
  Widget _buildDesktop(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBg,
      body: BlocConsumer<MotorInsuranceBloc, MotorInsuranceState>(
        listenWhen: (previous, current) =>
            previous.downloadInvoiceStatus != current.downloadInvoiceStatus ||
            previous.printReceiptStatus != current.printReceiptStatus,
        listener: (context, state) {
          if (state.downloadInvoiceStatus == DownloadInvoiceStatus.loading) {
            Snack.show(context, message: 'Downloading...');
          }
          if (state.downloadInvoiceStatus == DownloadInvoiceStatus.success) {
            Snack.show(context, message: 'Downloaded Successfully');
          }
          if (state.downloadInvoiceStatus == DownloadInvoiceStatus.failure) {
            Snack.show(context, message: 'Download Failed');
          }
          if (state.printReceiptStatus == PrintReceiptStatus.loading) {
            Snack.show(context, message: 'Printing...');
          }
          if (state.printReceiptStatus == PrintReceiptStatus.success) {
            Snack.show(context, message: 'Printed Successfully');
          }
          if (state.printReceiptStatus == PrintReceiptStatus.failure) {
            Snack.show(context, message: state.errorMessage.toString());
          }
          if (state.insuranceTransactionStatus ==
                  InsuranceTransactionStatus.failure &&
              state.errorMessage != null) {
            Snack.show(
              context,
              type: AppAlertType.error,
              message: 'Something went wrong while connecting internet',
            );
          }
        },
        builder: (context, state) {
          // Note: intentionally does NOT reuse `_scrollController` — that
          // controller drives the mobile infinite-scroll `_onScroll`
          // listener, which would otherwise fire immediately on this much
          // shorter, click-paginated desktop layout and silently prefetch
          // every page in the background.
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: ResponsiveContainer(
              padHorizontal: false,
              maxWidth: 1100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          // NOTE: `GoRouter.maybeOf(context) != null` used to
                          // gate this, on the assumption that the standalone
                          // (host-pushed) case has "no GoRouter in scope".
                          // That's false — CitizenOne's own app is itself
                          // built on GoRouter, so an ancestor GoRouter is
                          // *always* found here, standalone or not. That made
                          // `context.go('/')` fire even when launched
                          // directly from CitizenOne, navigating CitizenOne's
                          // own router to an undefined '/' route (its error
                          // page) instead of popping back to the sidebar.
                          // `launchedFromCitizenOne` is set explicitly by the
                          // one call site that knows it's true, so this case
                          // no longer depends on inferring anything from the
                          // widget tree.
                          if (widget.launchedFromCitizenOne) {
                            Navigator.of(context).maybePop();
                          } else if (GoRouter.maybeOf(context) != null) {
                            context.go('/');
                          } else {
                            Navigator.of(context).maybePop();
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 12, top: 2),
                          child: Icon(
                            Icons.chevron_left,
                            size: 30,
                            color: AppColors.serviceHeaderTitle,
                          ),
                        ),
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            'Insurance Transactions',
                            style: AppTextStyle.headlineMedium,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          SizedBox(height: 4),
                          AppText(
                            'View and manage all your insurance transactions',
                            style: AppTextStyle.bodyMedium,
                            color: AppColors.serviceHeaderTitle,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TransactionFilterCard(
                    searchController: _searchController,
                    onSearch: (value) => _onSearchChanged(),
                    onFromTap: () => _pickDate(isFrom: true),
                    onToTap: () => _pickDate(isFrom: false),
                    fromDate: _fromDate,
                    toDate: _toDate,
                  ),
                  if (_hasActiveFilter) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AppButton(
                        text: 'Reset Filter',
                        height: 38,
                        variant: AppButtonVariant.outline,
                        borderColor: AppColors.primary,
                        textColor: AppColors.primary,
                        onPressed: _resetFilters,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  _buildDesktopBody(state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Desktop table body: paginates the bloc's accumulated `transactions`
  // list client-side (8/page) instead of the mobile infinite-scroll list,
  // reusing the exact same fetch/load-more events and status enum. ────────
  Widget _buildDesktopBody(MotorInsuranceState state) {
    switch (state.insuranceTransactionStatus) {
      case InsuranceTransactionStatus.initial:
      case InsuranceTransactionStatus.loading:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 60),
          child: Center(child: CircularProgressIndicator()),
        );

      case InsuranceTransactionStatus.empty:
        return const _DesktopMessageCard(message: 'No transactions found');

      case InsuranceTransactionStatus.failure:
        return const _DesktopMessageCard(
          message: 'Something went wrong while connecting internet',
        );

      case InsuranceTransactionStatus.success:
      case InsuranceTransactionStatus.loadingMore:
        final total = state.totalElements;
        final available = state.transactions.length;
        final startIndex = _desktopPage * _desktopPageSize;
        final rawEnd = startIndex + _desktopPageSize;
        final displayEnd = rawEnd > total ? total : rawEnd;
        final sliceEnd = displayEnd > available ? available : displayEnd;
        final pageItems = startIndex < available
            ? state.transactions.sublist(startIndex, sliceEnd)
            : <InsuranceTransactionEntity>[];
        final isLoadingTargetPage =
            pageItems.isEmpty &&
            state.insuranceTransactionStatus ==
                InsuranceTransactionStatus.loadingMore;

        if (isLoadingTargetPage) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 60),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TransactionDataTable(transactions: pageItems),
            const SizedBox(height: 20),
            TransactionPagination(
              startIndex: startIndex,
              endIndex: displayEnd,
              totalItems: total,
              onPrevious: _desktopPage > 0
                  ? () => setState(() => _desktopPage--)
                  : null,
              onNext: displayEnd < total ? _goToNextDesktopPage : null,
            ),
          ],
        );
    }
  }

  void _goToNextDesktopPage() {
    final state = context.read<MotorInsuranceBloc>().state;
    final nextStart = (_desktopPage + 1) * _desktopPageSize;
    if (nextStart >= state.transactions.length && !state.hasReachedMax) {
      context.read<MotorInsuranceBloc>().add(
        LoadMoreInsuranceTransactionsEvent(agentCode: _agentCode ?? ''),
      );
    }
    setState(() => _desktopPage++);
  }

  Widget _buildBody(MotorInsuranceState state) {
    switch (state.insuranceTransactionStatus) {
      case InsuranceTransactionStatus.initial:
      case InsuranceTransactionStatus.loading:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(child: CircularProgressIndicator()),
        );

      case InsuranceTransactionStatus.empty:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(child: Text('No transactions found')),
        );

      case InsuranceTransactionStatus.failure:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Text('Something went wrong while connecting internet'),
          ),
        );

      case InsuranceTransactionStatus.success:
      case InsuranceTransactionStatus.loadingMore:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...state.transactions.map((txn) {
              final isExpanded = _expandedTxnIds.contains(txn.txnNumber);
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ViewTransactionCard(
                  title: 'Motor Insurance',
                  transactionId: txn.txnNumber,
                  policyId: txn.policyId,
                  policyNumber: txn.policyNumber ?? '-',
                  filedDate: txn.createdAt != null
                      ? DateFormat('dd-MM-yyyy hh:mm a').format(txn.createdAt!)
                      : '-',
                  referenceNumber: txn.referenceNumber ?? '-',
                  hostRefNumber: txn.hostReferenceNumber ?? '-',
                  customerName: txn.customerName,
                  mobileNumber: txn.customerPhone,
                  status: txn.transactionStatusLabel,
                  isExpanded: isExpanded,
                  onViewMore: () => _toggleExpanded(txn.txnNumber),
                  policyGrossPremium: txn.policyGrossPremium != null
                      ? txn.policyGrossPremium!.toStringAsFixed(2)
                      : 'N/A',
                ),
              );
            }),
            if (state.insuranceTransactionStatus ==
                InsuranceTransactionStatus.loadingMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        );
    }
  }
}

class _DesktopMessageCard extends StatelessWidget {
  final String message;

  const _DesktopMessageCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Center(
        child: AppText(
          message,
          style: AppTextStyle.bodyMedium,
          color: AppColors.serviceHeaderTitle,
        ),
      ),
    );
  }
}
