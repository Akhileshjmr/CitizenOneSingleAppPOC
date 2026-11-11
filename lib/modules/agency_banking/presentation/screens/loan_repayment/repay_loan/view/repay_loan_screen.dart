import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../responsive/responsive_layout.dart';
import '../bloc/repay_loan_bloc.dart';
import '../widgets/loan_repayment_details.dart';
import 'repay_loan_mobile.dart';
import 'repay_loan_web.dart';

/// Repay Loan screen — shown after the user picks an account from
/// "Select Loan Account" (taps "Proceed"). Push with the account's
/// [details] and a callback for what happens once the amount is
/// validated (typically: open the OTP screen with the amount in its
/// requestBody).
///
/// ```dart
/// Navigator.push(context, MaterialPageRoute(
///   builder: (_) => RepayLoanScreen(
///     details: LoanRepaymentDetails(
///       loanType: account.loanType,
///       accountNumber: account.accountNumber,
///       customerName: account.customerName,
///       outstandingAmount: 45000,
///       minimumDueAmount: 5200,
///       dueDate: 'Due on 15 Aug 2026',
///     ),
///     onProceed: (amount) => Navigator.push(context, MaterialPageRoute(
///       builder: (_) => OtpVerificationScreen(
///         requestBody: {'accountId': account.id, 'amount': amount},
///         onVerify: (body) => loanRepository.verifyPaymentOtp(body),
///         onResend: (body) => loanRepository.resendPaymentOtp(body),
///         onVerified: (response) => Navigator.pushReplacement(...),
///       ),
///     )),
///   ),
/// ));
/// ```
class RepayLoanScreen extends StatelessWidget {
  final LoanRepaymentDetails details;
  final void Function(double amount) onProceed;

  const RepayLoanScreen({
    super.key,
    required this.details,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RepayLoanBloc(details: details),
      child: _RepayLoanView(onProceed: onProceed),
    );
  }
}

class _RepayLoanView extends StatelessWidget {
  final void Function(double amount) onProceed;
  const _RepayLoanView({required this.onProceed});

  void _handleBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RepayLoanBloc>();

    return ResponsiveLayout(
      mobileLayout: RepayLoanMobileLayout(
        controller: bloc,
        onBack: () => _handleBack(context),
        onProceed: onProceed,
      ),
      tabletWebLayout: RepayLoanWebLayout(
        controller: bloc,
        onBack: () => _handleBack(context),
        onProceed: onProceed,
      ),
    );
  }
}
