import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_state.dart';

class PaymentBreakdownCard extends StatelessWidget {
  const PaymentBreakdownCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MotorInsuranceBloc, MotorInsuranceState>(
      builder: (context, state) {
        final currency = state.selectedInsuranceQuotation?.currency ?? 'ZMW';
        final premium = state.premiumAmount;
        final fee = state.convenienceFee;
        final total = state.createQuotationResponse?.totalPayable ?? 0;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xffE6E6E6),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                'Payment Breakdown',
                style: AppTextStyle.bodyLarge,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: 16),
              _buildRow(
                  'Premium Amount', '$currency ${premium.toStringAsFixed(2)}'),
              const SizedBox(height: 12),
              _buildRow(
                  'Transaction Fee', '$currency ${fee.toStringAsFixed(2)}'),
              const SizedBox(height: 12),
              const Divider(color: Color(0xffE6E6E6), thickness: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: AppText(
                      'Total Amount',
                      style: AppTextStyle.bodyLarge,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Expanded(
                    child: AppText(
                      '$currency ${total.toStringAsFixed(2)}',
                      style: AppTextStyle.bodyLarge,
                      textAlign: TextAlign.right,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AppText(
            label,
            style: AppTextStyle.bodyMedium,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: AppText(
            value,
            style: AppTextStyle.bodyMedium,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.right,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
