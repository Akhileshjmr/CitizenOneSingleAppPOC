import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_event.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_state.dart';

import '../../../../core/adaptive/adaptive_layout.dart';

class MotorInsurancePolicyDetailsScreen extends StatefulWidget {
  const MotorInsurancePolicyDetailsScreen({super.key});

  @override
  State<MotorInsurancePolicyDetailsScreen> createState() =>
      _MotorInsurancePolicyDetailsScreenState();
}

class _MotorInsurancePolicyDetailsScreenState
    extends State<MotorInsurancePolicyDetailsScreen> {
  String? _selectedIdv;
  static const _idvOptions = ['Select', 'Low', 'Medium', 'High'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MotorInsuranceBloc, MotorInsuranceState>(
      builder: (context, state) {
        final String durationLabel = '${state.selectedQuarters * 3} months';

        final policyDurations = state.policyDurationList ?? [];
        return SingleChildScrollView(
          child: Column(
            children: [
              // ── Vehicle Info Header Card ──
              ShadowCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Vehicle plate + Modify
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: AppText(
                              '${state.vehicleData?.registrationNumber ?? ''} - ${state.vehicleData?.make ?? ''} ${state.vehicleData?.model ?? ''}',
                              style: AppTextStyle.headlineSmall),
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     context
                        //         .read<MotorInsuranceBloc>()
                        //         .add(PrevStepEvent());
                        //   },
                        //   child: const AppText(
                        //     'Modify',
                        //     style: AppTextStyle.caption,
                        //     decoration: TextDecoration.underline,
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Plan & IDV row
                    Row(
                      children: [
                        Expanded(
                          child: LabelledDropdown(
                            label: 'Plan',
                            value: state.selectedPlan?.value ??
                                state.planTypeList?.first.value,
                            items: state.planTypeList
                                    ?.map((e) => e.value ?? '')
                                    .toList() ??
                                [],
                            onChanged: (v) {
                              if (v == null) return;

                              final selectedPlan =
                                  state.planTypeList!.firstWhere(
                                (plan) => plan.value == v,
                              );

                              context.read<MotorInsuranceBloc>().add(
                                    MotorInsuranceSelectPlanEvent(selectedPlan),
                                  );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: IgnorePointer(
                              ignoring: true,
                              child: Opacity(
                                opacity: 0.5,
                                child: IgnorePointer(
                                  ignoring: true,
                                  child: LabelledDropdown(
                                    label: 'IDV',
                                    value: _selectedIdv,
                                    hint: 'Select',
                                    items: _idvOptions,
                                    onChanged: (v) {
                                      if (v != null) {
                                        setState(() => _selectedIdv = v);
                                      }
                                    },
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // const Divider(color: AppColors.border, height: 40),
                    // // Add-on row
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: LabelledDropdown(
                    //         label: 'Plan',
                    //         value: 'Zero Depreciation',
                    //         items: const [
                    //           'Zero Depreciation',
                    //           'Roadside Assistance',
                    //           'Engine Protection',
                    //         ],
                    //         onChanged: (_) {},
                    //       ),
                    //     ),
                    //     const SizedBox(width: 12),
                    //     Expanded(
                    //       child: ActionDropdown(
                    //         value: 'View all',
                    //         items: const ['View all', 'Add-ons'],
                    //         onChanged: (_) {},
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              ShadowCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText('Policy Duration',
                        style: AppTextStyle.headlineMedium),
                    const SizedBox(height: 4),
                    const AppText('Select your policy duration',
                        style: AppTextStyle.bodyLarge),
                    const SizedBox(height: 20),

                    // Start Date
                    if (AdaptiveLayout.isDesktop(context))
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return SizedBox(
                            width: constraints.maxWidth / 2,
                            child: _StartDateField(
                              state: state,
                              onPick: (picked) => context
                                  .read<MotorInsuranceBloc>()
                                  .add(UpdatePolicyDetailsEvent(
                                    coverageType: state.coverageType,
                                    startDate: picked,
                                  )),
                            ),
                          );
                        },
                      )
                    else
                      _StartDateField(
                        state: state,
                        onPick: (picked) => context
                            .read<MotorInsuranceBloc>()
                            .add(UpdatePolicyDetailsEvent(
                              coverageType: state.coverageType,
                              startDate: picked,
                            )),
                      ),
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount =
                            AdaptiveLayout.isMobile(context) ? 2 : 4;
                        const spacing = 12.0;

                        final itemWidth = (constraints.maxWidth -
                                spacing * (crossAxisCount - 1)) /
                            crossAxisCount;

                        // Responsive height with min/max limits
                        final itemHeight =
                            (itemWidth * 0.9).clamp(110.0, 130.0);

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: policyDurations.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: spacing,
                            mainAxisSpacing: spacing,
                            mainAxisExtent: itemHeight,
                          ),
                          itemBuilder: (context, index) {
                            final duration = policyDurations[index];
                            final quarters = duration.quarters ?? 1;
                            final months = duration.months ?? 3;

                            return _QuarterTile(
                              number: quarters,
                              label: quarters == 1 ? 'Quarter' : 'Quarters',
                              duration: '$months Months',
                              selected: state.selectedQuarters == quarters,
                              onTap: () {
                                context
                                    .read<MotorInsuranceBloc>()
                                    .add(UpdateSelectedQuarterEvent(quarters));
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  String _fmtDate(DateTime d) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day} ${months[d.month]} ${d.year}';
  }
}

class _StartDateField extends StatelessWidget {
  final MotorInsuranceState state;
  final ValueChanged<DateTime> onPick;

  const _StartDateField({
    required this.state,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'Start Date',
          style: AppTextStyle.bodyLarge,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: state.startDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) {
              onPick(picked);
            }
          },
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFC6C6C6)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  '${state.startDate.day.toString().padLeft(2, '0')}/'
                  '${state.startDate.month.toString().padLeft(2, '0')}/'
                  '${state.startDate.year}',
                  style: AppTextStyle.bodyLarge,
                  color: AppColors.labelGrey,
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: Color(0xFF393939),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuarterTile extends StatelessWidget {
  final int number;
  final String label;
  final String duration;
  final bool selected;
  final VoidCallback onTap;

  const _QuarterTile({
    required this.number,
    required this.label,
    required this.duration,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.brandLavender : Colors.white,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.surfaceLight,
            width: selected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppText(
              '$number',
              style: AppTextStyle.headlineMedium,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 2),
            AppText(
              label,
              style: AppTextStyle.titleSmall,
              color: AppColors.serviceHeaderTitle,
            ),
            const SizedBox(height: 2),
            AppText(
              duration,
              style: AppTextStyle.bodyLarge,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }
}

class _TenureRow extends StatelessWidget {
  final String label;
  final String value;
  const _TenureRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.serviceHeaderTitle,
          height: 1.5,
        ),
        children: [
          TextSpan(text: '$label : '),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class ShadowCard extends StatelessWidget {
  final Widget child;
  const ShadowCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: AppColors.border,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: child,
      );
}

class LabelledDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final String? hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const LabelledDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label,
            style: AppTextStyle.bodyLarge, fontWeight: FontWeight.w500),
        const SizedBox(height: 6),
        Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFC6C6C6)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: hint != null
                  ? Text(
                      hint!,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary),
                    )
                  : null,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down,
                  size: 20, color: Color(0xFF393939)),
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textPrimary),
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Action Dropdown (View all)
// ─────────────────────────────────────────────────────────────────────────────

class ActionDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const ActionDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Invisible label to align with sibling
        const Text(
          ' ',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFC6C6C6)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down,
                  size: 20, color: Color(0xFF393939)),
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF212121),
              ),
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
