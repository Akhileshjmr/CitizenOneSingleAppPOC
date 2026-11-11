import 'package:citizenone_app/modules/agency_banking/core/widgets/form/app_button.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/form/app_text.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/loan_repayment/loan_account_search/widgets/common_question_tile.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/loan_repayment/loan_account_search/widgets/search_info_banner.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:citizenone_app/modules/agency_banking/core/widgets/form/app_or_devider.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/form/app_text_field.dart';
import 'package:citizenone_app/modules/agency_banking/theme/app_theme_style.dart';
import '../../../otp_pin_verfication/view/otp_verification_screen.dart';
import '../../loan_account_selection/view/loan_account_selection_screen.dart';
import '../../loan_account_selection/widgets/loan_account_summary.dart';
import '../bloc/loan_search_bloc.dart';
import '../bloc/loan_search_event.dart';
import '../bloc/loan_search_state.dart';

/// Mobile layout for the Loan EMI Repayment account search screen.
/// Matches the reference screenshot: back arrow + "CitizenOne" header,
/// title/subtitle, a white card with two search fields separated by an
/// "OR" divider, an optional Customer ID field, an info banner, a full-
/// width Search Account button, and a "Common Questions" list below.
///
/// NOTE: this is a StatefulWidget, not Stateless. AppTextField has no
/// built-in Form/validator support — it expects the CALLER to compute
/// `isValid`/`errorText` and pass them in. That means per-field error
/// state has to live somewhere that can setState(), so it lives here.
/// Cross-field logic (the "at least one of these two" OR-rule) still
/// lives in LoanSearchBloc, same as before — this widget only handles
/// per-field format checks (e.g. "that doesn't look like 10 digits").

class LoanSearchMobileLayout extends StatefulWidget {
  final LoanSearchBloc controller;
  final VoidCallback onBack;
  final Future<void> Function() onSearch;
  final VoidCallback? onFindLoanNumberTap;
  final VoidCallback? onCheckEmiScheduleTap;

  const LoanSearchMobileLayout({
    super.key,
    required this.controller,
    required this.onBack,
    required this.onSearch,
    this.onFindLoanNumberTap,
    this.onCheckEmiScheduleTap,
  });

  @override
  State<LoanSearchMobileLayout> createState() => _LoanSearchMobileLayoutState();
}

class _LoanSearchMobileLayoutState extends State<LoanSearchMobileLayout> {
  String? _loanAccountError;
  String? _mobileNumberError;

  /// Runs per-field format validation, then (only if those pass)
  /// dispatches the submit event — which is where the Bloc's own
  /// cross-field "at least one of Loan Account / Mobile" check runs.
  void _handleSubmit() {
    final loanValue = widget.controller.loanAccountController.text.trim();
    final mobileValue = widget.controller.mobileNumberController.text.trim();

    String? loanError;
    String? mobileError;

    // Both fields are optional individually (OR-rule), so only validate
    // format if the user actually typed something.
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
      return; // stop here — inline field errors are now visible
    }
    widget.controller.add(LoanSearchSubmitted(onValidSearch: widget.onSearch));
    //widget.controller.add(LoanSearchSubmitted(onValidSearch: widget.onSearch));
   /* Navigator.push(context, MaterialPageRoute(
      builder: (_) => OtpVerificationScreen(
        title: 'Confirm Your Transfer',
        subtitle: 'Enter the OTP sent to your registered mobile number.',
        requestBody: {
          'txnId': txn.id,
          'amount': txn.amount,
          'purpose': 'FUND_TRANSFER',
        },
        onVerify: (mergedBody) => transferRepository.verifyOtp(mergedBody), // ← your Dio call
        onResend: (body) => transferRepository.resendOtp(body),
        onVerified: (response) {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (_) => TransferSuccessScreen(response: response),
          ));
        },
      ),
    ));*/



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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => LoanAccountSelectionScreen(
                  fetchAccounts: () async {
                    return [
                      const LoanAccountSummary(
                        id: '1',
                        loanType: 'Home Loan',
                        accountNumber: 'LN123456789',
                        customerName: 'John Doe',
                        statusLabel: 'Active',
                       // urgency: LoanUrgency.normal,
                        requiresAction: false,
                      ),
                      const LoanAccountSummary(
                        id: '2',
                        loanType: 'Vehicle Loan',
                        accountNumber: 'LN987654321',
                        customerName: 'John Doe',
                        statusLabel: 'Overdue',
                       // urgency: LoanUrgency.high,
                        requiresAction: true,
                      ),
                    ];
                  },
                  onProceed: (account) {
                    print('Proceed: ${account.accountNumber}');
                  },
                  onViewDetails: (account) {
                    print('View Details: ${account.accountNumber}');
                  },
                ),
              ),
            );          // Navigate to next screen if required
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _MobileHeader(onBack: widget.onBack),
            Expanded(
              child: BlocBuilder<LoanSearchBloc, LoanSearchState>(
                bloc: widget.controller,
                builder: (context, state) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText('Loan EMI Repayment',style: AppThemeStyle.pageTitle,),
                        /*const Text('Loan EMI Repayment',
                            style: AppThemeStyle.pageTitle),*/
                        const SizedBox(height: 8),
                        /*const Text(
                          'Search your loan account to proceed with the secure payment.',
                          style: AppThemeStyle.pageSubtitle,
                        ),*/
                        AppText('Search your loan account to proceed with the secure payment.',style: AppThemeStyle.pageSubtitle),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius:
                                BorderRadius.circular(AppThemeStyle.cardRadius),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTextField(
                                label: 'Loan Account Number',
                                hintText: 'e.g. 123456878018',
                                controller:
                                    widget.controller.loanAccountController,
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
                              const SizedBox(height: 4),
                              const OrDivider(),
                              const SizedBox(height: 4),
                              AppTextField(
                                label: 'Registered Mobile Number',
                                hintText: 'e.g. 9876543210',
                                controller:
                                    widget.controller.mobileNumberController,
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
                                controller:
                                    widget.controller.customerIdController,
                                focusNode: widget.controller.customerIdFocus,
                                isMandatory: false,
                                isFocus: true,
                              ),
                              const SizedBox(height: 2),
                              SearchInfoBanner(errorText: state.errorText),
                              const SizedBox(height: 18),
                              state.isSubmitting
                                  ? const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 14),
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
                        /*const Text('Common Questions',
                            style: AppThemeStyle.sectionLabel),*/
                        AppText('Common Questions',style: AppThemeStyle.sectionLabel),
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _MobileHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardBg,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
            onPressed: onBack,
          ),
          const SizedBox(width: 4),
          const Text('CitizenOne', style: AppThemeStyle.headerTitle),
        ],
      ),
    );
  }
}
