import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/design_system/design_system.dart';

// --- Step 2: Eligibility Check ---
class LoanEligibilityScreen extends StatefulWidget {
  const LoanEligibilityScreen({super.key});

  @override
  State<LoanEligibilityScreen> createState() => _LoanEligibilityScreenState();
}

class _LoanEligibilityScreenState extends State<LoanEligibilityScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AppText(
          l10n.loansCheckEligibilityTitle,
          style: AppTextStyle.bodyLarge,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              l10n.loansEligibilityHeadline,
              style: AppTextStyle.headlineMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            AppText(
              l10n.loansEligibilitySubheadline,
              style: AppTextStyle.bodyMedium,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 32),
            _buildLabeledField(l10n.loansLabelMonthlyIncome),
            const SizedBox(height: 8),
            AppTextField(
              hintText: 'e.g. 50000',
              prefixIcon: AppAssets.iconMoney,
            ),
            const SizedBox(height: 20),
            _buildLabeledField(l10n.loansLabelEmploymentType),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              items: [
                DropdownMenuItem(
                  value: 'Salaried',
                  child: AppText(
                    l10n.loansEmploymentFullTime,
                    style: AppTextStyle.bodyMedium,
                  ),
                ),
                DropdownMenuItem(
                  value: 'Self-Employed',
                  child: AppText(
                    l10n.loansEmploymentSelfEmployed,
                    style: AppTextStyle.bodyMedium,
                  ),
                ),
              ],
              onChanged: (v) {},
              hint: AppText(
                l10n.loansLabelEmploymentType,
                style: AppTextStyle.bodyMedium,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 20),
            _buildLabeledField(l10n.loansLabelCity),
            const SizedBox(height: 8),
            AppTextField(
              hintText: 'e.g. Lusaka',
              prefixIcon: AppAssets.iconBuilding,
            ),
            const SizedBox(height: 20),
            _buildLabeledField(l10n.loansLabelPan),
            const SizedBox(height: 8),
            AppTextField(
              hintText: 'Check credit score',
              prefixIcon: AppAssets.iconCreditCard,
            ),
            const SizedBox(height: 40),
            AppButton(
              text: l10n.loansActionCheckOffers,
              onPressed: () => context.push('/loans/recommendation'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledField(String label) {
    return AppText(
      label,
      style: AppTextStyle.bodySmall,
      fontWeight: FontWeight.bold,
    );
  }
}

// --- Step 3: AI Recommendation ---
class AILoanRecommendationScreen extends StatelessWidget {
  const AILoanRecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: AppText(
          l10n.loansAiAnalysisTitle,
          style: AppTextStyle.bodyLarge,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E7FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      LucideIcons.sparkles,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    AppText(
                      l10n.loansAiBestMatch,
                      style: AppTextStyle.bodySmall,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x4D4F46E5),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  AppText(
                    'HDFC Personal Loan',
                    style: AppTextStyle.headlineMedium,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    l10n.loansAiBestMatchSubtitle,
                    style: AppTextStyle.bodyMedium,
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildRecStat('10.5%', l10n.loansInterestRateLabel),
                      Container(width: 1, height: 40, color: Colors.white24),
                      _buildRecStat('5 Lac', l10n.loansLabelAmount),
                      Container(width: 1, height: 40, color: Colors.white24),
                      _buildRecStat('5 Yrs', l10n.loansLabelTenureYears),
                    ],
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: l10n.loansActionProceedWithOffer,
                    onPressed: () => context.push('/loans/apply'),
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            AppText(
              l10n.loansCompareWithOthers,
              style: AppTextStyle.bodyMedium,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            AppButton(
              text: l10n.loansActionViewComparisonTable,
              onPressed: () => context.push('/loans/compare'),
              variant: AppButtonVariant.outline,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecStat(String val, String label) {
    return Column(
      children: [
        AppText(
          val,
          style: AppTextStyle.headlineSmall,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        AppText(label, style: AppTextStyle.labelSmall, color: Colors.white70),
      ],
    );
  }
}

// --- Step 4: Comparison ---
class LoanComparisonScreen extends StatelessWidget {
  const LoanComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: AppText(
          l10n.loansCompareTitle,
          style: AppTextStyle.bodyLarge,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCompareHeader(),
          _buildCompareRow(
            l10n.loansLabelInterestRate,
            '10.5%',
            '10.75%',
            '11.0%',
          ),
          _buildCompareRow(
            l10n.loansLabelFee,
            'ZK 1,500',
            'ZK 2,000',
            'ZK 999',
          ),
          _buildCompareRow(
            l10n.loansLabelTenureYears,
            '5 Yrs',
            '5 Yrs',
            '4 Yrs',
          ),
          _buildCompareRow(
            l10n.loansLabelMonthlyEmi,
            'ZK 2,450',
            'ZK 2,480',
            'ZK 2,510',
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Select HDFC',
                  onPressed: () => context.push('/loans/apply'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppButton(
                  text: 'Select ICICI',
                  onPressed: () => context.push('/loans/apply'),
                  variant: AppButtonVariant.outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompareHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Expanded(flex: 2, child: SizedBox()),
          Expanded(
            flex: 2,
            child: Center(
              child: AppText(
                'HDFC',
                style: AppTextStyle.bodySmall,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: AppText(
                'ICICI',
                style: AppTextStyle.bodySmall,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: AppText(
                'Axis',
                style: AppTextStyle.bodySmall,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompareRow(String label, String v1, String v2, String v3) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AppText(
              label,
              style: AppTextStyle.bodySmall,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: AppText(
                v1,
                style: AppTextStyle.bodySmall,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(child: AppText(v2, style: AppTextStyle.bodySmall)),
          ),
          Expanded(
            flex: 2,
            child: Center(child: AppText(v3, style: AppTextStyle.bodySmall)),
          ),
        ],
      ),
    );
  }
}

// --- Step 5: Application Form ---
class LoanApplicationScreen extends StatefulWidget {
  const LoanApplicationScreen({super.key});

  @override
  State<LoanApplicationScreen> createState() => _LoanApplicationScreenState();
}

class _LoanApplicationScreenState extends State<LoanApplicationScreen> {
  int _step = 0;
  int? _activeField;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: AppText(
          l10n.loansApplicationTitle,
          style: AppTextStyle.bodyLarge,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _step,
        onStepContinue: () {
          if (_step < 2) {
            setState(() => _step++);
          } else {
            context.go('/loans/status');
          }
        },
        onStepCancel: () {
          if (_step > 0) setState(() => _step--);
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: _step == 2
                        ? l10n.loansActionSubmitApplication
                        : l10n.loansActionContinue,
                    onPressed: details.onStepContinue ?? () {},
                  ),
                ),
                if (_step > 0) ...[
                  const SizedBox(width: 16),
                  AppButton(
                    text: l10n.loansActionBackToHome,
                    onPressed: details.onStepCancel ?? () {},
                    variant: AppButtonVariant.ghost,
                    width: null,
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          Step(
            title: AppText(
              l10n.loansStepPersonal,
              style: AppTextStyle.labelSmall,
            ),
            content: Column(
              children: [
                AnimatedInputWrapper(
                  isActive: _activeField == 0,
                  child: Focus(
                    onFocusChange: (f) =>
                        setState(() => _activeField = f ? 0 : null),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedInputWrapper(
                  isActive: _activeField == 1,
                  child: Focus(
                    onFocusChange: (f) =>
                        setState(() => _activeField = f ? 1 : null),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            isActive: _step >= 0,
          ),
          Step(
            title: AppText(l10n.loansStepKyc, style: AppTextStyle.labelSmall),
            content: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.upload),
                      const SizedBox(width: 8),
                      AppText(
                        l10n.loansUploadPayslip,
                        style: AppTextStyle.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.upload),
                      const SizedBox(width: 8),
                      AppText(
                        l10n.loansUploadNrc,
                        style: AppTextStyle.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            isActive: _step >= 1,
          ),
          Step(
            title: AppText(
              l10n.loansStepReview,
              style: AppTextStyle.labelSmall,
            ),
            content: AppText(
              l10n.loansApplicantDetails,
              style: AppTextStyle.bodyMedium,
            ),
            isActive: _step >= 2,
          ),
        ],
      ),
    );
  }
}

// --- Step 6: Status ---
class LoanStatusScreen extends StatelessWidget {
  const LoanStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SuccessCheckAnimation(size: 100),
              const SizedBox(height: 32),
              AppText(
                l10n.loansSubmittedTitle,
                style: AppTextStyle.headlineMedium,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: 16),
              AppText(
                l10n.loansSubmittedDescription,
                textAlign: TextAlign.center,
                style: AppTextStyle.bodyMedium,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 48),
              AppButton(
                text: l10n.loansActionBackToHome,
                onPressed: () => context.go('/home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
