import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../theme/colors/Appcolors.dart';

/// A row of single-digit boxes for OTP entry — auto-advances focus
/// forward on input, and back on backspace from an empty box.
///
/// Fully generic and Bloc-agnostic on purpose: pass in your own
/// [controllers]/[focusNodes] (owned by whichever Bloc/Cubit/State is
/// managing the screen), and this widget only handles the box UI and
/// focus-hopping. That's what makes it reusable across every OTP screen
/// in the app (login OTP, transaction OTP, KYC OTP, ...) without pulling
/// in any screen-specific state management.
class OtpInputRow extends StatelessWidget {
  final int length;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final bool isValid;

  /// Called after every keystroke in any box, with the currently
  /// combined OTP string (may be partial).
  final ValueChanged<String>? onChanged;

  /// Called once the last box is filled, with the full OTP string.
  /// Useful for auto-submitting the moment entry is complete.
  final ValueChanged<String>? onCompleted;

  final double boxSize;
  final double spacing;
  final bool autofocus;

  const OtpInputRow({
    super.key,
    required this.length,
    required this.controllers,
    required this.focusNodes,
    this.isValid = true,
    this.onChanged,
    this.onCompleted,
    this.boxSize = 46,
    this.spacing = 10,
    this.autofocus = true,
  })  : assert(controllers.length == length,
            'controllers must have exactly `length` items'),
        assert(focusNodes.length == length,
            'focusNodes must have exactly `length` items');

  String get _currentValue => controllers.map((c) => c.text).join();

  void _handleChanged(int index, String value) {
    if (value.isNotEmpty && index < length - 1) {
      focusNodes[index + 1].requestFocus();
    }

    onChanged?.call(_currentValue);

    if (_currentValue.length == length) {
      FocusManager.instance.primaryFocus?.unfocus();
      onCompleted?.call(_currentValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        return Padding(
          padding: EdgeInsets.only(right: index == length - 1 ? 0 : spacing),
          child: _OtpBox(
            controller: controllers[index],
            focusNode: focusNodes[index],
            size: boxSize,
            isValid: isValid,
            autofocus: autofocus && index == 0,
            onChanged: (value) => _handleChanged(index, value),
            onBackspaceOnEmpty: index > 0
                ? () {
                    focusNodes[index - 1].requestFocus();
                    controllers[index - 1].clear();
                    onChanged?.call(_currentValue);
                  }
                : null,
          ),
        );
      }),
    );
  }
}

class _OtpBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final double size;
  final bool isValid;
  final bool autofocus;
  final ValueChanged<String> onChanged;
  final VoidCallback? onBackspaceOnEmpty;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.size,
    required this.isValid,
    required this.autofocus,
    required this.onChanged,
    this.onBackspaceOnEmpty,
  });

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  @override
  void initState() {
    super.initState();
    // Rebuild just this box when it gains/loses focus, so the border
    // color updates — added once here, not on every build.
    widget.focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor = !widget.isValid
        ? AppColors.appPrimaryRedColor
        : (widget.focusNode.hasFocus
            ? AppColors.primaryPurple
            : AppColors.inputBorder);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      // Focus + onKeyEvent lets us intercept Backspace on an already-
      // empty box (which never fires TextField.onChanged) without
      // stealing focus handling away from the TextField itself —
      // returning `ignored` lets the key event keep propagating normally.
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              widget.controller.text.isEmpty) {
            widget.onBackspaceOnEmpty?.call();
          }
          return KeyEventResult.ignored;
        },
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          maxLength: 1,
          onChanged: widget.onChanged,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: AppColors.cardBg,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor, width: 1.6),
            ),
          ),
        ),
      ),
    );
  }
}
