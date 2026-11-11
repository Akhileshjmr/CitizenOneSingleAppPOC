import 'package:citizenone_app/core/constants/routes_constants.dart';
import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/components/shared/section_header.dart';
import 'package:citizenone_app/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/features/customer/services/presentation/widgets/banking_balance_hero.dart';
import 'package:citizenone_app/features/customer/services/presentation/widgets/banking_quick_actions.dart';
import 'package:citizenone_app/features/customer/services/presentation/widgets/banking_service_section.dart';
import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/components/shared/service_grid_row.dart';

class BankingScreen extends StatelessWidget {
  const BankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    final bankingAccountItems = [
      SvcItem(
        icon: AppAssets.iconHealthAndSafety,
        label: context.l10n.serviceBankingAccSavings,
      ),
      SvcItem(
        icon: AppAssets.iconChild,
        label: context.l10n.serviceBankingAccCurrent,
      ),
      SvcItem(
        icon: AppAssets.iconPay,
        label: context.l10n.serviceBankingAccBusiness,
      ),
      SvcItem(
        icon: AppAssets.iconExercise,
        label: context.l10n.serviceBankingAccFixed,
        iconColor: AppColors.roleFarmer,
      ),
    ];

    final bankingLoanItems = [
      SvcItem(
        icon: AppAssets.iconSchool,
        label: context.l10n.serviceBankingLoanPersonal,
      ),
      SvcItem(
        icon: AppAssets.iconMenuBook,
        label: context.l10n.serviceBankingLoanBusiness,
      ),
      SvcItem(
        icon: AppAssets.iconExercise,
        label: context.l10n.serviceBankingLoanHome,
        iconColor: AppColors.serviceTealBg,
      ),
      SvcItem(
        icon: AppAssets.iconPay,
        label: context.l10n.serviceBankingLoanVehicle,
        iconColor: AppColors.serviceBlue,
      ),
      SvcItem(
        icon: AppAssets.iconPay,
        label: context.l10n.serviceBankingLoanAgri,
        iconColor: AppColors.serviceBlue,
      ),
       SvcItem(
        icon: AppAssets.iconPay,
        label: "KYC",
        iconColor: AppColors.serviceBlue,
        onTap: () => context.push(AppRoutes.searchKycUser),
      ),
    ];

    final bankingCardItems = [
      SvcItem(
        icon: AppAssets.iconMap,
        label: context.l10n.serviceBankingCardClassic,
      ),
      SvcItem(
        icon: AppAssets.iconHome,
        label: context.l10n.serviceBankingCardCashback,
        iconColor: AppColors.warning,
      ),
      SvcItem(
        icon: AppAssets.iconTask,
        label: context.l10n.serviceBankingCardRewards,
      ),
      SvcItem(
        icon: AppAssets.iconPay,
        label: context.l10n.serviceBankingCardTravel,
        iconColor: AppColors.roleAgent,
      ),
      SvcItem(
        icon: AppAssets.iconTask,
        label: context.l10n.serviceBankingCardPremium,
      ),
      SvcItem(
        icon: AppAssets.iconPay,
        label: context.l10n.serviceBankingCardSecured,
        iconColor: AppColors.roleAgent,
      ),
      SvcItem(
        icon: AppAssets.iconHome,
        label: context.l10n.serviceBankingCardBusiness,
        iconColor: AppColors.warning,
      ),
      SvcItem(
        icon: AppAssets.iconMap,
        label: context.l10n.serviceBankingCardCobranded,
      ),
    ];

    return Scaffold(
      backgroundColor: tokens.surfaceSoft,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: tokens.textPrimary),
          onPressed: () => context.pop(), //context.go('/home'),
        ),
        title: AppText(
          context.l10n.serviceBankingTitle,
          style: AppTextStyle.headlineSmall,
        ),
        centerTitle: false,
        backgroundColor: tokens.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: tokens.outline, height: 1),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: context.adaptiveContentMaxWidth,
          ),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: context.adaptiveHorizontalPadding,
              vertical: tokens.spacingMd,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BankingBalanceHero(),
                SizedBox(height: 10),
                SectionHeader(title: context.l10n.dashboardSectionQuickActions),
                SizedBox(height: 10),
                const BankingQuickActions(),
                SizedBox(height: 10),
                BankingServiceSection(
                  title: context.l10n.serviceBankingSectionAccounts,
                  items: bankingAccountItems,
                ),
                BankingServiceSection(
                  title: context.l10n.serviceBankingSectionLoans,
                  items: bankingLoanItems,
                ),
                BankingServiceSection(
                  title: context.l10n.serviceBankingSectionCards,
                  items: bankingCardItems,
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
