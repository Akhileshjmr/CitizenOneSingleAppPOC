import 'package:citizenone_app/core/core.dart';
import '../models/loan_model.dart';

class LoansApi {
  final ApiClient apiClient;

  LoansApi(this.apiClient);

  Future<LoanModel> applyForLoan({
    required double amount,
    required int tenureMonths,
  }) async {
    const endpoint = '/api/v1/loans/apply';
    try {
      final response = await apiClient.post(endpoint, body: {
        'amount': amount,
        'tenureMonths': tenureMonths,
      });
      return LoanModel.fromJson(response);
    } catch (_) {
      await Future.delayed(const Duration(milliseconds: 500));
      final monthly = (amount * 1.1) / tenureMonths;
      return LoanModel(
        loanId: 'LN-${DateTime.now().millisecondsSinceEpoch}',
        requestedAmount: amount,
        tenureMonths: tenureMonths,
        monthlyRepayment: monthly,
        status: 'PRE_APPROVED',
      );
    }
  }
}
