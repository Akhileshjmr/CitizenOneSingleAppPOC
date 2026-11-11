import 'package:citizenone_app/features/common/loans/domain/entities/loan_offer.dart';
import 'package:citizenone_app/features/common/loans/domain/entities/loan_application.dart';
import 'package:citizenone_app/features/common/loans/domain/repositories/loan_repository.dart';

class LoanRepositoryImpl implements LoanRepository {
  @override
  Future<List<LoanOffer>> getLoanOffers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockLoanOffers;
  }

  @override
  Future<List<LoanApplication>> getLoanApplications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockLoanApplications;
  }
}

// Mock data moved from loan_provider.dart
final List<LoanOffer> _mockLoanOffers = [
  const LoanOffer(
    id: '1',
    bankName: 'Zanaco',
    bankLogo: 'assets/banks/zanaco.png',
    interestRate: 12.5,
    tenure: '12-60 months',
    processingFee: 1.5,
    emi: 2400,
    maxAmount: 500000,
    features: ['Quick Disbursal', 'No Pre-closure charges'],
    isPreApproved: true,
  ),
  const LoanOffer(
    id: '2',
    bankName: 'FNB Zambia',
    bankLogo: 'assets/banks/fnb.png',
    interestRate: 13.0,
    tenure: '12-48 months',
    processingFee: 1.0,
    emi: 2400,
    maxAmount: 350000,
    features: ['Online Application', 'Flexible Tenure'],
    isPreApproved: true,
  ),
  const LoanOffer(
    id: '3',
    bankName: 'Absa Bank',
    bankLogo: 'assets/banks/absa.png',
    interestRate: 11.8,
    tenure: '6-72 months',
    processingFee: 2.0,
    emi: 2400,
    maxAmount: 600000,
    features: ['High Loan Amount', 'Doorstep Service'],
    isPreApproved: true,
  ),
  const LoanOffer(
    id: '4',
    bankName: 'Indo Zambia',
    bankLogo: 'assets/banks/indo.png',
    interestRate: 11.5,
    tenure: '12-60 months',
    processingFee: 1.2,
    emi: 2400,
    maxAmount: 450000,
    features: ['Low Interest', 'Fast Approval'],
    isPreApproved: false,
  ),
];

final List<LoanApplication> _mockLoanApplications = [
  LoanApplication(
    id: '1',
    loanType: 'Personal Loan',
    bankName: 'Zanaco',
    amount: 50000,
    referenceNumber: 'LN-2024-8892',
    status: 'Credit Scoring',
    lastUpdate: DateTime(2024, 2, 1),
    progressPercentage: 0.45,
  ),
  LoanApplication(
    id: '2',
    loanType: 'Vehicle Loan',
    bankName: 'FNB Zambia',
    amount: 120000,
    referenceNumber: 'LN-2023-1102',
    status: 'Approved',
    lastUpdate: DateTime(2023, 11, 15),
    progressPercentage: 1.0,
  ),
];
