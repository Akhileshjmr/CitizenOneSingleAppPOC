import 'package:citizenone_app/modules/agency_banking/presentation/screens/loan_repayment/loan_account_search/widgets/common_question_tile.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/loan_repayment/loan_account_search/widgets/search_info_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/form/app_button.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/form/app_or_devider.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/theme/app_theme_style.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/form/app_text_field.dart';
import '../../../otp_pin_verfication/view/otp_verification_screen.dart';
import '../bloc/loan_search_bloc.dart';
import '../bloc/loan_search_state.dart';

/// Web / desktop / tablet layout for the Loan EMI Repayment account search
/// screen. Same content and behavior as the mobile layout, but arranged
/// for wide viewports: a centered form card (so it never stretches edge
/// to edge on a 1920px browser window) alongside a branding panel that
/// appears once there's enough width for it.
///
/// Internally responsive across three widths so it works in *every*
/// browser window, not just one fixed "web" size:
///   >= 1100 : branding panel + form side by side
///   700-1099: form only, centered, comfortable max width
///   600-699 : form only, tighter padding (large phone / small tablet)
class LoanSearchWebLayout extends StatelessWidget {
  final LoanSearchBloc controller;
  final VoidCallback onBack;
  final Future<void> Function() onSearch;
  final VoidCallback? onFindLoanNumberTap;
  final VoidCallback? onCheckEmiScheduleTap;

  const LoanSearchWebLayout({
    super.key,
    required this.controller,
    required this.onBack,
    required this.onSearch,
    this.onFindLoanNumberTap,
    this.onCheckEmiScheduleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          _WebHeader(onBack: onBack),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bool showBrandingPanel = constraints.maxWidth >= 1100;
                final double formMaxWidth = constraints.maxWidth >= 1100
                    ? 460
                    : constraints.maxWidth >= 700
                    ? 520
                    : double.infinity;

                final form = _FormColumn(
                  controller: controller,
                  onSearch: onSearch,
                  onFindLoanNumberTap: onFindLoanNumberTap,
                  onCheckEmiScheduleTap: onCheckEmiScheduleTap,
                  maxWidth: formMaxWidth,
                );

                if (!showBrandingPanel) {
                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 40),
                      child: form,
                    ),
                  );
                }

                return Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: const _BrandingPanel(),
                    ),
                    Expanded(
                      flex: 6,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 48, vertical: 48),
                        child: Center(child: form),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WebHeader extends StatelessWidget {
  final VoidCallback onBack;
  const _WebHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardBg,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
            onPressed: onBack,
          ),
          const SizedBox(width: 8),
          const Text('CitizenOne', style: AppThemeStyle.headerTitle),
        ],
      ),
    );
  }
}

/// Left-hand branding / reassurance panel shown on wide (>=1100px) screens.
class _BrandingPanel extends StatelessWidget {
  const _BrandingPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: const Color(0xFFEFF1F8),
      padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primaryPurple,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.account_balance,
                color: Colors.white, size: 28),
          ),
          const SizedBox(height: 28),
          const Text('Repay your loan EMI\nin a few clicks',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryText,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Look up your loan account using your account number or '
                'registered mobile number to view details and make a secure '
                'payment.',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.secondaryText,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          const _TrustRow(
              icon: Icons.lock_outline, label: 'Bank-grade secure payments'),
          const SizedBox(height: 14),
          const _TrustRow(
              icon: Icons.bolt_outlined, label: 'Instant account lookup'),
          const SizedBox(height: 14),
          const _TrustRow(
              icon: Icons.support_agent, label: '24/7 customer support'),
        ],
      ),
    );
  }
}

class _TrustRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TrustRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primaryPurple),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }
}

/// The form itself (title, card, common questions) — shared between the
/// "form only, centered" and "branding + form" wide-screen arrangements.
///
/// StatefulWidget (not Stateless), for the same reason as the mobile
/// layout: AppTextField has no built-in Form/validator support — the
/// caller must compute isValid/errorText and pass them in, which means
/// this per-field error state has to live somewhere that can setState().
class _FormColumn extends StatefulWidget {
  final LoanSearchBloc controller;
  final Future<void> Function() onSearch;
  final VoidCallback? onFindLoanNumberTap;
  final VoidCallback? onCheckEmiScheduleTap;
  final double maxWidth;

  const _FormColumn({
    required this.controller,
    required this.onSearch,
    required this.onFindLoanNumberTap,
    required this.onCheckEmiScheduleTap,
    required this.maxWidth,
  });

  @override
  State<_FormColumn> createState() => _FormColumnState();
}

class _FormColumnState extends State<_FormColumn> {
  String? _loanAccountError;
  String? _mobileNumberError;

  /// Same two-layer validation as the mobile layout: per-field format
  /// checks here (only if the OR-field isn't empty), then the Bloc's own
  /// "at least one of Loan Account / Mobile" cross-field check runs once
  /// the event is dispatched.
  void _handleSubmit() {
    final loanValue = widget.controller.loanAccountController.text.trim();
    final mobileValue = widget.controller.mobileNumberController.text.trim();

    String? loanError;
    String? mobileError;

    if (loanValue.isNotEmpty && loanValue.length < 6) {
      loanError = 'Enter a valid loan account number';
    }
    if (mobileValue.isNotEmpty &&
        !RegExp(r'^[0-9]{10}$').hasMatch(mobileValue)) {
      mobileError = 'Enter a valid 10-digit mobile number';
    }

    setState(() {
      _loanAccountError = loanError;
      _mobileNumberError = mobileError;
    });

    if (loanError != null || mobileError != null) {
      return;
    }

   // widget.controller.add(LoanSearchSubmitted(onValidSearch: widget.onSearch));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpVerificationScreen(
          title: 'Confirm Your Transfer',
          subtitle: 'Enter the OTP sent to your registered mobile number.',
          requestBody: {
            'loanAccount': loanValue,
          },

          onVerify: (mergedBody) async {
            // Temporary dummy response
            return {
              "status": true,
              "message": "OTP Verified Successfully",
            };
          },

          /*onResend: (body) async {
            // Temporary dummy response
            return {
              "status": true,
              "message": "OTP Sent Successfully",
            };
          },*/
          onResend: (body) async => <String, dynamic>{
            "status": true,
            "message": "OTP Sent Successfully",
          },

          onVerified: (response) {
            print(response);

            // Navigate to next screen if required
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: widget.maxWidth),
      child: BlocBuilder<LoanSearchBloc, LoanSearchState>(
        bloc: widget.controller,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Loan EMI Repayment', style: AppThemeStyle.pageTitle),
              const SizedBox(height: 8),
              const Text(
                'Search your loan account to proceed with the secure payment.',
                style: AppThemeStyle.pageSubtitle,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius:
                  BorderRadius.circular(AppThemeStyle.cardRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      label: 'Loan Account Number',
                      hintText: 'e.g. 123456878018',
                      controller: widget.controller.loanAccountController,
                      focusNode: widget.controller.loanAccountFocus,
                      inputType: TextInputType.number,
                      isMandatory: false,
                      isFocus: true,
                      isValid: _loanAccountError == null,
                      errorText: _loanAccountError,
                      onChanged: (_) {
                        if (_loanAccountError != null) {
                          setState(() => _loanAccountError = null);
                        }
                      },
                    ),
                    const SizedBox(height: 6),
                    const OrDivider(),
                    const SizedBox(height: 6),
                    AppTextField(
                      label: 'Registered Mobile Number',
                      hintText: 'e.g. 9876543210',
                      controller: widget.controller.mobileNumberController,
                      focusNode: widget.controller.mobileNumberFocus,
                      inputType: TextInputType.phone,
                      maxLength: 10,
                      isMandatory: false,
                      isFocus: true,
                      isValid: _mobileNumberError == null,
                      errorText: _mobileNumberError,
                      onChanged: (_) {
                        if (_mobileNumberError != null) {
                          setState(() => _mobileNumberError = null);
                        }
                      },
                    ),
                    AppTextField(
                      label: 'Customer ID (Optional)',
                      hintText: 'Enter unique Customer ID',
                      controller: widget.controller.customerIdController,
                      focusNode: widget.controller.customerIdFocus,
                      isMandatory: false,
                      isFocus: true,
                    ),
                    const SizedBox(height: 4),
                    SearchInfoBanner(errorText: state.errorText),
                    const SizedBox(height: 20),
                    state.isSubmitting
                        ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.4),
                        ),
                      ),
                    )
                        : AppButton(
                      title: 'Search Account',
                      fullWidth: true,
                      enabledColor: AppColors.primaryPurple,
                      onPressed: _handleSubmit,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Text('Common Questions', style: AppThemeStyle.sectionLabel),
              const SizedBox(height: 12),
              CommonQuestionTile(
                icon: Icons.help_outline,
                label: 'Where can I find my loan number?',
                onTap: widget.onFindLoanNumberTap,
              ),
              const SizedBox(height: 10),
              CommonQuestionTile(
                icon: Icons.history,
                label: 'Check EMI Schedule',
                onTap: widget.onCheckEmiScheduleTap,
              ),
            ],
          );
        },
      ),
    );
  }
}

