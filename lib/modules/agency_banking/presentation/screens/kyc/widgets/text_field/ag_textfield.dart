import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/text_field/app_text_field_config.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/text_field/app_text_field_formatters.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/text_field/app_text_field_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';

enum AppTextInputType {
  text,
  stringOnly,
  numberOnly,
  decimal,
  alphaNumeric,
  email,
  phone,
  password,
}

class AppTextField extends StatefulWidget {
  final String name;

  final String? label;
  final String? title;
  final String? initialValue;
  final String? hintText;
  final String? requiredText;

  final bool obscureText;
  final bool readOnly;
  final bool isEnabled;
  final bool isRequired;
  final bool filled;
  final bool hasUnderLineBorder;
  final bool hasBorder;
  final bool isDense;
  final bool showCursor;
  final bool autoCorrect;
  final bool validateIfNotEmpty;

  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final int? minLength;
  final int decimalRange;

  final double borderRadius;

  final Color? borderColor;
  final Color? backgroundColor;
  final Color? fillColor;

  final TextStyle? labelStyle;
  final TextStyle? inputTextStyle;
  final TextStyle? titleStyle;
  final TextStyle? hintStyle;

  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? titlePadding;

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;

  final AppTextInputType inputType;
  final FloatingLabelBehavior? floatingLabelBehavior;

  final Widget? suffixIcon;
  final Widget? prefixIcon;

  final Function()? onTap;
  final Function(String)? onSubmitted;
  final Function(String?)? onChanged;

  final FormFieldValidator<String>? validator;

  final FocusNode? focusNode;
  final bool? autoFocus;
  final AutovalidateMode? autoValidateMode;

  const AppTextField({
    super.key,
    required this.name,
    this.label,
    this.title,
    this.hintText,
    this.requiredText,
    this.initialValue,
    this.obscureText = false,
    this.readOnly = false,
    this.showCursor = true,
    this.validator,
    this.controller,
    this.labelStyle,
    this.inputTextStyle,
    this.hintStyle,
    this.floatingLabelBehavior,
    this.keyboardType,
    this.inputFormatters,
    this.inputType = AppTextInputType.text,
    this.maxLength,
    this.minLength,
    this.decimalRange = 2,
    this.borderRadius = 8,
    this.contentPadding,
    this.onChanged,
    this.hasUnderLineBorder = false,
    this.hasBorder = true,
    this.focusNode,
    this.onSubmitted,
    this.isDense = false,
    this.filled = false,
    this.fillColor,
    this.isEnabled = true,
    this.autoValidateMode,
    this.prefixIcon,
    this.maxLines = 1,
    this.minLines = 1,
    this.borderColor,
    this.backgroundColor,
    this.isRequired = false,
    this.autoFocus,
    this.titlePadding = const EdgeInsets.only(bottom: 4),
    this.titleStyle,
    this.onTap,
    this.suffixIcon,
    this.textInputAction,
    this.autoCorrect = false,
    this.validateIfNotEmpty = true,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured =
        widget.obscureText || widget.inputType == AppTextInputType.password;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Padding(
              padding: widget.titlePadding!,
              child: widget.title!.contains('*')
                  ? RichText(
                      text: TextSpan(
                        style: widget.titleStyle,
                        children: [
                          TextSpan(text: widget.title!.replaceAll('*', '')),
                          const TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    )
                  : Text(widget.title!, style: widget.titleStyle),
            ),
          FormBuilderTextField(
            name: widget.name,
            controller: widget.controller,
            initialValue:
                widget.controller == null ? widget.initialValue : null,
            readOnly: widget.readOnly,
            enabled: widget.isEnabled,
            focusNode: widget.focusNode,
            autofocus: widget.autoFocus ?? false,
            obscureText: _isObscured,
            style: widget.inputTextStyle,
            keyboardType: widget.keyboardType ??
                AppTextFieldConfig.getKeyboardType(widget.inputType),
            inputFormatters: widget.inputFormatters ??
                AppTextFieldFormatters.getFormatters(
                  widget.inputType,
                  maxLength: widget.maxLength,
                  decimalRange: widget.decimalRange,
                ),
            textInputAction: widget.textInputAction,
            autocorrect: widget.autoCorrect,
            enableSuggestions: !_isObscured,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            maxLength: widget.maxLength ??
                AppTextFieldConfig.getDefaultMaxLength(widget.inputType),
            autovalidateMode:
                widget.autoValidateMode ?? AutovalidateMode.onUserInteraction,
            validator: (value) => AppTextFieldValidators.validate(
              value: value,
              type: widget.inputType,
              isRequired: widget.isRequired,
              requiredText: widget.requiredText,
              minLength: widget.minLength,
              maxLength: widget.maxLength ??
                  AppTextFieldConfig.getDefaultMaxLength(widget.inputType),
              validateIfNotEmpty: widget.validateIfNotEmpty,
              customValidator: widget.validator,
            ),
            onTap: widget.onTap,
            onChanged: widget.onChanged,
            // onSubmitted: widget.onSubmitted,
            decoration: InputDecoration(
              labelText: widget.label,
              counterText: "",
              hintText: widget.hintText,
              hintStyle:
                  widget.hintStyle ?? const TextStyle(color: Colors.grey),
              isDense: widget.isDense,
              filled: widget.filled,
              fillColor: widget.fillColor,
              contentPadding: widget.contentPadding ??
                  const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: _isObscured
                  ? IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    )
                  : widget.suffixIcon,
              enabledBorder: _border(false),
              focusedBorder: _border(true),
              border: _border(false),
              errorBorder: _border(false),
              focusedErrorBorder: _border(true),
            ),
          ),
        ],
      ),
    );
  }

  InputBorder _border(bool focused) {
    final color = widget.borderColor ?? AppColors.kC6C6C6;

    if (!widget.hasBorder && !widget.hasUnderLineBorder) {
      return InputBorder.none;
    }

    if (widget.hasUnderLineBorder) {
      return UnderlineInputBorder(
        borderSide: BorderSide(
          color: focused ? AppColors.kC6C6C6 : color,
          width: focused ? 1.8 : 1.2,
        ),
      );
    }

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(
        color: focused ? AppColors.kC6C6C6 : color,
        width: focused ? 1.5 : 1.2,
      ),
    );
  }
}
