import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/design_system/molecules/quote_summary_card.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_state.dart';

class QuoteStepWidget extends StatelessWidget {
  const QuoteStepWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MotorInsuranceBloc, MotorInsuranceState>(
      builder: (context, state) {
        // final dateFormat = DateFormat('dd MMM yyyy');
        // final periodString =
        //     '${dateFormat.format(state.startDate)} - ${dateFormat.format(state.endDate)}';
        final policyForString = state.isForMyself;

        return Column(
          children: [
            QuoteSummaryCard(
              coverage: state.coverageType,
              policyFor: policyForString,
            ),
            const SizedBox(height: 16),

            // Additional Vehicle & Driver details card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x05000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    'Application Details',
                    style: AppTextStyle.bodyLarge,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  const Divider(
                      height: 24, thickness: 1, color: Color(0xFFF1F5F9)),
                  // _buildDetailRow('Vehicle Info', '${state.vehicleMakeModel} (${state.vehicleYear})'),
                  const SizedBox(height: 10),
                  _buildDetailRow('Reg Number', state.vehicleRegNo),
                  const SizedBox(height: 10),
                  _buildDetailRow('License Number', state.driverLicense),
                  const SizedBox(height: 10),
                  _buildDetailRow('Add-ons Selected', _getAddonsText(state)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Big Premium display container
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF613AF5), Color(0xFF8B5CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF613AF5).withValues(alpha:  0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText(
                          'Estimated Total Premium',
                          style: AppTextStyle.caption,
                          color: Colors.white70,
                        ),
                        const SizedBox(height: 4),
                        AppText(
                          '\$${state.calculatedPremium.toStringAsFixed(2)} / year',
                          style: AppTextStyle.headlineMedium,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          label,
          style: AppTextStyle.caption,
          color: AppColors.textSecondary,
        ),
        AppText(
          value,
          style: AppTextStyle.bodySmall,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ],
    );
  }

  String _getAddonsText(MotorInsuranceState state) {
    final List<String> list = [];
    if (state.zeroDepSelected) list.add('Zero Dep');
    if (state.roadsideSelected) list.add('Roadside');
    if (state.engineSelected) list.add('Engine Protection');
    if (list.isEmpty) return 'None';
    return list.join(', ');
  }
}
