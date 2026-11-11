import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/features/common/loans/presentation/widgets/loan_application_flow_widgets.dart';

class LoanApplicationFlowScreen extends StatefulWidget {
  final String loanType;
  final String? bankName;

  const LoanApplicationFlowScreen({
    super.key,
    required this.loanType,
    this.bankName,
  });

  @override
  State<LoanApplicationFlowScreen> createState() => _LoanApplicationFlowScreenState();
}

class _LoanApplicationFlowScreenState extends State<LoanApplicationFlowScreen> {
  int _currentStep = 0;
  bool _isExistingCustomer = false;
  bool _hasSelectedCustomerType = false;
  bool _termsAccepted = false;

  // Form controllers
  final TextEditingController _nrcController = TextEditingController();
  final TextEditingController _loanAmountController = TextEditingController(text: '5000');
  final TextEditingController _monthlyIncomeController = TextEditingController(text: '1000');
  String? _employmentStatus;

  @override
  void dispose() {
    _nrcController.dispose();
    _loanAmountController.dispose();
    _monthlyIncomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Column(
          children: [
            Text(
              widget.loanType,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'STEP ${_currentStep + 1} OF 5',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          LoanFlowProgressIndicator(currentStep: _currentStep),
          Expanded(
            child: _buildStepContent(),
          ),
          if (_currentStep != 4)
            LoanBottomButton(
              currentStep: _currentStep,
              canProceed: _canProceed(),
              onPressed: _handleContinue,
            ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1CustomerType();
      case 1:
        return _buildStep2PersonalDetails();
      case 2:
        return _buildStep3Documents();
      case 3:
        return _buildStep4Review();
      case 4:
        return _buildStep5Success();
      default:
        return const SizedBox();
    }
  }

  // Step 1: Customer Type Selection
  Widget _buildStep1CustomerType() {
    return LoanCustomerTypeStep(
      bankName: widget.bankName ?? 'Zanaco',
      isExistingCustomer: _isExistingCustomer,
      hasSelection: _hasSelectedCustomerType,
      onSelected: (isExisting) {
        setState(() {
          _hasSelectedCustomerType = true;
          _isExistingCustomer = isExisting;
        });
      },
    );
  }

  // Step 2: Personal Details
  Widget _buildStep2PersonalDetails() {
    return LoanPersonalDetailsStep(
      nrcController: _nrcController,
      loanAmountController: _loanAmountController,
      monthlyIncomeController: _monthlyIncomeController,
      employmentStatus: _employmentStatus,
      onEmploymentChanged: (value) {
        setState(() => _employmentStatus = value);
      },
    );
  }

  // Step 3: Documents
  Widget _buildStep3Documents() {
    return LoanDocumentsStep(
      bankName: widget.bankName ?? 'Zanaco',
    );
  }

  // Step 4: Review & Confirmation
  Widget _buildStep4Review() {
    return LoanReviewStep(
      loanType: widget.loanType,
      bankName: widget.bankName ?? 'Zanaco',
      nrcController: _nrcController,
      loanAmountController: _loanAmountController,
      monthlyIncomeController: _monthlyIncomeController,
      employmentStatus: _employmentStatus,
      termsAccepted: _termsAccepted,
      onTermsChanged: (value) {
        setState(() => _termsAccepted = value);
      },
      onEditApplicant: () {
        setState(() => _currentStep = 1);
      },
      estimatedEmi: _calculateEMI(),
    );
  }

  // Step 5: Success
  Widget _buildStep5Success() {
    return LoanSuccessStep(
      loanType: widget.loanType,
      bankName: widget.bankName ?? 'Zanaco',
    );
  }

  String _calculateEMI() {
    final amount = double.tryParse(_loanAmountController.text) ?? 5000;
    // Simple EMI calculation (amount / 24 months * 1.12 for interest)
    final emi = (amount / 24 * 1.12).round();
    return emi.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _hasSelectedCustomerType;
      case 1:
        return _nrcController.text.isNotEmpty &&
            _loanAmountController.text.isNotEmpty &&
            _monthlyIncomeController.text.isNotEmpty &&
            _employmentStatus != null;
      case 2:
        return true; // Documents are optional for now
      case 3:
        return _termsAccepted; // Must accept terms to submit
      case 4:
        return true;
      default:
        return false;
    }
  }

  void _handleContinue() {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
    } else {
      // Go back to dashboard
      context.go('/loans');
    }
  }
}
