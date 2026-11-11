import 'package:citizenone_app/modules/insurance/core/presentation/widgets/spacing.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';

class AppDropDown<T> extends StatelessWidget {
  const AppDropDown({
    required this.name,
    required this.items,
    this.hintText,
    this.labelText,
    this.borderRadius = 6,
    this.labelStyle,
    this.validator,
    this.initialValue,
    this.onChanged,
    this.borderColor,
    this.hasBorder = true,
    this.hasUnderLineBorder = false,
    super.key,
  });

  final String name;
  final String? hintText;
  final String? labelText;
  final Color? borderColor;
  final bool hasUnderLineBorder;
  final bool hasBorder;
  final double borderRadius;
  final TextStyle? labelStyle;
  final FormFieldValidator<T>? validator;
  final T? initialValue;
  final void Function(T?)? onChanged;
  final List<DropdownMenuItem<T>> items;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (labelText != null) ...<Widget>[
          labelText!.contains('*')
              ? RichText(
                  text: TextSpan(
                    style: labelStyle ?? Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(text: labelText!.replaceAll('*', '')),
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: tokens.error),
                      ),
                    ],
                  ),
                )
              : Text(
                  labelText!,
                  style: labelStyle ?? Theme.of(context).textTheme.bodySmall,
                ),
          const VSpace(4),
        ],
        DropdownButtonFormField<T>(
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          decoration: InputDecoration(
            hintText: hintText,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            enabledBorder: _buildOutlineInputBorder(tokens),
            focusedBorder: _buildOutlineInputBorder(tokens),
            fillColor: Colors.white,
            filled: true,
          ),
          validator: validator,
          items: items,
          initialValue: initialValue,
          onChanged: onChanged,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          dropdownColor: Colors.white,
        ),
      ],
    );
  }

  InputBorder _buildOutlineInputBorder(AppThemeTokens tokens) => !hasBorder
      ? UnderlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(borderRadius),
        )
      : hasUnderLineBorder
          ? UnderlineInputBorder(
              borderSide: BorderSide(
                color: borderColor ?? tokens.outline,
                width: 2,
              ),
            )
          : OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor ?? tokens.outline),
            );
}
