import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';

class CustomStepper extends StatefulWidget {
  final int currentStep;

  const CustomStepper({
    super.key,
    required this.currentStep,
  });

  @override
  State<CustomStepper> createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(CustomStepper oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentStep != widget.currentStep) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToCurrentStep();
      });
    }
  }

  void _scrollToCurrentStep() {
    if (!_scrollController.hasClients) return;
    const double itemWidth = 100;
    final targetOffset = (widget.currentStep * itemWidth) -
        MediaQuery.of(context).size.width / 3;
    _scrollController.animateTo(
      targetOffset.clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  final List<String> steps = const [
    'Coverage',
    'Customer Details',
    'Vehicle Info',
    'Policy Details',
    'Quick Comparison',
    'Purchase',
    'Success',
    'Payment'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(steps.length * 2 - 1, (index) {
            if (index.isOdd) {
              return Container(
                width: 32,
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.black, // Thick dark line segment
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }

            final stepIndex = index ~/ 2;
            final isActive = stepIndex == widget.currentStep;
            final isCompleted = stepIndex < widget.currentStep;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Step Circle
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? AppColors.k3C9718
                        : isActive
                            ? AppColors.primary
                            : AppColors.textMuted,
                  ),
                  child: Center(
                    child: Text(
                      '${stepIndex + 1}',
                      style: const TextStyle(
                        color: AppColors.surfaceTranslucent,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Step Label
                AppText(
                  steps[stepIndex],
                  style: AppTextStyle.bodySmall,
                  fontWeight: FontWeight.w500,
                  color: isActive || isCompleted
                      ? AppColors.black
                      : AppColors.labelGrey,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
