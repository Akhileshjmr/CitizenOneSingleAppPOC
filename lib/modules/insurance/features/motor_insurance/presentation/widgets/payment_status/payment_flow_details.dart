// =============================================================================
// PaymentFlowDetails — formats MotorInsuranceState into the values the
// Payment Failed and Policy Issuance Failed screens need, hiding (returning
// null for) anything the state doesn't have yet rather than showing
// "null"/"NA" placeholders. Shared by both result screens so the same
// quote/payment-derivation logic isn't duplicated.
// =============================================================================

import 'package:intl/intl.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_state.dart';

class PaymentFlowDetails {
  const PaymentFlowDetails({
    required this.referenceNumber,
    required this.hostRefNumber,
    required this.policyNumber,
    required this.coveragePeriod,
    required this.vehicle,
    required this.premiumAmount,
    required this.convenienceFee,
    required this.totalAmount,
    required this.canRetryPayment,
    required this.hasIssuedPolicy,
    required this.selectedPaymentMethod,
    required this.reason,
  });

  final String? referenceNumber;
  final String? hostRefNumber;
  final String? policyNumber;
  final String? coveragePeriod;
  final String? vehicle;
  final String? premiumAmount;
  final String? convenienceFee;
  final String? totalAmount;
  final String? selectedPaymentMethod;

  /// True only when the payment call itself never succeeded (the bloc
  /// clears [MotorInsuranceState.paymentSuccessEntity] on payment failure).
  /// If payment succeeded but the later policy-issuance call failed, the
  /// amount has already been charged, so retrying payment is not offered.
  final bool canRetryPayment;

  /// True once a policy has actually been issued for this attempt.
  final bool hasIssuedPolicy;

  /// Failure reason surfaced from the API (`state.submissionError`), shown
  /// in the "Reason" box on the Payment Failed screen.
  final String? reason;

  /// Safe fallback used when [from] fails to derive details from a
  /// malformed/partial state — renders blank rows and disables retry/view
  /// actions rather than crashing the screen.
  const PaymentFlowDetails.empty()
      : referenceNumber = null,
        hostRefNumber = null,
        policyNumber = null,
        coveragePeriod = null,
        vehicle = null,
        premiumAmount = null,
        convenienceFee = null,
        totalAmount = null,
        canRetryPayment = false,
        hasIssuedPolicy = false,
        selectedPaymentMethod = null,
        reason = null;

  factory PaymentFlowDetails.from(MotorInsuranceState state) {
    final quote = state.createQuotationResponse;
    final risk = (quote?.risks.isNotEmpty ?? false) ? quote!.risks.first : null;
    final vehicle = risk?.vehicle;
    final currency =
        quote?.currency ?? state.selectedInsuranceQuotation?.currency;

    String? money(double? amount) => amount == null
        ? null
        : '${currency ?? ''} ${amount.toStringAsFixed(2)}'.trim();

    final premium =
        state.premiumAmount > 0 ? state.premiumAmount : quote?.totalPremium;
    final fee =
        quote == null ? null : (quote.gatewayCharge + quote.platformCharge);

    return PaymentFlowDetails(
        referenceNumber: _orNull(quote?.referenceNumber) ??
            _orNull(quote?.transactionNumber),
        hostRefNumber: quote?.hostRefNumber,
        policyNumber: _orNull(quote?.policyNumber),
        coveragePeriod: _formatPeriod(quote?.startDate, quote?.endDate),
        vehicle: vehicle == null
            ? null
            : '${vehicle.registrationNumber} | ${vehicle.make} '
                '${vehicle.model} (${vehicle.color})',
        premiumAmount: money(premium),
        convenienceFee: (fee != null && fee > 0) ? money(fee) : null,
        totalAmount: money(quote?.totalPayable),
        canRetryPayment: state.paymentSuccessEntity == null,
        hasIssuedPolicy: state.issuePolicyByQuoteIdResponse?.data != null,
        selectedPaymentMethod: state.selectedPaymentMethod,
        reason: _orNull(state.submissionError));
  }

  static String? _orNull(String? value) =>
      (value == null || value.isEmpty) ? null : value;

  static String? _formatPeriod(String? start, String? end) {
    final startDate = start == null ? null : DateTime.tryParse(start);
    final endDate = end == null ? null : DateTime.tryParse(end);
    if (startDate == null || endDate == null) return null;
    final fmt = DateFormat('dd/MM/yyyy');
    return '${fmt.format(startDate)} - ${fmt.format(endDate)}';
  }
}
