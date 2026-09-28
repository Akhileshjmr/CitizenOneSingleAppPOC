import 'package:flutter/material.dart';
import '../spacing/app_spacing.dart';
import '../tokens/theme_context_extension.dart';

/// Supported visual variants matching CitizenOne Design Tokens & Figma specs.
enum AppButtonVariant {
  filled,
  outlined,
  tonal,
  text,
}

/// Supported button intents (Primary Brand vs Success Action).
enum AppButtonIntent {
  primary,
  success,
}

/// Supported button sizes matching design specifications.
enum AppButtonSize {
  small,
  defaultSize,
  large,
}

/// Unified Atom Button Component for CitizenOne Application.
///
/// Supports:
/// - Sub-types: Primary (Filled, Outlined, Tonal, Text) & Success (Filled, Outlined, Tonal, Text)
/// - Icon Positions: Left (leadingIcon), Right (trailingIcon), or None
/// - States: Default, Disabled (isDisabled == true || onPressed == null with 50% opacity), Loading (isLoading == true)
/// - Theme Tokens: Context-aware resolution via context.tokens & context.colors
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final AppButtonVariant variant;
  final AppButtonIntent intent;
  final AppButtonSize size;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final IconData? icon; // Backward compatibility for left icon
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    bool isOutlined = false,
    AppButtonVariant? variant,
    this.intent = AppButtonIntent.primary,
    this.size = AppButtonSize.defaultSize,
    this.leadingIcon,
    this.trailingIcon,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  }) : variant = isOutlined
            ? AppButtonVariant.outlined
            : (variant ?? AppButtonVariant.filled);

  /// Primary Filled Button
  const factory AppButton.filled({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading,
    bool isDisabled,
    AppButtonSize size,
    IconData? leadingIcon,
    IconData? trailingIcon,
    Color? backgroundColor,
    Color? foregroundColor,
  }) = _AppFilledButton;

  /// Primary Outlined Button
  const factory AppButton.outlined({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading,
    bool isDisabled,
    AppButtonSize size,
    IconData? leadingIcon,
    IconData? trailingIcon,
    Color? backgroundColor,
    Color? foregroundColor,
  }) = _AppOutlinedButton;

  /// Primary Tonal Button
  const factory AppButton.tonal({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading,
    bool isDisabled,
    AppButtonSize size,
    IconData? leadingIcon,
    IconData? trailingIcon,
    Color? backgroundColor,
    Color? foregroundColor,
  }) = _AppTonalButton;

  /// Primary Text Button
  const factory AppButton.text({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading,
    bool isDisabled,
    AppButtonSize size,
    IconData? leadingIcon,
    IconData? trailingIcon,
    Color? foregroundColor,
  }) = _AppTextButton;

  /// Success Filled Button (SuccessPrimary)
  const factory AppButton.successFilled({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading,
    bool isDisabled,
    AppButtonSize size,
    IconData? leadingIcon,
    IconData? trailingIcon,
    Color? backgroundColor,
    Color? foregroundColor,
  }) = _AppSuccessFilledButton;

  /// Success Outlined Button (SuccessOutlined)
  const factory AppButton.successOutlined({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading,
    bool isDisabled,
    AppButtonSize size,
    IconData? leadingIcon,
    IconData? trailingIcon,
    Color? backgroundColor,
    Color? foregroundColor,
  }) = _AppSuccessOutlinedButton;

  /// Success Tonal Button (SuccessTonal)
  const factory AppButton.successTonal({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading,
    bool isDisabled,
    AppButtonSize size,
    IconData? leadingIcon,
    IconData? trailingIcon,
    Color? backgroundColor,
    Color? foregroundColor,
  }) = _AppSuccessTonalButton;

  /// Success Text Button (SuccessText)
  const factory AppButton.successText({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading,
    bool isDisabled,
    AppButtonSize size,
    IconData? leadingIcon,
    IconData? trailingIcon,
    Color? foregroundColor,
  }) = _AppSuccessTextButton;

  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        );
      case AppButtonSize.defaultSize:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        );
    }
  }

  double _getFontSize() {
    switch (size) {
      case AppButtonSize.small:
        return 13.0;
      case AppButtonSize.large:
        return 17.0;
      case AppButtonSize.defaultSize:
        return 15.0;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16.0;
      case AppButtonSize.large:
        return 22.0;
      case AppButtonSize.defaultSize:
        return 18.0;
    }
  }

  Color _getIntentBaseColor(BuildContext context) {
    if (backgroundColor != null) return backgroundColor!;
    switch (intent) {
      case AppButtonIntent.success:
        return context.tokens.statusSuccess;
      case AppButtonIntent.primary:
        return context.tokens.brandPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveLeadingIcon = leadingIcon ?? icon;
    final baseColor = _getIntentBaseColor(context);
    final effectiveDisabled = isDisabled || onPressed == null;
    final effectiveOnPressed = (isLoading || effectiveDisabled) ? null : onPressed;

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
    );

    switch (variant) {
      case AppButtonVariant.outlined:
        final strokeColor = foregroundColor ?? baseColor;
        final strokeColor50 = strokeColor.withValues(alpha: 0.5);

        return OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: strokeColor,
            disabledForegroundColor: strokeColor50,
            side: BorderSide(
              color: effectiveDisabled ? strokeColor50 : strokeColor,
              width: 2,
            ),
            padding: _getPadding(),
            shape: shape,
            textStyle: TextStyle(
              fontSize: _getFontSize(),
              fontWeight: FontWeight.w600,
            ),
          ),
          child: _buildContent(
            context,
            effectiveDisabled ? strokeColor50 : strokeColor,
            effectiveLeadingIcon,
          ),
        );

      case AppButtonVariant.tonal:
        final tonalBg = backgroundColor ?? baseColor.withValues(alpha: 0.15);
        final tonalFg = foregroundColor ?? baseColor;
        final tonalBg50 = tonalBg.withValues(alpha: 0.5);
        final tonalFg50 = tonalFg.withValues(alpha: 0.5);

        return FilledButton.tonal(
          onPressed: effectiveOnPressed,
          style: FilledButton.styleFrom(
            backgroundColor: tonalBg,
            foregroundColor: tonalFg,
            disabledBackgroundColor: tonalBg50,
            disabledForegroundColor: tonalFg50,
            padding: _getPadding(),
            shape: shape,
            textStyle: TextStyle(
              fontSize: _getFontSize(),
              fontWeight: FontWeight.w600,
            ),
          ),
          child: _buildContent(
            context,
            effectiveDisabled ? tonalFg50 : tonalFg,
            effectiveLeadingIcon,
          ),
        );

      case AppButtonVariant.text:
        final textFg = foregroundColor ?? baseColor;
        final textFg50 = textFg.withValues(alpha: 0.5);

        return TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(
            foregroundColor: textFg,
            disabledForegroundColor: textFg50,
            padding: _getPadding(),
            shape: shape,
            textStyle: TextStyle(
              fontSize: _getFontSize(),
              fontWeight: FontWeight.w600,
            ),
          ),
          child: _buildContent(
            context,
            effectiveDisabled ? textFg50 : textFg,
            effectiveLeadingIcon,
          ),
        );

      case AppButtonVariant.filled:
        final filledFg = foregroundColor ?? Colors.white;
        final baseColor50 = baseColor.withValues(alpha: 0.5);
        final filledFg50 = filledFg.withValues(alpha: 0.5);

        return ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: baseColor,
            foregroundColor: filledFg,
            disabledBackgroundColor: baseColor50,
            disabledForegroundColor: filledFg50,
            elevation: 0,
            padding: _getPadding(),
            shape: shape,
            textStyle: TextStyle(
              fontSize: _getFontSize(),
              fontWeight: FontWeight.w600,
            ),
          ),
          child: _buildContent(
            context,
            effectiveDisabled ? filledFg50 : filledFg,
            effectiveLeadingIcon,
          ),
        );
    }
  }

  Widget _buildContent(
    BuildContext context,
    Color contentColor,
    IconData? leftIcon,
  ) {
    if (isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(contentColor),
        ),
      );
    }

    final children = <Widget>[];

    if (leftIcon != null) {
      children.add(Icon(leftIcon, size: _getIconSize(), color: contentColor));
      children.add(const SizedBox(width: AppSpacing.sm));
    }

    children.add(
      Text(
        label,
        style: TextStyle(
          fontSize: _getFontSize(),
          fontWeight: FontWeight.w600,
          color: contentColor,
        ),
      ),
    );

    if (trailingIcon != null) {
      children.add(const SizedBox(width: AppSpacing.sm));
      children.add(Icon(trailingIcon, size: _getIconSize(), color: contentColor));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}

class _AppFilledButton extends AppButton {
  const _AppFilledButton({
    super.key,
    required super.label,
    super.onPressed,
    super.isLoading,
    super.isDisabled,
    super.size,
    super.leadingIcon,
    super.trailingIcon,
    super.backgroundColor,
    super.foregroundColor,
  }) : super(variant: AppButtonVariant.filled, intent: AppButtonIntent.primary);
}

class _AppOutlinedButton extends AppButton {
  const _AppOutlinedButton({
    super.key,
    required super.label,
    super.onPressed,
    super.isLoading,
    super.isDisabled,
    super.size,
    super.leadingIcon,
    super.trailingIcon,
    super.backgroundColor,
    super.foregroundColor,
  }) : super(variant: AppButtonVariant.outlined, intent: AppButtonIntent.primary);
}

class _AppTonalButton extends AppButton {
  const _AppTonalButton({
    super.key,
    required super.label,
    super.onPressed,
    super.isLoading,
    super.isDisabled,
    super.size,
    super.leadingIcon,
    super.trailingIcon,
    super.backgroundColor,
    super.foregroundColor,
  }) : super(variant: AppButtonVariant.tonal, intent: AppButtonIntent.primary);
}

class _AppTextButton extends AppButton {
  const _AppTextButton({
    super.key,
    required super.label,
    super.onPressed,
    super.isLoading,
    super.isDisabled,
    super.size,
    super.leadingIcon,
    super.trailingIcon,
    super.foregroundColor,
  }) : super(variant: AppButtonVariant.text, intent: AppButtonIntent.primary);
}

class _AppSuccessFilledButton extends AppButton {
  const _AppSuccessFilledButton({
    super.key,
    required super.label,
    super.onPressed,
    super.isLoading,
    super.isDisabled,
    super.size,
    super.leadingIcon,
    super.trailingIcon,
    super.backgroundColor,
    super.foregroundColor,
  }) : super(variant: AppButtonVariant.filled, intent: AppButtonIntent.success);
}

class _AppSuccessOutlinedButton extends AppButton {
  const _AppSuccessOutlinedButton({
    super.key,
    required super.label,
    super.onPressed,
    super.isLoading,
    super.isDisabled,
    super.size,
    super.leadingIcon,
    super.trailingIcon,
    super.backgroundColor,
    super.foregroundColor,
  }) : super(variant: AppButtonVariant.outlined, intent: AppButtonIntent.success);
}

class _AppSuccessTonalButton extends AppButton {
  const _AppSuccessTonalButton({
    super.key,
    required super.label,
    super.onPressed,
    super.isLoading,
    super.isDisabled,
    super.size,
    super.leadingIcon,
    super.trailingIcon,
    super.backgroundColor,
    super.foregroundColor,
  }) : super(variant: AppButtonVariant.tonal, intent: AppButtonIntent.success);
}

class _AppSuccessTextButton extends AppButton {
  const _AppSuccessTextButton({
    super.key,
    required super.label,
    super.onPressed,
    super.isLoading,
    super.isDisabled,
    super.size,
    super.leadingIcon,
    super.trailingIcon,
    super.foregroundColor,
  }) : super(variant: AppButtonVariant.text, intent: AppButtonIntent.success);
}
