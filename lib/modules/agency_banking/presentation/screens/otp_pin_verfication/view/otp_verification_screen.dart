import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../responsive/responsive_layout.dart';
import '../bloc/otp_verification_bloc.dart';
import '../bloc/otp_verification_state.dart';
import 'otp_verification_mobile.dart';
import 'otp_verification_web.dart';

/// Global, transaction-agnostic OTP Verification screen. Push this from
/// ANY flow that needs an OTP step — login, a fund transfer, changing a
/// registered mobile number, KYC, whatever comes next — and it stays
/// completely unaware of which transaction it's verifying. Each call
/// site supplies:
///
///   - [requestBody]: whatever fields THAT transaction's verify API
///     needs (txn id, amount, purpose, ...). The entered OTP is
///     automatically merged into this map under [otpFieldKey] (default
///     `'otp'`) before your [onVerify] callback is called.
///   - [onVerify]: performs the actual API call using YOUR existing Dio
///     client / repository (however your app already does networking —
///     this screen deliberately doesn't own a Dio instance itself, so
///     it never has to know your base URL, interceptors, or auth
///     headers). Return the raw response body. Throw to indicate
///     failure (wrong OTP, network error, etc.).
///   - [onVerified]: called once, after a successful verify, with that
///     raw response — do whatever the transaction needs next (read a
///     token, navigate to a confirmation screen with txn details, ...).
///
/// Example — fund transfer OTP:
/// ```dart
/// Navigator.push(context, MaterialPageRoute(
///   builder: (_) => OtpVerificationScreen(
///     title: 'Confirm Your Transfer',
///     subtitle: 'Enter the OTP sent to your registered mobile number '
///         'to complete this transfer.',
///     requestBody: {
///       'txnId': txn.id,
///       'amount': txn.amount,
///       'purpose': 'FUND_TRANSFER',
///     },
///     onVerify: (body) => transferRepository.verifyOtp(body), // your Dio call
///     onResend: (body) => transferRepository.resendOtp(body),
///     onVerified: (response) {
///       Navigator.pushReplacement(context, MaterialPageRoute(
///         builder: (_) => TransferSuccessScreen(response: response),
///       ));
///     },
///   ),
/// ));
/// ```
///
/// Example — login OTP (same screen, completely different transaction):
/// ```dart
/// OtpVerificationScreen(
///   title: 'Verify Your Identity',
///   subtitle: 'Enter the OTP sent to your registered mobile number.',
///   requestBody: {'userId': user.id, 'purpose': 'LOGIN'},
///   onVerify: (body) => authRepository.verifyOtp(body),
///   onResend: (body) => authRepository.resendOtp(body),
///   onVerified: (response) {
///     final token = response['accessToken'] as String;
///     // store token, navigate to home...
///   },
/// )
/// ```
class OtpVerificationScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final int otpLength;
  final int resendCooldownSeconds;
  final bool showResendOption;

  /// Transaction-specific fields to send alongside the OTP. Left empty
  /// by default for screens that don't need any (e.g. a bare login OTP
  /// keyed only by a session id already known to your Dio interceptor).
  final Map<String, dynamic> requestBody;

  /// The key the entered OTP is merged into [requestBody] under before
  /// being handed to [onVerify]. Defaults to `'otp'` — change this if
  /// your backend expects a different field name (e.g. `'otpCode'`).
  final String otpFieldKey;

  /// Performs the actual verify API call with YOUR Dio client. Receives
  /// `{...requestBody, otpFieldKey: enteredOtp}`. Return the raw
  /// response body; throw on failure.
  final Future<Map<String, dynamic>> Function(Map<String, dynamic> requestBody)
      onVerify;

  /// Performs the actual resend-OTP API call with YOUR Dio client.
  /// Receives [requestBody] as-is (no OTP field, since none has been
  /// entered yet at resend time).
  final Future<void> Function(Map<String, dynamic> requestBody) onResend;

  /// Called once after a successful verify, with the raw response body
  /// returned by [onVerify] — kept separate from [onVerify] so this
  /// screen doesn't need to know about routing.
  final void Function(Map<String, dynamic> response)? onVerified;

  const OtpVerificationScreen({
    super.key,
    this.title = 'One Time Verification',
    this.subtitle =
        'To help validate process, please enter the OTP by pressing on the below button.',
    this.otpLength = 6,
    this.resendCooldownSeconds = 30,
    this.showResendOption = true,
    this.requestBody = const {},
    this.otpFieldKey = 'otp',
    required this.onVerify,
    required this.onResend,
    this.onVerified,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpVerificationBloc(
        otpLength: otpLength,
        resendCooldownSeconds: resendCooldownSeconds,
      ),
      child: _OtpVerificationView(
        title: title,
        subtitle: subtitle,
        showResendOption: showResendOption,
        // Merge the entered OTP into requestBody right here, so
        // everything below this point (the Bloc, both layouts) only
        // ever deals with a plain `Future<Map> Function(String otp)` —
        // no knowledge of requestBody/otpFieldKey needs to leak
        // downward at all.
        onVerify: (otp) => onVerify({...requestBody, otpFieldKey: otp}),
        onResend: () => onResend(requestBody),
        onVerified: onVerified,
      ),
    );
  }
}

class _OtpVerificationView extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showResendOption;
  final Future<Map<String, dynamic>> Function(String otp) onVerify;
  final Future<void> Function() onResend;
  final void Function(Map<String, dynamic> response)? onVerified;

  const _OtpVerificationView({
    required this.title,
    required this.subtitle,
    required this.showResendOption,
    required this.onVerify,
    required this.onResend,
    this.onVerified,
  });

  void _handleBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<OtpVerificationBloc>();

    return BlocListener<OtpVerificationBloc, OtpVerificationState>(
      bloc: bloc,
      listenWhen: (previous, current) =>
          previous.status != OtpStatus.success &&
          current.status == OtpStatus.success,
      listener: (context, state) {
        if (state.response != null) {
          onVerified?.call(state.response!);
        }
      },
      child: ResponsiveLayout(
        mobileLayout: OtpVerificationMobileLayout(
          controller: bloc,
          onBack: () => _handleBack(context),
          onVerify: onVerify,
          onResend: onResend,
          title: title,
          subtitle: subtitle,
          showResendOption: showResendOption,
        ),
        tabletWebLayout: OtpVerificationWebLayout(
          controller: bloc,
          onBack: () => _handleBack(context),
          onVerify: onVerify,
          onResend: onResend,
          title: title,
          subtitle: subtitle,
          showResendOption: showResendOption,
        ),
      ),
    );
  }
}
