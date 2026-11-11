import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../theme/ag_text_styles.dart';
import '../../utils/ag_colors.dart';

/// ===============================
/// ENUM FOR INPUT TYPES
/// ===============================
enum AgInputType {
  text,
  stringOnly,
  numberOnly,
  decimal,
  alphaNumeric,
  email,
  phone,
}

class AgTextField extends StatefulWidget {
  final String name;

  final String? label;
  final String? title;
  final String? initialValue;
  final String? hintText;
  final String? requiredText;

  final bool obscureText;
  final bool readyOnly;
  final bool isEnabled;
  final bool isRequired;
  final bool isStar;
  final bool filled;
  final bool hasUnderLineBorder;
  final bool hasBorder;
  final bool isDense;

  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final int? errorMaxLines;
  final MaxLengthEnforcement? maxLengthEnforcement;

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

  final AgInputType inputType;

  final FloatingLabelBehavior? floatingLabelBehavior;

  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? suffix;
  final Widget? counter;

  final BoxConstraints? prefixConstraints;
  final BoxConstraints? suffixIconConstraints;

  final Function()? onTap;
  final Function()? onSubmitted;
  final Function(String?)? onChanged;

  final FormFieldValidator<String>? validator;

  final FocusNode? focusNode;
  final bool? autoFocus;
  final AutovalidateMode? autoValidateMode;

  const AgTextField({
    super.key,
    required this.name,
    this.label,
    this.hintText,
    this.requiredText,
    this.title,
    this.titlePadding,
    this.initialValue,
    this.obscureText = false,
    this.readyOnly = false,
    this.onTap,
    this.validator,
    this.controller,
    this.labelStyle,
    this.inputTextStyle,
    this.hintStyle,
    this.floatingLabelBehavior,
    this.keyboardType,
    this.inputFormatters,
    this.inputType = AgInputType.text,
    this.maxLength,
    this.borderRadius = 6,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.contentPadding,
    this.onChanged,
    this.hasUnderLineBorder = true,
    this.hasBorder = true,
    this.focusNode,
    this.onSubmitted,
    this.counter,
    this.isDense = true,
    this.filled = false,
    this.fillColor,
    this.isEnabled = true,
    this.errorMaxLines,
    this.autoValidateMode,
    this.prefixIcon,
    this.prefixConstraints,
    this.suffix,
    this.maxLines = 1,
    this.minLines = 1,
    this.borderColor,
    this.backgroundColor,
    this.isRequired = false,
    this.isStar = false,
    this.maxLengthEnforcement,
    this.autoFocus,
    this.titleStyle,
  });

  @override
  State<AgTextField> createState() => _AgTextFieldState();
}

class _AgTextFieldState extends State<AgTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  /// ===============================
  /// AUTO KEYBOARD TYPE
  /// ===============================
  TextInputType _getKeyboardType() {
    switch (widget.inputType) {
      case AgInputType.numberOnly:
      case AgInputType.decimal:
        return TextInputType.number;

      case AgInputType.email:
        return TextInputType.emailAddress;

      case AgInputType.phone:
        return TextInputType.phone;

      default:
        return TextInputType.text;
    }
  }

  /// ===============================
  /// AUTO FORMATTERS
  /// ===============================
  List<TextInputFormatter>? _getFormatters() {
    switch (widget.inputType) {
      case AgInputType.stringOnly:
        return [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s]"))];

      case AgInputType.numberOnly:
        return [FilteringTextInputFormatter.digitsOnly];

      case AgInputType.decimal:
        return [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))];

      case AgInputType.alphaNumeric:
        return [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9]"))];

      case AgInputType.phone:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ];

      case AgInputType.email:
      case AgInputType.text:
        return null;
    }
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
              padding: widget.titlePadding ?? EdgeInsets.zero,
              child: Text(
                widget.title!,
                style: widget.titleStyle ?? kw400Primary14,
              ),
            ),
          _buildFormField(),
          if (widget.isRequired)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                widget.requiredText ?? "Required",
                style: kw400Primary14,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFormField() {
    return FormBuilderTextField(
      name: widget.name,
      controller: widget.controller,
      initialValue: widget.controller == null ? widget.initialValue : null,
      readOnly: widget.readyOnly,
      enabled: widget.isEnabled,
      focusNode: widget.focusNode,
      autofocus: widget.autoFocus ?? false,
      obscureText: _isObscured,
      style: widget.inputTextStyle ?? kw400Primary14,
      keyboardType: widget.keyboardType ?? _getKeyboardType(),
      inputFormatters: widget.inputFormatters ?? _getFormatters(),
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      maxLengthEnforcement: widget.maxLengthEnforcement,
      cursorColor: AgColors.colorPrimaryDark,
      validator: (value) {
        if (widget.isRequired && (value == null || value.trim().isEmpty)) {
          return widget.requiredText ?? 'This field is required';
        }
        if (widget.validator != null) return widget.validator!(value);
        return null;
      },
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onSubmitted,
      onSubmitted: (_) => widget.onSubmitted?.call(),
      autovalidateMode:
          widget.autoValidateMode ?? AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: widget.labelStyle ?? kw400Primary14,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle ?? kw400Primary14,
        isDense: widget.isDense,
        filled: widget.filled,
        fillColor: widget.fillColor,
        contentPadding:
            widget.contentPadding ?? const EdgeInsets.symmetric(vertical: 8),
        suffixIcon:
            widget.obscureText
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
        border: _border(false),
        focusedBorder: _border(true),
        errorMaxLines: widget.errorMaxLines ?? 3,
      ),
    );
  }

  InputBorder _border(bool focused) {
    final color = widget.borderColor ?? AgColors.colorPrimaryDark;

    if (widget.hasUnderLineBorder) {
      return UnderlineInputBorder(
        borderSide: BorderSide(
          color: focused ? AgColors.colorPrimaryDark : color,
          width: focused ? 1.8 : 1.2,
        ),
      );
    }

    if (widget.hasBorder) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: BorderSide(color: color),
      );
    }

    return InputBorder.none;
  }
}
