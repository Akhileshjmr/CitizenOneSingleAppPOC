import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/loader/app_loader.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ButtonType { outlined, filled, loading }

class KycCustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final Size? size;

  const KycCustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.filled,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final isOutlined = type == ButtonType.outlined;
    final isLoading = type == ButtonType.loading;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isOutlined ? AppColors.white : AppColors.teal1,
        foregroundColor: isOutlined ? AppColors.teal1 : AppColors.white,
        fixedSize: size,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.r),
          side: isOutlined
              ? const BorderSide(color: AppColors.teal1)
              : BorderSide.none,
        ),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: isLoading
          ? SizedBox(
              height: 16.sp,
              width: 16.sp,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isOutlined ? AppColors.teal1 : AppColors.white,
                ),
              ),
            )
          : Text(
              text,
              style: TextStyle(
                color: isOutlined ? AppColors.teal1 : AppColors.white,
                fontSize: 13.sp,
              ),
            ),
    );
  }
}

class AppButton extends StatelessWidget {
  const AppButton({
    required this.title,
    required this.onTap,
    super.key,
    this.width,
    this.height = 40,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.borderRadius = 8,
    this.backgroundColor,
    this.textStyle = const TextStyle(color: Colors.white, fontSize: 16),
    this.icon,
    this.iconSpacing = 8,
    this.gradient,
    this.isOutlined = false,
    this.outlineColor,
    this.isTextButton = false,
    this.isLoading = false,
  });

  final String title;
  final VoidCallback? onTap;

  final double? width;
  final double height;

  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  final IconData? icon;
  final double iconSpacing;
  final Gradient? gradient;

  final bool isOutlined;
  final Color? outlineColor;
  final bool isTextButton;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    if (isTextButton) return _buildTextButton();
    if (isOutlined) return _buildOutlinedButton();
    return _buildGradientButton();
  }

  Widget _buildGradientButton() {
    final bool isEnabled = onTap != null;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Ink(
          decoration: BoxDecoration(
            color: !isEnabled ? Colors.grey.shade300 : null,
            gradient: isEnabled
                ? (gradient ??
                    LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        backgroundColor!,
                        backgroundColor!,
                      ],
                    ))
                : null,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Container(
            height: height,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: isLoading
                ? const AppLoader(color: AppColors.white)
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          size: 18,
                          color: isEnabled
                              ? Colors.white
                              : Colors.grey.shade600,
                        ),
                        SizedBox(width: iconSpacing),
                      ],
                      Text(
                        title,
                        style: textStyle?.copyWith(
                              color: isEnabled
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ) ??
                            TextStyle(
                              color: isEnabled
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextButton() {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: padding,
        foregroundColor: AppColors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        title,
        style: textStyle ??
            TextStyle(fontWeight: FontWeight.bold, color: AppColors.black),
      ),
    );
  }

  Widget _buildOutlinedButton() {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: outlineColor ?? AppColors.black, width: 1.4),
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            const SizedBox(width: 10),
            Icon(icon, size: 16, color: outlineColor ?? AppColors.black),
          ],
          3.horizontalSpace,
          Text(
            title,
            style:
                textStyle?.copyWith(color: outlineColor ?? AppColors.black) ??
                    TextStyle(color: outlineColor ?? AppColors.black),
          ),
        ],
      ),
    );
  }
}
