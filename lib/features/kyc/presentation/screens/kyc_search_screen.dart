import 'package:citizenone_app/components/foundation/responsive.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/core/utils/snack.dart';
import 'package:citizenone_app/design_system/atoms/app_button.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';
import 'package:citizenone_app/features/kyc/presentation/screens/kyc_no_record_screen.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_bloc.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_event.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_state.dart';
import 'package:citizenone_app/core/forms/formatters/app_text_field_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../design_system/atoms/app_bar.dart';
import 'kyc_history_screen.dart';
import 'kyc_user_details_screen.dart';

class KycSearchScreen extends StatefulWidget {
  const KycSearchScreen({super.key});

  @override
  State<KycSearchScreen> createState() => _KycSearchScreenState();
}

class _KycSearchScreenState extends State<KycSearchScreen> {
  final _formKey = GlobalKey<FormState>();

  final _mobileController = TextEditingController();
  final _nationalIdController = TextEditingController();

  void _onFindRecord() {
    context.read<KycBloc>().add(const ResetFormData());
    context.read<KycBloc>().add(
      SearchUserEvent(
        mobileNumber: _mobileController.text.trim(),
        nationalId: _nationalIdController.text.trim(),
      ),
    );
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveLayout.isDesktop(context);
    final bool isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppStatusBar(
        title: 'KYC',
        centerTitle: true,
        bgColor: AppColors.primary,
        textIconColor: AppColors.surface,
      ),
      body: BlocConsumer<KycBloc, KycState>(
        listener: (context, state) {
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
              ),
            );
          }
          if (state.status == KycUserStatus.loaded) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const KycDetailsScreen()),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AdaptiveLayout.horizontalPadding(context),
              vertical: 16,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: AdaptiveLayout.contentMaxWidth(context),
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
                            AdaptiveLayout.horizontalPadding(context),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                'Search Criteria',
                                style: AppTextStyle.bodyLarge,
                                color: AppColors.black,
                              ),
                              const SizedBox(height: 12),

                              if (isMobile)
                                _buildMobileFields()
                              else
                                _buildWebFields(),

                              const SizedBox(height: 20),

                              // Find Record button
                              SizedBox(
                                height: isMobile ? 50 : 40,
                                width: double.infinity,
                                child: (state.status == KycUserStatus.loading)
                                    ? AppButton(
                                        text: "",
                                        onPressed: () {},
                                        isLoading: true,
                                        backgroundColor: AppColors.primary,
                                      )
                                    : AppButton(
                                        text: "Find Record",
                                        icon: Icons.search,
                                        onPressed: _handleSearch,
                                        backgroundColor: AppColors.primary,
                                      ),
                              ),

                              SizedBox(height: isDesktop ? 30 : 110),

                              Align(
                                alignment: Alignment.bottomRight,
                                child: SizedBox(
                                  height: isMobile ? 50 : 60,
                                  width: isMobile ? 180 : 100,
                                  child: AppButton(
                                    text: "Recent History",
                                    icon: Icons.history,
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const KycHistoryScreen(),
                                      ),
                                    ),
                                    backgroundColor: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
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
            Expanded(child: Divider(color: AppColors.textMuted)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'OR',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            Expanded(child: Divider(color: AppColors.textMuted)),
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
                Expanded(child: VerticalDivider(color: AppColors.textMuted)),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'OR',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                Expanded(child: VerticalDivider(color: AppColors.textMuted)),
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
        AppText(
          "Mobile Number",
          style: AppTextStyle.bodySmall,
          color: AppColors.black,
        ),
        const SizedBox(height: 6),
        TextFormField(
          maxLength: 9,
          controller: _mobileController,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            hintText: 'e.g. 987654321',
            counterText: "",
            prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primary),
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
        AppText(
          "National ID",
          style: AppTextStyle.bodySmall,
          color: AppColors.black,
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
            prefixIcon: Icon(Icons.badge_outlined, color: AppColors.primary),
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
      Snack.show(
        context,
        message: "Search by either Mobile Number or National ID",
      );
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
        colors: [AppColors.primary, AppColors.surfaceBgPurpleTranslucent],
      ),
      borderRadius: BorderRadius.circular(16),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.manage_accounts, color: AppColors.surface, size: 28),
        SizedBox(height: 8),
        AppText(
          'Find or Create Record',
          style: AppTextStyle.headlineMedium,
          color: AppColors.surface,
        ),
        SizedBox(height: 4),
        AppText(
          'Enter a Mobile Number or National ID to find an existing record.',
          style: AppTextStyle.bodySmall,
          color: AppColors.surface,
        ),
      ],
    ),
  );
}
