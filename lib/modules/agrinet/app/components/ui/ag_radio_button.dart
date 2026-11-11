import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/ag_colors.dart';

class AppRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;

  final MouseCursor? mouseCursor;
  final bool toggleable;
  final Color? activeColor;
  final WidgetStateProperty<Color?>? fillColor;
  final Color? focusColor;
  final Color? hoverColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool adaptive;
  final bool useCupertinoCheckmarkStyle;

  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.mouseCursor,
    this.toggleable = false,
    this.activeColor,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.adaptive = false,
    this.useCupertinoCheckmarkStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color primary = AgColors.colorPrimary;

    // final resolvedFillColor = fillColor ?? MaterialStateProperty.all(primary);

    final resolvedFillColor =
        fillColor ??
        MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.disabled)) {
            return primary.withOpacity(.4);
          }
          if (states.contains(MaterialState.selected)) {
            return primary;
          }
          return primary; // unselected border color
        });

    if (adaptive) {
      final platform = Theme.of(context).platform;
      if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
        return CupertinoRadio<T>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: primary,
          mouseCursor: mouseCursor,
          toggleable: toggleable,
          focusNode: focusNode,
          autofocus: autofocus,
          focusColor: focusColor,
          useCheckmarkStyle: useCupertinoCheckmarkStyle,
        );
      }
    }

    return Radio<T>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: primary, // ✔ selected color
      fillColor: resolvedFillColor, // ✔ selected + unselected + disabled color
      mouseCursor: mouseCursor,
      toggleable: toggleable,
      focusColor: focusColor ?? primary.withOpacity(.3),
      hoverColor: hoverColor ?? primary.withOpacity(.2),
      overlayColor: overlayColor,
      splashRadius: splashRadius,
      materialTapTargetSize: materialTapTargetSize,
      visualDensity: visualDensity,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }
}
