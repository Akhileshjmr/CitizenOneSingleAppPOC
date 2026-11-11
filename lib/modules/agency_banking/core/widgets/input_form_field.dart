import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum FieldType {
  text,
  name,
  email,
  phone,
  number,
  decimal,
  alphanumeric,
  password,
}

class InputTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final FieldType fieldType;
  final bool autoCorrect;
  final String? hint;
  final String? labelText;
  final EdgeInsets? contentPadding;
  final String? Function(String?)? validation;
  final String? validationMessage;
  final double hintTextSize;
  final Icon? prefixIcon;
  final bool enable;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final int? minLength;
  final int? maxLength;
  final bool isRequired;
  final Widget? suffixIcon;
  final bool validateIfNotEmpty;

  const InputTextFormField({
    super.key,
    required this.controller,
    this.fieldType = FieldType.text,
    this.autoCorrect = false,
    this.enable = true,
    this.hint,
    this.validation,
    this.validationMessage = "This field",
    this.labelText,
    this.contentPadding,
    this.textInputAction,
    this.hintTextSize = 14,
    this.onFieldSubmitted,
    this.onChanged,
    this.prefixIcon,
    this.minLength,
    this.suffixIcon,
    this.maxLength,
    this.isRequired = true,
    this.validateIfNotEmpty = true,
  });

  @override
  State<InputTextFormField> createState() => _InputTextFormFieldState();
}

class _InputTextFormFieldState extends State<InputTextFormField> {
  bool _passwordVisible = false;

  TextInputType _getKeyboardType() {
    switch (widget.fieldType) {
      case FieldType.email:
        return TextInputType.emailAddress;
      case FieldType.phone:
        return TextInputType.phone;
      case FieldType.number:
        return TextInputType.number;
      case FieldType.decimal:
        return const TextInputType.numberWithOptions(decimal: true);
      default:
        return TextInputType.text;
    }
  }

  int? _getMaxLength() {
    if (widget.maxLength != null) return widget.maxLength;

    switch (widget.fieldType) {
      case FieldType.phone:
        return 9;
      case FieldType.password:
        return 20;
      case FieldType.name:
        return 50;
      default:
        return null;
    }
  }

  int? _getMinLength() {
    if (widget.minLength != null) return widget.minLength;

    switch (widget.fieldType) {
      case FieldType.phone:
        return 9;
      case FieldType.password:
        return 6;
      default:
        return null;
    }
  }

  List<TextInputFormatter>? _getInputFormatters() {
    final maxLength = _getMaxLength();
    List<TextInputFormatter> formatters = [];

    switch (widget.fieldType) {
      case FieldType.name:
        formatters.add(
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
        );
        break;

      case FieldType.email:
        formatters.add(
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9._%+\-@]')),
        );
        break;

      case FieldType.phone:
      case FieldType.number:
        formatters.add(FilteringTextInputFormatter.digitsOnly);
        break;

      case FieldType.alphanumeric:
        formatters.add(
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
        );
        break;

      case FieldType.text:
        formatters.add(
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 /]')),
        );
        break;

      case FieldType.decimal:
        formatters.add(
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        );
        break;

      default:
        break;
    }

    if (maxLength != null) {
      formatters.add(LengthLimitingTextInputFormatter(maxLength));
    }

    return formatters;
  }

  bool _isPassword() => widget.fieldType == FieldType.password;

  String? _defaultValidator(String? value) {
    final minLength = _getMinLength();
    final maxLength = _getMaxLength();

    if (widget.isRequired && (value == null || value.isEmpty)) {
      return '${widget.validationMessage} is required';
    }

    if (!widget.isRequired && (value == null || value.isEmpty)) {
      return null;
    }

    if (!widget.isRequired && !widget.validateIfNotEmpty) {
      return null;
    }

    if (minLength != null && value!.length < minLength) {
      return 'Minimum $minLength characters required';
    }

    if (maxLength != null && value!.length > maxLength) {
      return 'Maximum $maxLength characters allowed';
    }

    switch (widget.fieldType) {
      case FieldType.email:
        final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
        if (!emailRegex.hasMatch(value!)) {
          return 'Please enter valid email';
        }
        break;

      case FieldType.phone:
        if (value!.length != 9) {
          return 'Please enter a valid 9 digits Phone Number';
        }
        break;

      case FieldType.password:
        if (value!.length < 6) {
          return 'Password must be at least 6 characters';
        }
        break;

      default:
        break;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isPassword() && !_passwordVisible,
      enableSuggestions: !_isPassword(),
      autocorrect: widget.autoCorrect,
      validator: widget.validation ?? _defaultValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: widget.enable,
      textInputAction: widget.textInputAction,
      keyboardType: _getKeyboardType(),
      inputFormatters: _getInputFormatters(),
      onFieldSubmitted: widget.onFieldSubmitted,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: widget.hint,
        labelText: widget.labelText,
        labelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        hintStyle: TextStyle(
          color: AppColors.textHint,
          fontSize: widget.hintTextSize,
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: _isPassword()
            ? IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black87,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              )
            : widget.suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: widget.contentPadding ??
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.blue.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.primaryBlue,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class SlashFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly = newValue.text.replaceAll('/', '');

    String formatted = '';

    for (int i = 0; i < digitsOnly.length; i++) {
      formatted += digitsOnly[i];

      // Add '/' after 6th and 8th digit
      if (i == 5 || i == 7) {
        if (i != digitsOnly.length - 1) {
          formatted += '/';
        }
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
