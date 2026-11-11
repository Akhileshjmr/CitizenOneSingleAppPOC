import 'package:equatable/equatable.dart';

/// How urgently this loan needs the customer's attention — drives the
/// badge color (amber vs green in the reference screenshot). Kept
/// generic (not loan-specific wording) so the same enum/badge pairing
/// can be reused for other "status pill" use cases across the app.
enum LoanAccountUrgency { attentionNeeded, upToDate }

class LoanAccountSummary extends Equatable {
  final String id;
  final String loanType; // e.g. 'Home Loan'
  final String accountNumber; // e.g. 'L-123456789'
  final String customerName;
  final String statusLabel; // e.g. 'Due'
  //final LoanAccountUrgency urgency;

  /// true → card shows a "Proceed" button (this loan needs action now).
  /// false → card shows a "View Details" link (already in good standing).
  final bool requiresAction;

  const LoanAccountSummary({
    required this.id,
    required this.loanType,
    required this.accountNumber,
    required this.customerName,
    required this.statusLabel,
    //required this.urgency,
    required this.requiresAction,
  });

  @override
  List<Object?> get props => [
        id,
        loanType,
        accountNumber,
        customerName,
        statusLabel,
       // urgency,
        requiresAction,
      ];
}
