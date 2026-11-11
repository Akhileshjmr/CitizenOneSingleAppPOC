import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:flutter_svg/svg.dart';

class ProfileStatChip {
  final String icon;
  final String? value;
  final String? subTitle;
  final String label;
  final Color color;

  const ProfileStatChip({
    required this.icon,
    this.value,
    this.subTitle,
    required this.label,
    required this.color,
  });
}

class ProfileSmartCard extends StatelessWidget {
  final dynamic avatarIcon; // IconData or String
  final List<Color> avatarGradient;
  final String name;
  final String role;
  final String badgeText;
  final Color badgeColor;
  final String benefitHint;
  final String? accountId;
  final String? lastLogin;
  final String? partner;
  final dynamic partnerIcon; // IconData or String
  final List<ProfileStatChip> stats;

  const ProfileSmartCard({
    super.key,
    required this.avatarIcon,
    required this.avatarGradient,
    required this.name,
    required this.role,
    required this.badgeText,
    required this.badgeColor,
    required this.benefitHint,
    this.accountId,
    this.lastLogin,
    this.partner,
    this.partnerIcon,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 0),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: avatarGradient,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: avatarGradient.last.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: avatarIcon is String
                        ? SvgPicture.asset(
                            avatarIcon as String,
                            width: 22,
                            height: 22,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          )
                        : Icon(
                            avatarIcon as IconData,
                            size: 22,
                            color: Colors.white,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: AppText(
                              name,
                              style: AppTextStyle.headlineSmall,
                              fontWeight: FontWeight.w700,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    badgeColor.withValues(alpha: 0.15),
                                    badgeColor.withValues(alpha: 0.06),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: AppText(
                                badgeText,
                                style: AppTextStyle.labelSmall,
                                color: AppColors.warning,
                                fontSize: 11,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      AppText(
                        '$role | $benefitHint',
                        style: AppTextStyle.labelSmall,
                        color: tokens.textSecondary,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Material(
                  color: AppColors.gray50,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: SvgPicture.asset(AppAssets.iconEdit),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Icon(LucideIcons.hash, size: 11, color: tokens.textMuted),
                const SizedBox(width: 3),
                accountId != null
                    ? Expanded(
                        child: AppText(
                          accountId!,
                          style: AppTextStyle.labelSmall,
                          fontSize: 10,
                          color: tokens.textMuted,
                          fontWeight: FontWeight.w500,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : const SizedBox.shrink(),
                lastLogin != null
                    ? Expanded(
                        child: AppText(
                          l10n.profileLabelLastLogin(lastLogin!),
                          style: AppTextStyle.labelSmall,
                          fontSize: 10,
                          color: tokens.textMuted,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          if (partner != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
              child: Row(
                children: [
                  partnerIcon is String
                      ? SvgPicture.asset(
                          partnerIcon as String,
                          width: 11,
                          height: 11,
                          colorFilter: const ColorFilter.mode(
                            AppColors.primary,
                            BlendMode.srcIn,
                          ),
                        )
                      : Icon(
                          (partnerIcon as IconData?) ?? LucideIcons.landmark,
                          size: 11,
                          color: AppColors.primary,
                        ),
                  const SizedBox(width: 4),
                  AppText(
                    partner!,
                    style: AppTextStyle.labelSmall,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Divider(height: 1, color: Color(0xFFF0F1F3)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
            child: IntrinsicHeight(
              child: Row(
                children: stats.asMap().entries.map((entry) {
                  final index = entry.key;
                  final stat = entry.value;
                  return Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      stat.icon,
                                      width: 12,
                                      height: 14,
                                      colorFilter: ColorFilter.mode(
                                        stat.color,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    if (stat.value != null) ...[
                                      AppText(
                                        stat.value!,
                                        style: AppTextStyle.bodyMedium,
                                        fontWeight: FontWeight.w800,
                                        color: stat.color,
                                        letterSpacing: -0.3,
                                      ),
                                    ],
                                    AppText(
                                      stat.label,
                                      style: AppTextStyle.titleSmallBold,
                                      color: stat.color,
                                    ),
                                    const SizedBox(height: 2),
                                    stat.subTitle != null
                                        ? AppText(
                                            stat.subTitle!,
                                            style: AppTextStyle.labelSmall,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textTertiary,
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (index < stats.length - 1)
                          Container(
                            width: 1,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            color: const Color(0xFFE5E7EB),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
