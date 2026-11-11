import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/features/common/loans/presentation/state/loan_cubit.dart';
import 'package:citizenone_app/features/common/loans/presentation/widgets/loans_dashboard_widgets.dart';
import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';

class LoansDashboardScreen extends StatelessWidget {
  const LoansDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final applications = context.watch<LoanCubit>().state.applications;
    final tokens = context.appTokens;
    final categories = [
      LoanCategorySpec(
        title: context.l10n.loanCategoryPersonal,
        icon: LucideIcons.briefcase,
        color: const Color(0xFFDBEAFE),
        iconColor: const Color(0xFF2563EB),
        onTap: () => context.push('/loans/personal'),
      ),
      LoanCategorySpec(
        title: context.l10n.loanCategoryHome,
        icon: LucideIcons.house,
        color: const Color(0xFFDCFCE7),
        iconColor: const Color(0xFF16A34A),
        onTap: () {},
      ),
      LoanCategorySpec(
        title: context.l10n.loanCategoryVehicle,
        icon: LucideIcons.car,
        color: const Color(0xFFFFEDD5),
        iconColor: const Color(0xFFF97316),
        onTap: () {},
      ),
      LoanCategorySpec(
        title: context.l10n.loanCategoryAgri,
        icon: LucideIcons.sprout,
        color: const Color(0xFFD1FAE5),
        iconColor: const Color(0xFF10B981),
        onTap: () {},
      ),
      LoanCategorySpec(
        title: context.l10n.loanCategoryEducation,
        icon: LucideIcons.graduation_cap,
        color: const Color(0xFFF3E8FF),
        iconColor: const Color(0xFF9333EA),
        onTap: () {},
      ),
      LoanCategorySpec(
        title: context.l10n.loanCategoryMsme,
        icon: LucideIcons.building,
        color: const Color(0xFFDDD6FE),
        iconColor: const Color(0xFF7C3AED),
        onTap: () {},
      ),
      LoanCategorySpec(
        title: context.l10n.loanCategoryConstruction,
        icon: LucideIcons.hammer,
        color: const Color(0xFFFEF3C7),
        iconColor: const Color(0xFFEAB308),
        onTap: () {},
      ),
      LoanCategorySpec(
        title: context.l10n.loanCategoryAsset,
        icon: LucideIcons.landmark,
        color: const Color(0xFFFEE2E2),
        iconColor: const Color(0xFFEF4444),
        onTap: () {},
      ),
    ];

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: tokens.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            LucideIcons.arrow_left,
            color: AppColors.textPrimary,
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              context.l10n.loansDashboardTitle,
              style: AppTextStyle.bodyLarge,
              fontWeight: FontWeight.bold,
              color: tokens.textPrimary,
            ),
            AppText(
              context.l10n.loansDashboardSubtitle,
              style: AppTextStyle.labelSmall,
              color: tokens.textSecondary,
              fontWeight: FontWeight.normal,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(
                LucideIcons.search,
                color: AppColors.textPrimary,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: context.adaptiveContentMaxWidth,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: context.adaptiveHorizontalPadding,
              vertical: tokens.spacingLg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LoansPromoBanner(),
                SizedBox(height: tokens.spacing2xl),
                LoanCategoriesSection(categories: categories),
                SizedBox(height: tokens.spacing2xl),
                const LoansUtilityCards(),
                SizedBox(height: tokens.spacing2xl),
                LoanApplicationsSection(applications: applications),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
