// =============================================================================
// AmountInputField  —  MOLECULE
// -----------------------------------------------------------------------------
// Combines: BaseTextField + currency prefix label + numeric input formatting
// + reusable amount validator.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/extensions/build_context_x.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/validators.dart';
import '../atoms/atoms.dart';

class AmountInputField extends StatelessWidget {
  const AmountInputField({
    super.key,
    this.controller,
    this.label = 'Amount',
    this.currencySymbol = '\$',
    this.onChanged,
    this.validator,
    this.maxLength = 12,
  });

  final TextEditingController? controller;
  final String label;
  final String currencySymbol;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText.label(label),
        const AppSpacer.xs(),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.radiusMd),
                  bottomLeft: Radius.circular(AppSpacing.radiusMd),
                ),
                border: Border.all(color: context.colors.border),
              ),
              child: AppText(currencySymbol, variant: AppTextVariant.subtitle),
            ),
            Expanded(
              child: BaseTextField(
                controller: controller,
                hint: '0.00',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: validator ?? Validators.amount,
                onChanged: onChanged,
                maxLength: maxLength,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
