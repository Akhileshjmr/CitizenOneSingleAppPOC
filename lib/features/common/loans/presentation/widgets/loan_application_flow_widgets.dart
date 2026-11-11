import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';

class LoanFlowProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const LoanFlowProgressIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(totalSteps, (index) {
          final isActive = index <= currentStep;
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < totalSteps - 1 ? 4 : 0),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF6366F1)
                    : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class LoanCustomerTypeStep extends StatelessWidget {
  final String bankName;
  final bool isExistingCustomer;
  final bool hasSelection;
  final ValueChanged<bool> onSelected;

  const LoanCustomerTypeStep({
    super.key,
    required this.bankName,
    required this.isExistingCustomer,
    required this.hasSelection,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Are you an existing customer of $bankName?',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 32),
          LoanCustomerTypeCard(
            icon: LucideIcons.building,
            title: 'Yes, I have an account',
            subtitle:
                "Faster approval. We'll pre-fill your details from KYC records.",
            color: const Color(0xFFDCE9FF),
            iconColor: const Color(0xFF6366F1),
            isSelected: hasSelection && isExistingCustomer,
            onTap: () => onSelected(true),
          ),
          const SizedBox(height: 16),
          LoanCustomerTypeCard(
            icon: LucideIcons.user_plus,
            title: 'No, I am a new customer',
            subtitle: "We'll need a few more details to set up your profile.",
            color: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF16A34A),
            isSelected: hasSelection && !isExistingCustomer,
            onTap: () => onSelected(false),
          ),
        ],
      ),
    );
  }
}

class LoanCustomerTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback onTap;

  const LoanCustomerTypeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.iconColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6366F1)
                : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFF6366F1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class LoanFormLabel extends StatelessWidget {
  final String label;
  final bool required;

  const LoanFormLabel({super.key, required this.label, this.required = false});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        children: [
          TextSpan(text: label),
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Color(0xFFEF4444)),
            ),
        ],
      ),
    );
  }
}

class LoanPersonalDetailsStep extends StatelessWidget {
  final TextEditingController nrcController;
  final TextEditingController loanAmountController;
  final TextEditingController monthlyIncomeController;
  final String? employmentStatus;
  final ValueChanged<String?> onEmploymentChanged;

  const LoanPersonalDetailsStep({
    super.key,
    required this.nrcController,
    required this.loanAmountController,
    required this.monthlyIncomeController,
    required this.employmentStatus,
    required this.onEmploymentChanged,
  });

  InputDecoration _inputDecoration({String? hintText, String? prefixText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
      prefixText: prefixText,
      prefixStyle: prefixText == null
          ? null
          : const TextStyle(
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: const Row(
              children: [
                Icon(LucideIcons.info, size: 18, color: Color(0xFF3B82F6)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Please ensure all details match your official documents properly. This helps in faster processing.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1E40AF),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const LoanFormLabel(label: 'NRC / ID Number', required: true),
          const SizedBox(height: 8),
          TextField(
            controller: nrcController,
            decoration: _inputDecoration(hintText: 'e.g. 123456/78/1'),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LoanFormLabel(label: 'Loan Amount', required: true),
                    const SizedBox(height: 8),
                    TextField(
                      controller: loanAmountController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(prefixText: 'ZK  '),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LoanFormLabel(
                      label: 'Monthly Income',
                      required: true,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: monthlyIncomeController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(prefixText: 'ZK  '),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const LoanFormLabel(label: 'Employment Status', required: true),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: employmentStatus,
            decoration: _inputDecoration(hintText: 'Select Status'),
            items: const [
              DropdownMenuItem(
                value: 'Full Time Employed',
                child: Text('Full Time Employed'),
              ),
              DropdownMenuItem(
                value: 'Part Time Employed',
                child: Text('Part Time Employed'),
              ),
              DropdownMenuItem(
                value: 'Self Employed / Business',
                child: Text('Self Employed / Business'),
              ),
              DropdownMenuItem(value: 'Retired', child: Text('Retired')),
            ],
            onChanged: onEmploymentChanged,
          ),
        ],
      ),
    );
  }
}

class LoanDocumentsStep extends StatelessWidget {
  final String bankName;

  const LoanDocumentsStep({super.key, required this.bankName});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  LucideIcons.info,
                  size: 20,
                  color: Color(0xFF3B82F6),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1E40AF),
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(text: 'Since you selected '),
                        TextSpan(
                          text: bankName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const TextSpan(
                          text:
                              ', we can fetch your bank statement automatically if you provide consent.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const LoanUploadCard(
            title: 'Upload Payslip / Proof of Income',
            subtitle: 'Latest 3 months • PDF or JPG',
          ),
          const SizedBox(height: 20),
          const LoanUploadCard(
            title: 'Upload NRC Copy',
            subtitle: 'Front and Back • PDF or JPG',
          ),
        ],
      ),
    );
  }
}

class LoanUploadCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const LoanUploadCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              LucideIcons.upload,
              color: Color(0xFF64748B),
              size: 22,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }
}

class LoanReviewStep extends StatelessWidget {
  final String loanType;
  final String bankName;
  final TextEditingController nrcController;
  final TextEditingController loanAmountController;
  final TextEditingController monthlyIncomeController;
  final String? employmentStatus;
  final bool termsAccepted;
  final ValueChanged<bool> onTermsChanged;
  final VoidCallback onEditApplicant;
  final String estimatedEmi;

  const LoanReviewStep({
    super.key,
    required this.loanType,
    required this.bankName,
    required this.nrcController,
    required this.loanAmountController,
    required this.monthlyIncomeController,
    required this.employmentStatus,
    required this.termsAccepted,
    required this.onTermsChanged,
    required this.onEditApplicant,
    required this.estimatedEmi,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        LucideIcons.landmark,
                        size: 20,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loanType,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Provided by $bankName',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _LoanReviewRow(
                  label: 'Amount',
                  value: 'ZK ${loanAmountController.text}',
                ),
                const SizedBox(height: 12),
                _LoanReviewRow(
                  label: 'Estimated EMI',
                  value: '~ ZK $estimatedEmi/mo',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Applicant Details',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: onEditApplicant,
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _LoanDetailColumn(
                        label: 'NRC Number',
                        value: nrcController.text.isNotEmpty
                            ? nrcController.text
                            : '123456/12/1',
                      ),
                    ),
                    Expanded(
                      child: _LoanDetailColumn(
                        label: 'Employment',
                        value: employmentStatus ?? 'Self-Employed',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _LoanDetailColumn(
                        label: 'Monthly Income',
                        value: 'ZK ${monthlyIncomeController.text}',
                      ),
                    ),
                    const Expanded(
                      child: _LoanDetailColumn(
                        label: 'Documents',
                        value: '0 Uploaded',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: termsAccepted,
                  onChanged: (value) => onTermsChanged(value ?? false),
                  activeColor: const Color(0xFF6366F1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF475569),
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(
                        text:
                            'I confirm the details provided are accurate and authorize ',
                      ),
                      TextSpan(
                        text: bankName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const TextSpan(
                        text:
                            ' to access my credit report from TransUnion/CRB for processing this application. I agree to the ',
                      ),
                      const TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(
                          color: Color(0xFF6366F1),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class LoanSuccessStep extends StatelessWidget {
  final String loanType;
  final String bankName;

  const LoanSuccessStep({
    super.key,
    required this.loanType,
    required this.bankName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Color(0xFFD1FAE5),
              shape: BoxShape.circle,
            ),
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFA7F3D0),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.check,
                size: 40,
                color: Color(0xFF16A34A),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Application Submitted!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Your application for $loanType with $bankName has been submitted successfully.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Text(
                  'REFERENCE ID',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'LN-2026-7797',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => context.go('/loans'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Back to Loans Hub',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => context.go('/loans/status?ref=LN-2026-7797'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF6366F1),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'Track Status',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class LoanBottomButton extends StatelessWidget {
  final int currentStep;
  final bool canProceed;
  final VoidCallback onPressed;

  const LoanBottomButton({
    super.key,
    required this.currentStep,
    required this.canProceed,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: canProceed ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFFE2E8F0),
              disabledForegroundColor: const Color(0xFF94A3B8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentStep == 4
                      ? 'Back to Dashboard'
                      : (currentStep == 3 ? 'Submit Application' : 'Continue'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (currentStep < 4) ...[
                  const SizedBox(width: 8),
                  const Icon(LucideIcons.arrow_right, size: 18),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoanReviewRow extends StatelessWidget {
  final String label;
  final String value;

  const _LoanReviewRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _LoanDetailColumn extends StatelessWidget {
  final String label;
  final String value;

  const _LoanDetailColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
