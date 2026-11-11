import 'package:citizenone_app/modules/agency_banking/core/utils/repsonsive_helper.dart';
import 'package:citizenone_app/modules/agency_banking/core/utils/snack.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/input_form_field.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/responsive/breakpoints.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/kyc_user_details_screen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/kyc_desktop_scaffold.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class KycHistoryScreen extends StatefulWidget {
  const KycHistoryScreen({super.key});

  @override
  State<KycHistoryScreen> createState() => _KycHistoryScreenState();
}

class _KycHistoryScreenState extends State<KycHistoryScreen> {
  /// `Responsive.fontSize` always applies ScreenUtil's `.sp` scaling, which
  /// is calibrated against a mobile design size — on desktop widths that
  /// inflates a small intended size (e.g. 8) into a much larger rendered
  /// size. This mirrors its (mobile, web) signature but renders the web
  /// value as a literal pixel size instead of scaling it, fixing oversized
  /// desktop typography on this screen without touching the mobile sizing.
  double _fs(BuildContext context,
          {required double mobile, required double web}) =>
      Responsive.isWeb(context) ? web : mobile.sp;

  final _queryCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _queryCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final bloc = context.read<KycBloc>();

    bloc.add(const FetchRecentHistory());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (bloc.state.currentPage < bloc.state.totalPages) {
          bloc.add(FetchRecentHistory(
            filter: bloc.state.selectedFilter,
            page: bloc.state.currentPage + 1,
            fromDate: bloc.state.fromDate,
            toDate: bloc.state.toDate,
          ));
        }
      }
    });

    super.initState();
  }

  Future<void> _onRefresh() async {
    final bloc = context.read<KycBloc>();

    bloc.add(FetchRecentHistory(
      filter: bloc.state.selectedFilter,
      page: 1,
      fromDate:
          bloc.state.selectedFilter == "CUSTOM" ? bloc.state.fromDate : null,
      toDate: bloc.state.selectedFilter == "CUSTOM" ? bloc.state.toDate : null,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<KycBloc, KycState>(
      listener: _historyListener,
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (Breakpoints.isDesktop(constraints.maxWidth)) {
              return _buildDesktopScaffold(context, state);
            }
            return _buildMobileTabletScaffold(context, state);
          },
        );
      },
    );
  }

  void _historyListener(BuildContext context, KycState state) {
    if (state.status == KycUserStatus.error) {
      Snack.show(context, message: "Something went wrong!");
    }

    if (state.status == KycUserStatus.loadedFromHistory) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const KycDetailsScreen(
            enableEdit: false,
          ),
        ),
      );
    }
  }

  Widget _buildDesktopScaffold(BuildContext context, KycState state) {
    return KycDesktopScaffold(
      pageTitle: "KYC History",
      scrollable: false,
      maxContentWidth: 900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchField(context),
          const SizedBox(height: 12),
          _filterSection(context, state, false),
          const SizedBox(height: 12),
          Expanded(child: _historyList(context, state, false)),
        ],
      ),
    );
  }

  Widget _buildMobileTabletScaffold(BuildContext context, KycState state) {
    final bool isMobile = Responsive.isMobile(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'KYC History',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: Responsive.fontSize(context, mobile: 14, web: 8),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(
          Responsive.value(context, mobile: 8.0, web: 16.0),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.value(
                context,
                mobile: double.infinity,
                tablet: 720,
                web: 900,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                _searchField(context),
                const SizedBox(height: 12),
                _filterSection(context, state, isMobile),
                const SizedBox(height: 12),
                Expanded(
                  child: _historyList(context, state, isMobile),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // ── Search ───────────────────────────────────────────────────

  Widget _searchField(BuildContext context) {
    return Form(
      key: _formKey,
      child: InputTextFormField(
        controller: _queryCtrl,
        isRequired: false,
        fieldType: FieldType.text,
        hint: 'Enter Name | NID | Mobile Number',
        hintTextSize: 14,
        maxLength: 50,
        suffixIcon: const Icon(Icons.search),
        onChanged: (value) {
          if (_formKey.currentState!.validate()) {
            context.read<KycBloc>().add(LocalSearchKycHistory(value.trim()));
          }
        },
      ),
    );
  }

// ── Filter section ───────────────────────────────────────────

  Widget _filterSection(BuildContext context, KycState state, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(
        Responsive.value(context, mobile: 8.0, web: 16.0),
      ),
      color: AppColors.cardBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Records",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: _fs(context, mobile: 12, web: 13),
            ),
          ),
          const SizedBox(height: 15),
          _filterChips(context, state),
          if (state.selectedFilter == "CUSTOM") ...[
            const SizedBox(height: 20),
            _customDateRow(context, state),
          ],
        ],
      ),
    );
  }

  Widget _filterChips(BuildContext context, KycState state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ["RECENT", "WEEK", "MONTH", "CUSTOM"].map((filter) {
          final isSelected = state.selectedFilter == filter;
          return Padding(
            padding: EdgeInsets.all(
              Responsive.value(context, mobile: 8.0, web: 10.0),
            ),
            child: InkWell(
              onTap: () => context.read<KycBloc>().add(
                    FetchRecentHistory(
                      filter: filter,
                      page: 1,
                      fromDate: filter == "CUSTOM" ? state.fromDate : null,
                      toDate: filter == "CUSTOM" ? state.toDate : null,
                    ),
                  ),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      Responsive.value(context, mobile: 20.0, web: 30.0),
                  vertical: Responsive.value(context, mobile: 10.0, web: 12),
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryBlue : AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryBlue
                        : AppColors.lightGrey,
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: _fs(context, mobile: 12, web: 13),
                    color:
                        isSelected ? AppColors.white : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _customDateRow(BuildContext context, KycState state) {
    return Row(
      children: [
        Expanded(child: _datePicker(context, state, isFrom: true)),
        const SizedBox(width: 12),
        Expanded(child: _datePicker(context, state, isFrom: false)),
      ],
    );
  }

  Widget _datePicker(BuildContext context, KycState state,
      {required bool isFrom}) {
    final label = isFrom ? "From Date" : "To Date";
    final date = isFrom ? state.fromDate : state.toDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              initialDate: DateTime.now(),
            );
            if (picked != null && context.mounted) {
              context.read<KycBloc>().add(
                    FetchRecentHistory(
                      filter: "CUSTOM",
                      page: 1,
                      fromDate: isFrom ? picked : state.fromDate,
                      toDate: isFrom ? state.toDate : picked,
                    ),
                  );
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.darkGray),
            ),
            child: Text(
              date == null
                  ? "DD/MM/YYYY"
                  : DateFormat("dd/MM/yyyy").format(date),
            ),
          ),
        ),
      ],
    );
  }

// ── History list ─────────────────────────────────────────────

  Widget _historyList(BuildContext context, KycState state, bool isMobile) {
    if (state.historyStatus == KycHistoryStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.historyStatus == KycHistoryStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Something went wrong!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _fs(context, mobile: 14, web: 14),
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Please try later',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _fs(context, mobile: 14, web: 14),
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      );
    }

    final items = state.filteredKycHistoryList ?? [];
    if (state.historyStatus == KycHistoryStatus.loaded) {
      if (items.isEmpty) {
        return Center(
          child: Text(
            'No data available',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: _fs(context, mobile: 14, web: 14),
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: isMobile
            ? _mobileList(context, state, items)
            : _webGrid(context, state, items),
      );
    }
    return const Center(
      child: Text("Please try later"),
    );
  }

  /// Mobile: single column list
  Widget _mobileList(
      BuildContext context, KycState state, List<dynamic> items) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: items.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return _historyCard(context, items[index]);
      },
    );
  }

  /// Web/tablet: two-column grid
  Widget _webGrid(BuildContext context, KycState state, List<dynamic> items) {
    // Build paired rows
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.value(context, mobile: 8.0, web: 0.0),
      ),
      itemCount: (items.length / 2).ceil() + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, rowIndex) {
        if (rowIndex == (items.length / 2).ceil()) {
          return const Center(child: CircularProgressIndicator());
        }

        final leftIndex = rowIndex * 2;
        final rightIndex = leftIndex + 1;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _historyCard(context, items[leftIndex], bottomMargin: 0),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: rightIndex < items.length
                    ? _historyCard(context, items[rightIndex], bottomMargin: 0)
                    : const SizedBox(), // placeholder for odd count
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _historyCard(BuildContext context, dynamic item,
      {double bottomMargin = 16}) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
      padding: EdgeInsets.all(
        Responsive.value(context, mobile: 16.0, web: 12.0),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${item.firstName} ${item.lastName}",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: _fs(context, mobile: 15, web: 15),
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Text(
                          'ID: ',
                          style: TextStyle(
                              color: AppColors.textHint, fontSize: 14),
                        ),
                        Text(
                          item.code ?? "",
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: (item.kycStatus == "Approved")
                      ? AppColors.successBg
                      : AppColors.warningBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.kycStatus ?? "",
                  style: TextStyle(
                    color: (item.kycStatus == "Approved")
                        ? AppColors.successText
                        : AppColors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.dividerLight),
          const SizedBox(height: 16),

          // Date + View Record
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('Date: ',
                      style:
                          TextStyle(color: AppColors.textHint, fontSize: 13)),
                  Text(
                    item.createdDate != null
                        ? DateFormat("dd/MM/yyyy").format(item.createdDate)
                        : 'NA',
                    style: const TextStyle(
                        color: AppColors.textHint, fontSize: 13),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  context.read<KycBloc>().add(SearchUserEvent(
                      mobileNumber: item.mobileNumber!,
                      nationalId: item.nationalId!,
                      fromHistory: true));
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         const KycDetailsScreen(enableEdit: false),
                  //   ),
                  // );
                },
                child: const Row(
                  children: [
                    Text(
                      'View Record',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios,
                        size: 12, color: AppColors.primaryBlue),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
