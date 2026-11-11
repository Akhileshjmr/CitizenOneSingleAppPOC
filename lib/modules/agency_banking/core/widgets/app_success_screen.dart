import 'package:citizenone_app/modules/agency_banking/core/widgets/BackgroundComponent.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';

import 'form/app_button.dart';

/// Reusable full-screen success state — icon in a soft card, title, message,
/// and a primary pill action button. Used to confirm completion of a flow
/// (password reset, registration, etc.) before routing the user onward.
class AppSuccessScreen extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final String iconAsset;

  /// When true, constrains the card to a fixed max width like the other
  /// web views in this flow (Desktop card layout), instead of the
  /// shrink-wrapped mobile layout. Defaults to false so existing callers
  /// (mobile screens, [SecuritySuccessScreen], etc.) are unaffected.
  final bool useWebLayout;

  const AppSuccessScreen({
    super.key,
    this.title = "Success",
    required this.message,
    required this.buttonText,
    required this.onButtonPressed,
    this.iconAsset = "assets/images/success.png",
    this.useWebLayout = false,
  });

  @override
  Widget build(BuildContext context) {
    final Widget card = Backgroundcomponent(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(iconAsset),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 30),
          AppButton(
            title: buttonText,
            height: 50,
            isEnabled: true,
            fullWidth: true,
            shape: AppButtonShape.pill,
            enabledColor: AppColors.k613AF5,
            textColor: Colors.white,
            onPressed: onButtonPressed,
          ),
        ],
      ).paddingSymmetric(horizontal: 16, vertical: 24),
    );

    return Scaffold(
      backgroundColor: AppMobileColors.background, //Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              useWebLayout
                  ? ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: card,
                    )
                  : card,
            ],
          ),
        ),
      ),
    );
  }
}
