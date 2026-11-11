import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/progress_item.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/responsive_form_layout.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';

import '../../../components/ui/ag_button.dart';
import '../../../components/ui/text_field/app_textfield.dart';
import '../controllers/monthly_income_controller.dart';

class MonthlyIncomeView extends GetView<MonthlyIncomeController> {
  const MonthlyIncomeView({super.key});

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

      body: Obx(
        () => BaseScreen(
          isLoading: controller.isLoading.value,
          child: SingleChildScrollView(
            padding:
                isWide
                    ? const EdgeInsets.symmetric(horizontal: 48, vertical: 40)
                    : const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

            // ✅ FIX 1: Center wrapper added
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),

                child: Container(
                  width: double.infinity,
                  padding: isWide ? const EdgeInsets.all(40) : EdgeInsets.zero,
                  decoration:
                      isWide
                          ? BoxDecoration(
                            color: AppColors.kffffff,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          )
                          : null,

                  child: Column(
                    // ✅ FIX 2: Center alignment
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _progressBar(),

                      const SizedBox(height: 40),

                      const Text(
                        'Monthly Income',
                        style: kw600Black20,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: isWide ? 420 : double.infinity,
                        child: FormBuilder(
                          key: controller.formKey,
                          child: AppTextField(
                            name: 'borrow_amount',
                            title: 'Monthly Income *',
                            hintText: 'Monthly Income',
                            controller: controller.monthlyIncomeController,
                            keyboardType: TextInputType.number,
                            validator: controller.incomeValidator,
                            inputType: AppTextInputType.numberOnly,
                            maxLength: 8,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      if (isWide)
                        SizedBox(
                          width: 150,
                          child: AgButton(
                            title: 'Next',
                            onTap: controller.onContinue,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _progressBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        ProgressItem(isActive: true),
        SizedBox(width: 8),
        ProgressItem(isActive: true),
        SizedBox(width: 8),
        ProgressItem(isActive: true),
      ],
    );
  }
}
