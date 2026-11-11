import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:flutter/material.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:flutter_svg/svg.dart';

class BankingBalanceHero extends StatelessWidget {
  const BankingBalanceHero({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Container(
      padding: EdgeInsets.all(tokens.spacingXl),
      decoration: BoxDecoration(
        color: AppColors.surfaceBgPurpleTranslucent,
        borderRadius: BorderRadius.circular(tokens.radiusLg),
        boxShadow: tokens.shadowMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                context.l10n.serviceBankingBalanceLabel,
                style: AppTextStyle.titleSmall,
                color: tokens.background,
                fontWeight: FontWeight.w500,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceBgPurple.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  AppAssets.iconCurrency,
                  colorFilter: ColorFilter.mode(
                    tokens.background,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
          AppText(
            'ZK 125,000.00',
            style: AppTextStyle.metricLarge,
            color: tokens.background,
          ),
          SizedBox(height: 16),
          Divider(color: AppColors.surfaceBg.withValues(alpha: 0.5)),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                context.l10n.serviceBankingAccountSavings('4589'),
                style: AppTextStyle.bodyLarge,
                color: tokens.background,
              ),
              AppText(
                context.l10n.serviceBankingBalanceChange('+2.4%'),
                style: AppTextStyle.bodyLarge,
                fontWeight: FontWeight.w700,
                color: tokens.background,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
