import 'package:equatable/equatable.dart';

class LoanRepaymentDetails extends Equatable {
  final String loanType; // e.g. 'Home Loan'
  final String accountNumber; // e.g. 'L-123456789'
  final String customerName;
  final double emiAmount;
  final double outstandingAmount;
  final double totalAmountDue;
  final String statusLabel; // e.g. 'Due'
  final String currencySymbol; // e.g. 'ZK'

  const LoanRepaymentDetails({
    required this.loanType,
    required this.accountNumber,
    required this.customerName,
    required this.emiAmount,
    required this.outstandingAmount,
    required this.totalAmountDue,
    this.statusLabel = 'Due',
    this.currencySymbol = 'ZK',
  });

  @override
  List<Object?> get props => [
    loanType,
    accountNumber,
    customerName,
    emiAmount,
    outstandingAmount,
    totalAmountDue,
    statusLabel,
    currencySymbol,
  ];
}

/// Formats a numeric amount with thousand separators and no decimals,
/// matching the screenshot's style: "100,000", "14,500", "1,800".
String formatAmount(double amount) {
  final intPart = amount.round().toString();
  final buffer = StringBuffer();
  for (int i = 0; i < intPart.length; i++) {
    final posFromEnd = intPart.length - i;
    buffer.write(intPart[i]);
    if (posFromEnd > 1 && posFromEnd % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}

