import '../../domain/entities/loan_entity.dart';

class LoanModel extends LoanEntity {
  const LoanModel({
    required super.loanId,
    required super.requestedAmount,
    required super.tenureMonths,
    required super.monthlyRepayment,
    required super.status,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      loanId: json['loanId'] as String? ??
          'LN-${DateTime.now().millisecondsSinceEpoch}',
      requestedAmount: (json['requestedAmount'] as num?)?.toDouble() ?? 0.0,
      tenureMonths: json['tenureMonths'] as int? ?? 12,
      monthlyRepayment: (json['monthlyRepayment'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'APPROVED',
    );
  }
}
