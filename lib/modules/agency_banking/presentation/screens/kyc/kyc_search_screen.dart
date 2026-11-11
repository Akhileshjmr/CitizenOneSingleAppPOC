import 'package:citizenone_app/modules/agency_banking/core/utils/repsonsive_helper.dart';
import 'package:citizenone_app/modules/agency_banking/core/utils/snack.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/input_form_field.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/responsive/breakpoints.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/kyc_no_record_screen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/button/kyc_custom_button.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/kyc_desktop_form_bits.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/kyc_desktop_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/colors/Appcolors.dart';
import '../../blocs/kyc_bloc/kyc_bloc.dart';
import '../../blocs/kyc_bloc/kyc_event.dart';
import 'kyc_history_screen.dart';
import 'kyc_user_details_screen.dart';
import 'widgets/app_bar/kyc_app_bar.dart';

class KYCSearchScreen extends StatefulWidget {
  const KYCSearchScreen({super.key});

  @override
  State<KYCSearchScreen> createState() => _KYCSearchScreenState();
}

class _KYCSearchScreenState extends State<KYCSearchScreen> {
  final _formKey = GlobalKey<FormState>();

  final _mobileController = TextEditingController();
  final _nationalIdController = TextEditingController();

  bool _isFetchingRecentHistory = false;

  void _onRecentHistoryTap(BuildContext context) {
    setState(() => _isFetchingRecentHistory = true);
    context.read<KycBloc>().add(const FetchRecentHistory());
  }

  void _onFindRecord() {
    context.read<KycBloc>().add(const ResetFormData());
    context.read<KycBloc>().add(
          SearchUserEvent(
              mobileNumber: _mobileController.text.trim(),
              nationalId: _nationalIdController.text.trim()),
        );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const KycDetailsScreen(),
    //   ),
    // );
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (Breakpoints.isDesktop(constraints.maxWidth)) {
          return _buildDesktopScaffold(context);
        }
        return _buildMobileTabletScaffold(context);
      },
    );
  }

  bool _listenWhen(KycState previous, KycState current) =>
      previous.isConnected != current.isConnected ||
      previous.status != current.status ||
      previous.historyStatus != current.historyStatus;

  void _searchListener(BuildContext context, KycState state) {
    if (!state.isConnected) {
      Snack.show(context,
          message:
              "You're offline. Please check your internet connection and try again");
    }
    if (state.status == KycUserStatus.error) {
      Snack.show(context, message: "Something went wrong!");
    }
    if (state.status == KycUserStatus.notFound) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NoRecordScreen(
              mobile: state.mobileNumber,
              nationalId: state.nationalId,
            ),
          ));
    }
    if (state.status == KycUserStatus.loaded) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const KycDetailsScreen(),
        ),
      );
    }
    if (_isFetchingRecentHistory &&
        state.historyStatus == KycHistoryStatus.loaded) {
      setState(() => _isFetchingRecentHistory = false);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const KycHistoryScreen()),
      );
    }
    if (_isFetchingRecentHistory &&
        state.historyStatus == KycHistoryStatus.error) {
      setState(() => _isFetchingRecentHistory = false);
      Snack.show(context, message: "Something went wrong!");
    }
  }

  Widget _buildDesktopScaffold(BuildContext context) {
    return BlocConsumer<KycBloc, KycState>(
      listenWhen: _listenWhen,
      listener: _searchListener,
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: KycDesktopScaffold(
            pageTitle: "Find or Create Customer Record",
            pageSubtitle:
                "Search by mobile number or national ID to locate an existing KYC record.",
            showBackButton: false,
            child: _searchCard(context, state),
          ),
        );
      },
    );
  }

  Widget _buildMobileTabletScaffold(BuildContext context) {
    final bool isWeb = Responsive.isWeb(context);
    final bool isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: const KycAppBar(
        title: 'KYC',
        centerTitle: false,
        bgColor: AppColors.primaryBlue,
        textIconColor: AppColors.white,
      ),
      body: BlocConsumer<KycBloc, KycState>(
        listenWhen: _listenWhen,
        listener: _searchListener,
        builder: (context, state) {
          return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.horizontalPadding(context),
                vertical: 16,
              ),
              child: Center(
                  child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: Responsive.contentMaxWidth(context),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: isMobile ? 24 : 40),

                      // Header
                      _headerInfo(),
                      const SizedBox(height: 20),

                      // Search card
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                            Responsive.value(context,
                                mobile: 16.0, tablet: 20.0, web: 24.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Search Criteria',
                                style: TextStyle(
                                  fontSize: Responsive.fontSize(context,
                                      mobile: 12, web: 8),
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Fields — side by side on web/tablet, stacked on mobile
                              if (isMobile)
                                _buildMobileFields()
                              else
                                _buildWebFields(),

                              const SizedBox(height: 20),

                              // Find Record button
                              SizedBox(
                                  height: isMobile ? 50 : 60,
                                  width: double.infinity,
                                  child: (state.status == KycUserStatus.loading)
                                      ? AppButton(
                                          title: "",
                                          onTap: () {},
                                          isLoading: true,
                                          backgroundColor:
                                              AppColors.primaryBlue,
                                        )
                                      : AppButton(
                                          title: "Find Record",
                                          icon: Icons.search,
                                          onTap: _handleSearch,
                                          backgroundColor:
                                              AppColors.primaryBlue,
                                        )),

                              SizedBox(height: isWeb ? 24 : 110),

                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: SizedBox(
                                    height: isMobile ? 50 : 60,
                                    width: 180.w,
                                    child: AppButton(
                                      title: "Recent History",
                                      icon: Icons.history,
                                      isLoading: _isFetchingRecentHistory,
                                      onTap: () => _onRecentHistoryTap(context),
                                      backgroundColor: AppColors.primaryBlue,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )));
        },
      ),
    );
  }

  Widget _searchCard(BuildContext context, KycState state) {
    final isLoading = state.status == KycUserStatus.loading;
    final isLoadingMobile = isLoading && state.searchType == SearchType.mobileNumber;
    final isLoadingNationalId = isLoading && state.searchType == SearchType.nationalId;
    return KycDesktopCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _desktopBanner(),
          const SizedBox(height: 24),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _desktopSearchPanel(
                    icon: Icons.phone_outlined,
                    title: "Search by Mobile",
                    fieldLabel: "Mobile Number",
                    hintText: "e.g. 56678990",
                    controller: _mobileController,
                    isLoadingState: isLoadingMobile,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(9),
                    ],
                    onSubmit: _handleMobileSearch,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _desktopSearchPanel(
                    icon: Icons.badge_outlined,
                    title: "Search by National ID",
                    fieldLabel: "National ID",
                    hintText: "e.g. 123456/78/9",
                    controller: _nationalIdController,
                    isLoadingState: isLoadingNationalId,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(9),
                      SlashFormatter(),
                    ],
                    onSubmit: _handleNationalIdSearch,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Expanded(child: Divider(color: AppColors.borderLight)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR',
                  style: TextStyle(
                    color: AppColors.kycSubtitleGray,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(child: Divider(color: AppColors.borderLight)),
            ],
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 48,
              width: 190,
              child: AppButton(
                title: "Recent History",
                icon: Icons.history,
                isLoading: _isFetchingRecentHistory,
                onTap: () => _onRecentHistoryTap(context),
                backgroundColor: AppColors.k613AF5,
                borderRadius: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _desktopBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [AppColors.kycBannerStart, AppColors.kycSectionAccent],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.search, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find or Create Record',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Enter a Mobile Number or National ID to find an existing customer record.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _desktopSearchPanel({
    required IconData icon,
    required String title,
    required String fieldLabel,
    required String hintText,
    required TextEditingController controller,
    required bool isLoadingState,
    required List<TextInputFormatter> inputFormatters,
    required VoidCallback onSubmit,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.kF8FAFC,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.k613AF5),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.kycTitleNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              text: fieldLabel,
              style: const TextStyle(
                color: AppColors.kycFieldLabel,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              children: const [
                TextSpan(
                  text: '*',
                  style: TextStyle(color: AppColors.kycErrorRed),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.phone,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.kycBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.kycBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: AppColors.k613AF5, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              final hasValue = value.text.trim().isNotEmpty;
              return SizedBox(
                height: 44,
                width: double.infinity,
                child: isLoadingState
                    ? AppButton(
                        title: "",
                        onTap: () {},
                        isLoading: true,
                        backgroundColor: AppColors.k613AF5,
                        borderRadius: 10,
                      )
                    : AppButton(
                        title: "Find Record",
                        icon: Icons.search,
                        onTap: onSubmit,
                        backgroundColor: hasValue
                            ? AppColors.k613AF5
                            : AppColors.kycPrimaryMuted,
                        borderRadius: 10,
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _handleMobileSearch() {
    if (_mobileController.text.isEmpty) {
      Snack.show(context, message: "Please enter a Mobile Number");
      return;
    }
    if (_mobileController.text.length < 9) {
      Snack.show(context, message: "Mobile Number should contain 9 digits");
      return;
    }
    _nationalIdController.clear();
    _onFindRecord();
  }

  void _handleNationalIdSearch() {
    if (_nationalIdController.text.isEmpty) {
      Snack.show(context, message: "Please enter a National ID");
      return;
    }
    if (_nationalIdController.text.length != 11) {
      Snack.show(context, message: 'Please enter a valid National ID');
      return;
    }
    _mobileController.clear();
    _onFindRecord();
  }

// Stacked layout for mobile
  Widget _buildMobileFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMobileNumberField(),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('OR', style: TextStyle(color: AppColors.darkGray)),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 12),
        _buildNationalIdField(),
      ],
    );
  }

// Side-by-side layout for web/tablet
  Widget _buildWebFields() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildMobileNumberField()),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: VerticalDivider()),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child:
                      Text('OR', style: TextStyle(color: AppColors.darkGray)),
                ),
                Expanded(child: VerticalDivider()),
              ],
            ),
          ),
          Expanded(child: _buildNationalIdField()),
        ],
      ),
    );
  }

  Widget _buildMobileNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mobile Number',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          maxLength: 9,
          controller: _mobileController,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            hintText: 'e.g. 987654321',
            prefixIcon:
                Icon(Icons.phone_outlined, color: AppColors.primaryBlue),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildNationalIdField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'National ID',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _nationalIdController,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'National ID is required';
            }
            if (value.length != 11) return 'Please enter a valid National ID';
            return null;
          },
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(9),
            SlashFormatter(),
          ],
          decoration: const InputDecoration(
            hintText: 'e.g. 123456/78/9',
            prefixIcon:
                Icon(Icons.badge_outlined, color: AppColors.primaryBlue),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          ),
        ),
      ],
    );
  }

  void _handleSearch() {
    if (_mobileController.text.isNotEmpty &&
        _mobileController.text.length < 9) {
      Snack.show(context, message: "Mobile Number should contain 9 digits");
      return;
    }
    if (_mobileController.text.isNotEmpty &&
        _nationalIdController.text.isNotEmpty) {
      Snack.show(context,
          message: "Search by either Mobile Number or National ID");
      return;
    }
    if (_mobileController.text.isEmpty && _nationalIdController.text.isEmpty) {
      Snack.show(context, message: "Please enter Mobile Number or National ID");
      return;
    }
    if (_mobileController.text.isEmpty &&
        _nationalIdController.text.isNotEmpty) {
      if (_nationalIdController.text.length != 11) {
        Snack.show(context, message: 'Please enter a valid National ID');
        return;
      }
    }
    _onFindRecord();
  }
}

Widget _headerInfo() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.primaryBlue, AppColors.primaryDarkBlue],
      ),
      borderRadius: BorderRadius.circular(16),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.manage_accounts, color: AppColors.white, size: 28),
        SizedBox(height: 8),
        Text(
          'Find or Create Record',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Enter a Mobile Number or National ID to find an existing record.',
          style: TextStyle(color: AppColors.white, fontSize: 13),
        ),
      ],
    ),
  );
}
