import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';

enum AppButtonVariant {
  primary,
  secondary,
  outline,
  outlined,
  ghost,
  text,
  danger
}

enum AppButtonSize { sm, md, lg }

class AppButton extends StatelessWidget {
  final bool? disable;
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double? height;
  final AppTextStyle? textStyle;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final BoxBorder? border;
  final double? radius;
  final EdgeInsetsGeometry? padding;

  const AppButton({
    super.key,
    String? text,
    String? label,
    VoidCallback? onPressed,
    VoidCallback? onTap,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.isLoading = false,
    IconData? icon,
    IconData? leadingIcon,
    IconData? trailingIcon,
    double? width,
    bool isFullWidth = true,
    this.disable = false,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.textColor,
    this.borderColor,
    this.borderWidth,
    this.border,
    this.radius,
    this.textStyle,
    this.padding,
  })  : text = text ?? label ?? '',
        onPressed = onPressed ?? onTap,
        icon = icon ?? leadingIcon ?? trailingIcon,
        width = isFullWidth ? (width ?? double.infinity) : width;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    final buttonHeight = height ?? _heightFor(size);
    final radius = this.radius ?? 16;
    final fgColor = foregroundColor ?? _fgColorFor(tokens);
    final bgColor = backgroundColor ?? tokens.primary;

    return SizedBox(
      width: width,
      height: buttonHeight,
      child: disable == true
          ? IgnorePointer(
              ignoring: true,
              child: Opacity(
                opacity: 0.5,
                child: _buildButton(
                  context,
                  tokens,
                  radius,
                  fgColor,
                  bgColor,
                ),
              ))
          : _buildButton(
              context,
              tokens,
              radius,
              fgColor,
              bgColor,
            ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    AppThemeTokens tokens,
    double radius,
    Color fgColor,
    Color bgColor,
  ) {
    switch (variant) {
      case AppButtonVariant.primary:
        final resolvedBorder = border ??
            Border.all(
              color: borderColor ?? bgColor,
              width: borderWidth ?? 1.0,
            );
        return _PrimaryButton(
          text: text,
          onPressed: onPressed,
          isLoading: isLoading,
          icon: icon,
          padding: padding,
          radius: radius,
          fgColor: fgColor,
          textColor: textColor,
          bgColor: bgColor,
          border: resolvedBorder,
          tokens: tokens,
          size: size,
          textStyle: textStyle,
        );
      case AppButtonVariant.secondary:
        final resolvedBorder = border ??
            (borderColor != null
                ? Border.all(
                    color: borderColor!,
                    width: borderWidth ?? 1.0,
                  )
                : null);
        return _SecondaryButton(
          text: text,
          onPressed: onPressed,
          isLoading: isLoading,
          icon: icon,
          padding: padding,
          radius: radius,
          fgColor: fgColor,
          textColor: textColor,
          bgColor: bgColor,
          border: resolvedBorder,
          tokens: tokens,
          size: size,
          textStyle: textStyle,
        );
      case AppButtonVariant.outline:
      case AppButtonVariant.outlined:
        final resolvedBorder = border ??
            Border.all(
              color: borderColor ?? tokens.primary,
              width: borderWidth ?? 1.5,
            );
        return _OutlineButton(
          text: text,
          onPressed: onPressed,
          isLoading: isLoading,
          icon: icon,
          padding: padding,
          radius: radius,
          fgColor: fgColor,
          textColor: textColor,
          border: resolvedBorder,
          size: size,
          textStyle: textStyle,
        );
      case AppButtonVariant.ghost:
      case AppButtonVariant.text:
        final resolvedBorder = border ??
            (borderColor != null
                ? Border.all(
                    color: borderColor!,
                    width: borderWidth ?? 1.0,
                  )
                : null);
        return _GhostButton(
          text: text,
          onPressed: onPressed,
          isLoading: isLoading,
          icon: icon,
          padding: padding,
          fgColor: fgColor,
          textColor: textColor,
          border: resolvedBorder,
          size: size,
          textStyle: textStyle,
        );
      case AppButtonVariant.danger:
        final dangerBgColor = backgroundColor ?? tokens.error;
        final resolvedBorder = border ??
            Border.all(
              color: borderColor ?? dangerBgColor,
              width: borderWidth ?? 1.0,
            );
        return _PrimaryButton(
          text: text,
          onPressed: onPressed,
          isLoading: isLoading,
          icon: icon,
          padding: padding,
          radius: radius,
          fgColor: Colors.white,
          textColor: textColor,
          bgColor: dangerBgColor,
          border: resolvedBorder,
          tokens: tokens,
          size: size,
          textStyle: textStyle,
        );
    }
  }

  double _heightFor(AppButtonSize s) => switch (s) {
        AppButtonSize.sm => 40,
        AppButtonSize.md => 52,
        AppButtonSize.lg => 60,
      };

  Color _fgColorFor(AppThemeTokens tokens) => foregroundColor ?? Colors.white;
}

// ── Private variant widgets ──────────────────────────────────────────────────

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final Color fgColor;
  final Color? textColor;
  final Color bgColor;
  final BoxBorder? border;
  final AppThemeTokens tokens;
  final AppButtonSize size;
  final AppTextStyle? textStyle;

  const _PrimaryButton({
    required this.text,
    required this.onPressed,
    required this.isLoading,
    required this.icon,
    required this.padding,
    required this.radius,
    required this.fgColor,
    required this.textColor,
    required this.bgColor,
    this.border,
    required this.tokens,
    required this.size,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: border ?? Border.all(color: bgColor),
        color: bgColor,
        // boxShadow: [
        // BoxShadow(
        //   color: (bgColor).withValues(alpha: 0.28),
        //   blurRadius: 14,
        //   offset: const Offset(0, 4),
        // ),
        // ],
      ),
      child: _Ink(
        radius: radius,
        onPressed: isLoading ? null : onPressed,
        child: _Content(
          text: text,
          icon: icon,
          fgColor: fgColor,
          textColor: textColor,
          isLoading: isLoading,
          size: size,
          padding: padding,
          textStyle: textStyle,
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final Color fgColor;
  final Color? textColor;
  final Color bgColor;
  final BoxBorder? border;
  final AppThemeTokens tokens;
  final AppButtonSize size;
  final AppTextStyle? textStyle;

  const _SecondaryButton({
    required this.text,
    required this.onPressed,
    required this.isLoading,
    required this.icon,
    required this.padding,
    required this.radius,
    required this.fgColor,
    required this.textColor,
    required this.bgColor,
    this.border,
    required this.tokens,
    required this.size,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: border,
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: bgColor.withValues(alpha: 0.22),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: _Ink(
        radius: radius,
        onPressed: isLoading ? null : onPressed,
        child: _Content(
          text: text,
          icon: icon,
          fgColor: fgColor,
          textColor: textColor,
          isLoading: isLoading,
          size: size,
          padding: padding,
          textStyle: textStyle,
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final Color fgColor;
  final Color? textColor;
  final BoxBorder border;
  final AppButtonSize size;
  final AppTextStyle? textStyle;

  const _OutlineButton({
    required this.text,
    required this.onPressed,
    required this.isLoading,
    required this.icon,
    required this.padding,
    required this.radius,
    required this.fgColor,
    this.textColor,
    required this.border,
    required this.size,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Colors.transparent,
        border: border,
      ),
      child: _Ink(
        radius: radius,
        onPressed: isLoading ? null : onPressed,
        child: _Content(
          text: text,
          icon: icon,
          fgColor: fgColor,
          textColor: textColor,
          isLoading: isLoading,
          size: size,
          padding: padding,
          textStyle: textStyle,
        ),
      ),
    );
  }
}

class _GhostButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;
  final Color fgColor;
  final Color? textColor;
  final BoxBorder? border;
  final AppButtonSize size;
  final AppTextStyle? textStyle;

  const _GhostButton({
    required this.text,
    required this.onPressed,
    required this.isLoading,
    required this.icon,
    required this.padding,
    required this.fgColor,
    this.textColor,
    this.border,
    required this.size,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final content = _Ink(
      radius: 8,
      onPressed: isLoading ? null : onPressed,
      child: _Content(
        text: text,
        icon: icon,
        fgColor: fgColor,
        textColor: textColor,
        isLoading: isLoading,
        size: size,
        padding: padding,
        textStyle: textStyle,
      ),
    );

    if (border != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: border,
        ),
        child: content,
      );
    }
    return content;
  }
}

class _Ink extends StatelessWidget {
  final Widget child;
  final double radius;
  final VoidCallback? onPressed;

  const _Ink({required this.child, required this.radius, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(radius),
        child: child,
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final String text;
  final IconData? icon;
  final AppTextStyle? textStyle;
  final Color fgColor;
  final Color? textColor;
  final bool isLoading;
  final AppButtonSize size;
  final EdgeInsetsGeometry? padding;

  const _Content({
    required this.text,
    required this.icon,
    required this.fgColor,
    this.textColor,
    required this.isLoading,
    required this.size,
    required this.padding,
    this.textStyle,
  });

  bool get isLeftIcon => icon == LucideIcons.log_out || icon == LucideIcons.x;

  double get _fontSize => switch (size) {
        AppButtonSize.sm => 13,
        AppButtonSize.md => 15,
        AppButtonSize.lg => 17,
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Center(
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: fgColor,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon on Left
                  if (icon != null && isLeftIcon) ...[
                    Icon(icon, color: fgColor, size: _fontSize + 4),
                    const SizedBox(width: 5),
                  ],

                  AppText(
                    text,
                    style: textStyle ?? AppTextStyle.bodySmall,
                    color: textColor ?? fgColor,
                  ),

                  // Icon on Right
                  if (icon != null && !isLeftIcon) ...[
                    const SizedBox(width: 5),
                    Icon(icon, color: fgColor, size: _fontSize + 2),
                  ],
                ],
              ),
      ),
    );
  }
}
