import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/core/theme/tokens/typography.dart';

class EmiCalculatorScreen extends StatefulWidget {
  const EmiCalculatorScreen({super.key});

  @override
  State<EmiCalculatorScreen> createState() => _EmiCalculatorScreenState();
}

class _EmiCalculatorScreenState extends State<EmiCalculatorScreen> {
  double _loanAmount = 50000;
  double _interestRate = 12.5;
  double _tenure = 12; // in months

  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _interestRateController = TextEditingController();
  final TextEditingController _tenureController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateControllers();
  }

  @override
  void dispose() {
    _loanAmountController.dispose();
    _interestRateController.dispose();
    _tenureController.dispose();
    super.dispose();
  }

  void _updateControllers() {
    _loanAmountController.text = _loanAmount.toStringAsFixed(0);
    _interestRateController.text = _interestRate.toStringAsFixed(1);
    _tenureController.text = _tenure.toStringAsFixed(0);
  }

  double _calculateEMI() {
    if (_loanAmount <= 0 || _interestRate <= 0 || _tenure <= 0) return 0;

    double monthlyRate = _interestRate / (12 * 100);
    double emi =
        _loanAmount *
        monthlyRate *
        math.pow(1 + monthlyRate, _tenure) /
        (math.pow(1 + monthlyRate, _tenure) - 1);

    return emi.isFinite ? emi : 0;
  }

  double _calculateTotalInterest() {
    double emi = _calculateEMI();
    return (emi * _tenure) - _loanAmount;
  }

  double _calculateTotalPayable() {
    return _calculateEMI() * _tenure;
  }

  void _showInputDialog(
    String title,
    double currentValue,
    double min,
    double max,
    Function(double) onChanged, {
    String suffix = '',
  }) {
    final controller = TextEditingController(
      text: currentValue.toStringAsFixed(
        title.contains('Rate') || title.contains('%') ? 1 : 0,
      ),
    );
    final tokens = context.appTokens;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: tokens.surface,
        title: AppText(
          title,
          style: AppTextStyle.bodyLarge,
          fontWeight: FontWeight.bold,
        ),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: AppTypography.bodyMedium(
            context,
          ).copyWith(color: tokens.textPrimary),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            suffixText: suffix,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText(
              context.l10n.loansActionCancel,
              color: tokens.textSecondary,
            ),
          ),
          FilledButton(
            onPressed: () {
              double? value = double.tryParse(controller.text);
              if (value != null && value >= min && value <= max) {
                onChanged(value);
                Navigator.pop(context);
              }
            },
            child: AppText(context.l10n.loansActionApply, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final emi = _calculateEMI();
    final totalInterest = _calculateTotalInterest();
    final totalPayable = _calculateTotalPayable();
    final tokens = context.appTokens;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: tokens.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.arrow_left, color: tokens.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: AppText(
          l10n.loansEmiCalcTitle,
          style: AppTextStyle.bodyLarge,
          fontWeight: FontWeight.w600,
          color: tokens.textPrimary,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Loan Amount Slider
            _buildSliderCard(
              title: l10n.loansLabelAmount,
              value: _loanAmount,
              min: 1000,
              max: 500000,
              prefix: 'ZK ',
              onChanged: (val) => setState(() => _loanAmount = val),
              tokens: tokens,
            ),

            const SizedBox(height: 16),

            // Interest Rate Slider
            _buildSliderCard(
              title: l10n.loansLabelInterestRate,
              value: _interestRate,
              min: 1,
              max: 30,
              suffix: '%',
              decimalDigits: 1,
              onChanged: (val) => setState(() => _interestRate = val),
              tokens: tokens,
            ),

            const SizedBox(height: 16),

            // Tenure Slider
            _buildSliderCard(
              title: l10n.loansLabelTenure,
              value: _tenure,
              min: 3,
              max: 84,
              suffix: ' M',
              divisions: 81,
              onChanged: (val) => setState(() => _tenure = val),
              tokens: tokens,
            ),

            const SizedBox(height: 24),

            // EMI Result Donut Chart
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: tokens.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: tokens.surfaceMuted),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Donut Chart
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CustomPaint(
                      painter: DonutChartPainter(
                        principal: _loanAmount,
                        interest: totalInterest,
                        primaryColor: tokens.primary,
                        accentColor: const Color(0xFFF97316),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText(
                              l10n.loansLabelMonthlyEmi,
                              style: AppTextStyle.labelSmall,
                              color: tokens.textSecondary,
                            ),
                            const SizedBox(height: 4),
                            AppText(
                              'ZK ${emi.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                              style: AppTextStyle.headlineMedium,
                              fontWeight: FontWeight.bold,
                              color: tokens.textPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Principal Amount
                  _buildResultRow(
                    label: l10n.loansLabelPrincipalAmount,
                    value:
                        'ZK ${_loanAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                    color: tokens.primary,
                    tokens: tokens,
                  ),

                  const SizedBox(height: 12),

                  // Total Interest
                  _buildResultRow(
                    label: l10n.loansLabelTotalInterest,
                    value:
                        'ZK ${totalInterest.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                    color: const Color(0xFFF97316),
                    tokens: tokens,
                  ),

                  const SizedBox(height: 20),

                  // Total Payable
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          l10n.loansLabelTotalPayable,
                          style: AppTextStyle.bodyMedium,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        AppText(
                          'ZK ${totalPayable.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                          style: AppTextStyle.bodyLarge,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Disclaimer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppText(
                l10n.loansEmiDisclaimer,
                style: AppTextStyle.labelSmall,
                fontSize: 11,
                color: tokens.textSecondary,
                fontStyle: FontStyle.italic,
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderCard({
    required String title,
    required double value,
    required double min,
    required double max,
    String prefix = '',
    String suffix = '',
    int decimalDigits = 0,
    int? divisions,
    required Function(double) onChanged,
    required dynamic tokens,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.surfaceMuted),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                title,
                style: AppTextStyle.bodyMedium,
                fontWeight: FontWeight.w600,
                color: tokens.textPrimary,
              ),
              GestureDetector(
                onTap: () => _showInputDialog(
                  title,
                  value,
                  min,
                  max,
                  onChanged,
                  suffix: suffix,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: tokens.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AppText(
                    '$prefix${value.toStringAsFixed(decimalDigits).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}$suffix',
                    style: AppTextStyle.bodySmall,
                    fontWeight: FontWeight.w600,
                    color: tokens.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: tokens.primary,
              inactiveTrackColor: tokens.surfaceMuted,
              thumbColor: Colors.white,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayColor: tokens.primary.withValues(alpha: 0.2),
              trackHeight: 4,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                '$prefix${min.toStringAsFixed(0)}$suffix',
                style: AppTextStyle.labelSmall,
                color: tokens.textSecondary,
              ),
              AppText(
                '$prefix${(max / 1000).toStringAsFixed(0)}K$suffix',
                style: AppTextStyle.labelSmall,
                color: tokens.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow({
    required String label,
    required String value,
    required Color color,
    required dynamic tokens,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            AppText(
              label,
              style: AppTextStyle.bodySmall,
              color: tokens.textSecondary,
            ),
          ],
        ),
        AppText(
          value,
          style: AppTextStyle.bodyMedium,
          fontWeight: FontWeight.w600,
          color: tokens.textPrimary,
        ),
      ],
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final double principal;
  final double interest;
  final Color primaryColor;
  final Color accentColor;

  DonutChartPainter({
    required this.principal,
    required this.interest,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final strokeWidth = 30.0;

    final total = principal + interest;
    final principalSweep = (principal / total) * 2 * math.pi;
    final interestSweep = (interest / total) * 2 * math.pi;

    // Principal arc
    final principalPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2,
      principalSweep,
      false,
      principalPaint,
    );

    // Interest arc
    final interestPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2 + principalSweep,
      interestSweep,
      false,
      interestPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
