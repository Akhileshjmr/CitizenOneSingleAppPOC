import 'dart:math';
import 'package:flutter/material.dart';
import 'package:citizenone_app/components/foundation/glass_container.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/components/foundation/primary_button.dart';

class EMICalculatorWidget extends StatefulWidget {
  const EMICalculatorWidget({super.key});

  @override
  State<EMICalculatorWidget> createState() => _EMICalculatorWidgetState();
}

class _EMICalculatorWidgetState extends State<EMICalculatorWidget> {
  double _amount = 500000;
  double _rate = 8.5;
  double _tenure = 5; // Years

  double get _emi {
    // EMI = [P x R x (1+R)^N]/[(1+R)^N-1]
    // R is monthly rate
    double r = _rate / 12 / 100;
    double n = _tenure * 12;
    if (r == 0) return _amount / n;
    return (_amount * r * pow(1 + r, n)) / (pow(1 + r, n) - 1);
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'EMI Calculator',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 24),
          _buildSlider('Loan Amount', _amount, 10000, 5000000, '\$${_amount.toStringAsFixed(0)}', (val) {
             setState(() => _amount = val);
          }),
          const SizedBox(height: 16),
          _buildSlider('Interest Rate', _rate, 1, 20, '${_rate.toStringAsFixed(1)}%', (val) {
             setState(() => _rate = val);
          }),
          const SizedBox(height: 16),
          _buildSlider('Tenure (Years)', _tenure, 1, 30, '${_tenure.toStringAsFixed(1)} Yr', (val) {
             setState(() => _tenure = val);
          }),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Monthly EMI', style: TextStyle(color: AppColors.textSecondary)),
                Text(
                  '\$${_emi.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            text: 'Apply Now',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Starting Loan Application Application...')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, String displayValue, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textSecondary)),
            Text(displayValue, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.surfaceLight,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
