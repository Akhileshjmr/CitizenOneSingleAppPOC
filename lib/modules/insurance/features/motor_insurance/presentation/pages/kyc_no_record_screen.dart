import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/modules/insurance/core/assets/app_assets.dart';
import 'package:citizenone_app/modules/insurance/core/constants/routes_constants.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_bar.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_button.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';

class NoRecordScreen extends StatelessWidget {
  const NoRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final maxWidth = AdaptiveLayout.contentMaxWidth(context);
    final isMobile = context.isMobile;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: !isMobile
          ? null
          : const AppStatusBar(
              title: 'Insurance Details',
              showBack: true,
              centerTitle: false,
              textIconColor: AppColors.black,
            ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(15),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.outline),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadowColor,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SvgPicture.asset(AppAssets.iconNoRecordFound),
                      const SizedBox(height: 28),
                      const AppText(
                        'No Records Found',
                        style: AppTextStyle.displaySmall,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const AppText(
                        'No customer information was found for the provided Mobile Number or National ID.',
                        style: AppTextStyle.bodyLarge,
                        color: AppColors.textSecondary,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 26),
                      Container(height: 1, color: AppColors.outline),
                      const SizedBox(height: 26),
                      AppButton(
                        text: 'Update Manually',
                        icon: Icons.person_add_alt_1,
                        onPressed: () {
                          context.push(AppRoutes.userDetailScreen);
                        },
                        backgroundColor: AppColors.primary,
                        radius: 12,
                        height: 40,
                        textStyle: AppTextStyle.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      AppButton(
                        text: 'Search again',
                        icon: Icons.arrow_back,
                        onPressed: () => context.pop(),
                        backgroundColor: AppColors.surface,
                        foregroundColor: AppColors.primary,
                        textColor: AppColors.primary,
                        borderColor: AppColors.primary,
                        variant: AppButtonVariant.outline,
                        radius: 12,
                        height: 40,
                        textStyle: AppTextStyle.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
