
import 'package:citizenone_app/modules/agency_banking/core/widgets/form/app_button.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/form/app_text.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/responsive/breakpoints.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';

/// Shows the reusable Sign Out confirmation popup and resolves to the user's
/// choice — `true` for "Yes", `false`/`null` for "No" or dismissal.
///
/// This only returns the selection; it never performs the logout itself.
/// Callers own the actual sign-out logic, e.g.:
/// ```dart
/// final result = await showSignOutDialog(context);
/// if (result == true) {
///   // existing logout logic
/// }
/// ```
Future<bool?> showSignOutDialog(
  BuildContext context, {
  String title = "Are you Sure?",
  String subtitle = "Signing Out.....",
}) {
  return showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: title,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, animation, secondaryAnimation) {
      return SignOutDialog(title: title, subtitle: subtitle);
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// Reusable "Sign Out" confirmation card — light-yellow logout icon, bold
/// title, grey subtitle and rectangle-shaped No/Yes buttons. Used throughout the
/// app via [showSignOutDialog]; the widget itself stays presentation-only
/// (defaults to popping `false`/`true`) so the caller keeps owning whatever
/// happens after "Yes" is tapped.
class SignOutDialog extends StatelessWidget {
  const SignOutDialog({
    super.key,
    this.title = "Are you Sure?",
    this.subtitle = "Signing Out.....",
    this.onConfirm,
    this.onCancel,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = Breakpoints.isMobile(width);

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isMobile ? 360 : 420),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: AppColors.kFFF8E1,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout,
                  size: 36,
                  color: AppColors.kF59E0B,
                ),
              ),
              const SizedBox(height: 24),
              AppText(
                title,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
                color: AppColors.k0D1F4D,
              ),
              const SizedBox(height: 4),
              AppText(
                subtitle,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
                color: AppColors.k868686,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      title: "No",
                      shape: AppButtonShape.rectangle,
                      fullWidth: true,
                      height: 52,
                      enabledColor: Colors.white,
                      textColor: AppColors.k0D1F4D,
                      borderColor: AppColors.k0D1F4D,
                      borderWidth: 1.4,
                      onPressed:
                          onCancel ?? () => Navigator.of(context).pop(false),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(52),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.k613AF5.withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: AppButton(
                        title: "Yes",
                        shape: AppButtonShape.rectangle,
                        fullWidth: true,
                        height: 52,
                        enabledColor: AppColors.k613AF5,
                        textColor: Colors.white,
                        onPressed:
                            onConfirm ?? () => Navigator.of(context).pop(true),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
