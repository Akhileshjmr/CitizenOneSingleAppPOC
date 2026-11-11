import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/responsive_form_layout.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';

import '../../../data/local/store/local_store.dart';
import '../controllers/credit_third_screen_controller.dart';

class CreditThirdScreenView extends GetView<CreditThirdScreenController> {
  const CreditThirdScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = ResponsiveFormScaffold.isWideScreen(context);

    return Scaffold(
      appBar: const AgAppbar(title: ''),
      bottomNavigationBar:
          isWide
              ? null
              : ResponsiveFormActions(
                isWide: false,
                primaryAction: ResponsiveFormAction(
                  title: 'Continue',
                  mobileTitle: 'Continue',
                  icon: Icons.arrow_forward,
                  onTap: controller.onContinue,
                ),
              ),
      body: Center(
        child: SingleChildScrollView(
          padding:
              isWide
                  ? const EdgeInsets.symmetric(horizontal: 48, vertical: 40)
                  : const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
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
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                alignment: Alignment.topCenter,
                child: FormBuilder(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Nice to meet you,',
                          style: kw600Black20,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Center(
                        child: Text(
                          LocalStore.firstName() ?? '',
                          style: kw500Black26,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (isWide) ...[
                        const SizedBox(height: 24),
                        Center(
                          child: SizedBox(
                            width: 150,
                            child: AgButton(
                              onTap: controller.onContinue,
                              title: 'Continue',
                            ),
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
      ),
    );
  }
}
