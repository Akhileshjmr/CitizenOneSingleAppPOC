import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/blocs/insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/blocs/insurance_state.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/widgets/insurance_comparison_dialog.dart';

class ComparisonBar extends StatelessWidget {
  const ComparisonBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InsuranceBloc, InsuranceState>(
      builder: (context, state) {
        if (state.count <= 1) return const SizedBox.shrink();

        return Container(
          height: 99,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          decoration: BoxDecoration(
            color: AppColors.textMain,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: AppColors.textMain.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16,
                    child: AppText(
                      '${state.count} bank${state.count > 1 ? 's' : ''} selected',
                      style: AppTextStyle.bodySmall,
                      color: AppColors.surfaceTranslucent,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const SizedBox(
                    height: 20,
                    child: AppText(
                      'Compare Offers',
                      style: AppTextStyle.bodySmall,
                      color: AppColors.surfaceTranslucent,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                height: 32,
                child: ElevatedButton(
                  onPressed: state.canCompare
                      ? () => openInsuranceComparisonBottomSheet(context)
                      : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.surface,
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const SizedBox(
                    height: 16,
                    child: AppText(
                      'View Comparison',
                      style: AppTextStyle.displaySmall,
                      color: AppColors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
