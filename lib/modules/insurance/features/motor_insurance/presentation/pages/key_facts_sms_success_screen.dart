import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/core/theme/tokens/assets.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_button.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';

class KeyFactsSmsSuccessScreen extends StatelessWidget {
  final String phoneNumber;

  const KeyFactsSmsSuccessScreen({
    super.key,
    this.phoneNumber = '+260 923453453',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: const BoxDecoration(
                      color: AppColors.glassWhite, shape: BoxShape.circle),
                  child: SvgPicture.asset(AppAssets.iconVector,
                      width: 36, height: 36, fit: BoxFit.scaleDown),
                ),
                const SizedBox(height: 28),
                const AppText(
                  'SMS Sent Successfully!',
                  style: AppTextStyle.displaySmall,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const AppText(
                  'The Policy Key Facts Statement link has been sent to your registered mobile number.',
                  style: AppTextStyle.bodySmall,
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.mobile_friendly_rounded,
                        color: Color(0xFF16A34A),
                        size: 22,
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppText(
                            'Sent to',
                            style: AppTextStyle.bodySmall,
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(height: 2),
                          AppText(
                            '+260 $phoneNumber',
                            style: AppTextStyle.bodyLarge,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 44),
                AppButton(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 52,
                  label: 'Done',
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      context.pop();
                    }
                  },
                  backgroundColor: AppColors.primary,
                  radius: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
