import 'package:citizenone_app/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/core/presentation/widgets/spacing.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/core/utils/snack.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';
import 'package:citizenone_app/design_system/atoms/app_text_field.dart';
import 'package:citizenone_app/features/kyc/presentation/screens/kyc_user_details_screen.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_bloc.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_event.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_state.dart';
import 'package:citizenone_app/design_system/atoms/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class KycHistoryScreen extends StatefulWidget {
  const KycHistoryScreen({super.key});

  @override
  State<KycHistoryScreen> createState() => _KycHistoryScreenState();
}

class _KycHistoryScreenState extends State<KycHistoryScreen> {
  final _queryCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  @override
  void initState() {
    final bloc = context.read<KycBloc>();

    bloc.add(const FetchRecentHistory());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (bloc.state.currentPage < bloc.state.totalPages) {
          bloc.add(
            FetchRecentHistory(
              filter: bloc.state.selectedFilter,
              page: bloc.state.currentPage + 1,
              fromDate: bloc.state.fromDate,
              toDate: bloc.state.toDate,
            ),
          );
        }
      }
    });

    super.initState();
  }

  Future<void> _onRefresh() async {
    final bloc = context.read<KycBloc>();

    bloc.add(
      FetchRecentHistory(
        filter: bloc.state.selectedFilter,
        page: 1,
        fromDate: bloc.state.selectedFilter == "CUSTOM"
            ? bloc.state.fromDate
            : null,
        toDate: bloc.state.selectedFilter == "CUSTOM"
            ? bloc.state.toDate
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = AdaptiveLayout.isMobile(context);
    return BlocConsumer<KycBloc, KycState>(
      listener: (context, state) {
        if (state.status == KycUserStatus.error) {
          Snack.show(context, message: "Something went wrong!");
        }

        if (state.status == KycUserStatus.loadedFromHistory) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const KycDetailsScreen(enableEdit: false),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppStatusBar(
            bgColor: AppColors.surface,
            centerTitle: true,
            showBack: true,
            title: 'KYC History',
          ),
          body: SafeArea(
            minimum: EdgeInsets.all(AdaptiveLayout.horizontalPadding(context)),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: AdaptiveLayout.contentMaxWidth(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VSpace(12),
                    _searchField(context),
                    const VSpace(12),
                    _filterSection(context, state, isMobile),
                    const VSpace(12),
                    Expanded(child: _historyList(context, state, isMobile)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  // ── Search ───────────────────────────────────────────────────

  Widget _searchField(BuildContext context) {
    return Form(
      key: _formKey,
      child: AppTextField(
        //name: "Search History",
        hintText: "Enter Name | NID | Mobile Number",
        controller: _queryCtrl,
        // isRequired: false,
        keyboardType: TextInputType.text,
        maxLength: 50,
        suffixIcon: const Icon(Icons.search, color: AppColors.surfaceLight),
        onChanged: (value) {
          if (_formKey.currentState!.validate()) {
            context.read<KycBloc>().add(LocalSearchKycHistory(value.trim()));
          }
        },
        // filled: true,
        fillColor: AppColors.surface,
      ),
    );

    //    InputTextFormField(
    //     controller: _queryCtrl,
    //     isRequired: false,
    //     fieldType: FieldType.text,
    //     maxLength: 50,
    //     labelText: 'Enter Name | NID | Mobile Number',
    //     suffixIcon: const Icon(Icons.search, color: AppColors.surfaceLight),
    //     onChanged: (value) {
    //       if (_formKey.currentState!.validate()) {
    //         context.read<KycBloc>().add(LocalSearchKycHistory(value.trim()));
    //       }
    //     },
    //   ),
    // );
  }

  // ── Filter section ───────────────────────────────────────────

  Widget _filterSection(BuildContext context, KycState state, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(AdaptiveLayout.horizontalPadding(context)),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            "Records",
            style: AppTextStyle.bodySmall,
            color: AppColors.black,
          ),

          const VSpace(2),
          _filterChips(context, state),
          if (state.selectedFilter == "CUSTOM") ...[
            const VSpace(20),
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
            padding: EdgeInsets.all(10),
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
                  horizontal: AdaptiveLayout.horizontalPadding(context),
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.surfaceLight,
                  ),
                ),
                child: AppText(
                  filter,
                  style: AppTextStyle.bodySmall,
                  color: isSelected
                      ? AppColors.surface
                      : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
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

  Widget _datePicker(
    BuildContext context,
    KycState state, {
    required bool isFrom,
  }) {
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
              border: Border.all(color: AppColors.textSecondary),
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
    final items = state.filteredKycHistoryList ?? [];

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: isMobile
          ? _mobileList(context, state, items)
          : _webGrid(context, state, items),
    );
  }

  /// Mobile: single column list
  Widget _mobileList(
    BuildContext context,
    KycState state,
    List<dynamic> items,
  ) {
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
        horizontal: AdaptiveLayout.horizontalPadding(context),
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

  Widget _historyCard(
    BuildContext context,
    dynamic item, {
    double bottomMargin = 16,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
      padding: EdgeInsets.all(AdaptiveLayout.horizontalPadding(context)),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
                    AppText(
                      "${item.firstName} ${item.lastName}",
                      style: AppTextStyle.bodyMedium,
                    ),
                    // Text(
                    //   ,
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.w600,
                    //     fontSize: AdaptiveLayout.fontSize(
                    //       context,
                    //       mobile: 15,
                    //       web: 8,
                    //     ),
                    //     color: AppColors.textPrimary,
                    //   ),
                    // ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Text(
                          'ID: ',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          item.code ?? "",
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: (item.kycStatus == "Approved")
                      ? AppColors.success
                      : AppColors.warning,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AppText(
                  item.kycStatus ?? "",
                  color: AppColors.surface,
                  style: AppTextStyle.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.textSecondary),
          const SizedBox(height: 16),

          // Date + View Record
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Date: ',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    DateFormat(
                      "dd/MM/yyyy",
                    ).format(item.createdDate ?? DateTime.now()),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  context.read<KycBloc>().add(
                    SearchUserEvent(
                      mobileNumber: item.mobileNumber!,
                      nationalId: item.nationalId!,
                      fromHistory: true,
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Text(
                      'View Record',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: AppColors.primary,
                    ),
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
