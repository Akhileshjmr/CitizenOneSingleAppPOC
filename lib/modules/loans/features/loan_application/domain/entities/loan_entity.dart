import 'package:equatable/equatable.dart';

class LoanEntity extends Equatable {
  final String loanId;
  final double requestedAmount;
  final int tenureMonths;
  final double monthlyRepayment;
  final String status;

  const LoanEntity({
    required this.loanId,
    required this.requestedAmount,
    required this.tenureMonths,
    required this.monthlyRepayment,
    required this.status,
  });

  @override
  List<Object?> get props => [
        loanId,
        requestedAmount,
        tenureMonths,
        monthlyRepayment,
        status,
      ];
}
