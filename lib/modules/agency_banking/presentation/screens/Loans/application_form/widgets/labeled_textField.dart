import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LabeledTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool readOnly;
  final Widget? suffixIcon;
  final int? maxLines;
  final VoidCallback? onTap;
  final int? maxLength;
  final bool isMandatory;
  final Widget? prefixIcon;
  final Color? backgroundColor;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;

  /// Default allow: alphabets, numbers, space, @ . - /
  final String allowedPattern;

  final dynamic? onChanged;

  const LabeledTextField({
    Key? key,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.suffixIcon,
    this.maxLines = 1,
    this.onTap,
    this.maxLength,
    this.isMandatory = false,
    this.prefixIcon,
    this.backgroundColor,
    this.validator,
    this.inputFormatters,

    /// 👇 Updated default allowed characters
    this.allowedPattern = r'[a-zA-Z0-9@.\-\/ ]',

    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              children: isMandatory
                  ? const [TextSpan(text: ' *', style: TextStyle(color: Colors.red))]
                  : [],
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            readOnly: readOnly,
            maxLines: maxLines,
            maxLength: maxLength,
            onTap: onTap,
            validator: validator,

            inputFormatters: inputFormatters ??
                [
                  FilteringTextInputFormatter.allow(RegExp(allowedPattern)),
                ],

            contextMenuBuilder: (context, editableTextState) {
              return AdaptiveTextSelectionToolbar.buttonItems(
                anchors: editableTextState.contextMenuAnchors,
                buttonItems: editableTextState.contextMenuButtonItems,
              );
            },
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint ?? "Enter $label",
              filled: true,
              counterText: "",
              fillColor: backgroundColor ?? AppColors.white,
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

