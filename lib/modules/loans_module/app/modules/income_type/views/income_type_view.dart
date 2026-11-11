import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/progress_item.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/responsive_form_layout.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';

import '../../../theme/ag_text_styles.dart';
import '../controllers/income_type_controller.dart';

class IncomeTypeView extends GetView<IncomeTypeController> {
  const IncomeTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = ResponsiveFormScaffold.isWideScreen(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AgAppbar(title: 'Personal Loan'),
      bottomNavigationBar:
          isWide
              ? null
              : Obx(
                () => Visibility(
                  visible: controller.isLoading.isFalse,
                  child: ResponsiveFormActions(
                    isWide: false,
                    primaryAction: ResponsiveFormAction(
                      title: 'Next',
                      mobileTitle: 'Next',
                      icon: Icons.arrow_forward,
                      onTap: controller.onContinue,
                    ),
                  ),
                ),
              ),
      body: BaseScreen(
        isLoading: false,
        child: SingleChildScrollView(
          padding:
              isWide
                  ? const EdgeInsets.symmetric(horizontal: 48, vertical: 40)
                  : const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: Container(
                width: double.infinity,
                padding: isWide ? const EdgeInsets.all(40) : EdgeInsets.zero,
                decoration:
                    isWide
                        ? BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        )
                        : null,
                child: Column(
                  children: [
                    Row(
                      children: const [
                        ProgressItem(isActive: true),
                        SizedBox(width: 8),
                        ProgressItem(isActive: true),
                        SizedBox(width: 8),
                        ProgressItem(),
                      ],
                    ),
                    const SizedBox(height: 40),
                    const Text('Income Type', style: kw600Black20),
                    const SizedBox(height: 30),
                    Obx(() {
                      final selected = controller.incomeType.value;

                      return ResponsiveFormWrap(
                        isWide: isWide,
                        children: [
                          ResponsiveFormItem(
                            child: _incomeCard(
                              label: 'Salaried',
                              value: 'SALARIED',
                              selected: selected,
                            ),
                          ),
                          ResponsiveFormItem(
                            child: _incomeCard(
                              label: 'Non - Salaried',
                              value: 'NON_SALARIED',
                              selected: selected,
                            ),
                          ),
                        ],
                      );
                    }),
                    if (isWide) ...[
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 150,
                        child: AgButton(
                          title: 'Next',
                          onTap: controller.onContinue,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _incomeCard({
    required String label,
    required String value,
    required String selected,
  }) {
    final isSelected = selected == value;

    return GestureDetector(
      onTap: () => controller.incomeType.value = value,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        decoration: BoxDecoration(
          color: AppColors.kffffff,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 18),
              ),
          ],
        ),
      ),
    );
  }
}
