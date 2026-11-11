import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../responsive/responsive_layout.dart';
import '../bloc/review_bloc.dart';
import '../bloc/review_state.dart';
import 'review_mobile.dart';
import 'review_web.dart';

/// Review screen — the confirmation step between "Repay Loan" and OTP
/// verification. Push with the account/customer/amount to display, and
/// an [onSubmit] that performs the actual submit API call (e.g.
/// initiate the payment / generate a transaction id for the OTP step).
///
/// ```dart
/// // From RepayLoanScreen's onProceed:
/// onProceed: (amount) {
///   Navigator.push(context, MaterialPageRoute(
///     builder: (_) => ReviewScreen(
///       accountNumber: details.accountNumber,
///       customerName: details.customerName,
///       paymentAmountFormatted:
///           '${details.currencySymbol} ${formatAmount(amount)}',
///       onSubmit: () => loanRepository.initiatePayment(
///         accountNumber: details.accountNumber,
///         amount: amount,
///       ),
///       onSubmitted: (response) {
///         Navigator.push(context, MaterialPageRoute(
///           builder: (_) => OtpVerificationScreen(
///             requestBody: {
///               'txnId': response['txnId'],
///               'amount': amount,
///             },
///             onVerify: (body) => loanRepository.verifyPaymentOtp(body),
///             onResend: (body) => loanRepository.resendPaymentOtp(body),
///             onVerified: (r) => Navigator.pushReplacement(...),
///           ),
///         ));
///       },
///     ),
///   ));
/// }
/// ```
class ReviewScreen extends StatelessWidget {
  final String accountNumber;
  final String customerName;
  final String paymentAmountFormatted;
  final Future<Map<String, dynamic>> Function() onSubmit;
  final void Function(Map<String, dynamic> response)? onSubmitted;

  const ReviewScreen({
    super.key,
    required this.accountNumber,
    required this.customerName,
    required this.paymentAmountFormatted,
    required this.onSubmit,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReviewBloc(),
      child: _ReviewView(
        accountNumber: accountNumber,
        customerName: customerName,
        paymentAmountFormatted: paymentAmountFormatted,
        onSubmit: onSubmit,
        onSubmitted: onSubmitted,
      ),
    );
  }
}

class _ReviewView extends StatelessWidget {
  final String accountNumber;
  final String customerName;
  final String paymentAmountFormatted;
  final Future<Map<String, dynamic>> Function() onSubmit;
  final void Function(Map<String, dynamic> response)? onSubmitted;

  const _ReviewView({
    required this.accountNumber,
    required this.customerName,
    required this.paymentAmountFormatted,
    required this.onSubmit,
    this.onSubmitted,
  });

  void _handleBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ReviewBloc>();

    return BlocListener<ReviewBloc, ReviewState>(
      bloc: bloc,
      listenWhen: (previous, current) =>
          previous.status != ReviewStatus.success &&
          current.status == ReviewStatus.success,
      listener: (context, state) {
        if (state.response != null) {
          onSubmitted?.call(state.response!);
        }
      },
      child: ResponsiveLayout(
        mobileLayout: ReviewMobileLayout(
          controller: bloc,
          onBack: () => _handleBack(context),
          accountNumber: accountNumber,
          customerName: customerName,
          paymentAmountFormatted: paymentAmountFormatted,
          onSubmit: onSubmit,
        ),
        tabletWebLayout: ReviewWebLayout(
          controller: bloc,
          onBack: () => _handleBack(context),
          accountNumber: accountNumber,
          customerName: customerName,
          paymentAmountFormatted: paymentAmountFormatted,
          onSubmit: onSubmit,
        ),
      ),
    );
  }
}
