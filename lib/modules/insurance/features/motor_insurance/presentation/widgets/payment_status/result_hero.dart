// =============================================================================
// ResultHero — top hero section shared by Success / Payment Failed / Policy
// Issuance Failed screens: a tone-colored icon circle, heading and subtitle.
// On web it renders as a full-width colored banner (rounded top corners,
// matching the receipt/summary card stacked directly beneath it); on mobile
// it renders as a plain centered block with no banner background.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/payment_status/process_step_status.dart';

class ResultHero extends StatefulWidget {
  const ResultHero({
    super.key,
    required this.tone,
    required this.icon,
    required this.heading,
    required this.subtitle,
    this.banner = false,
  });

  final ResultTone tone;
  final IconData icon;
  final String heading;
  final String subtitle;

  /// When true, renders as a full-width colored banner with rounded top
  /// corners (desktop). When false, renders as a plain centered block with
  /// no background (mobile).
  final bool banner;

  @override
  State<ResultHero> createState() => _ResultHeroState();
}

class _ResultHeroState extends State<ResultHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconCircle = ScaleTransition(
      scale: CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
      child: Container(
        width: widget.banner ? 72 : 64,
        height: widget.banner ? 72 : 64,
        decoration: BoxDecoration(
          color: widget.tone.primary,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(widget.icon,
            color: Colors.white, size: widget.banner ? 36 : 32),
      ),
    );

    final textBlock = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        iconCircle,
        const SizedBox(height: 16),
        AppText(
          widget.heading,
          style: AppTextStyle.headlineLarge,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
          color: AppColors.textPrimary,
        ),
        const SizedBox(height: 8),
        AppText(
          widget.subtitle,
          style: AppTextStyle.bodyLarge,
          textAlign: TextAlign.center,
          color: AppColors.serviceHeaderTitle,
        ),
      ],
    );

    if (!widget.banner) return textBlock;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
      decoration: BoxDecoration(
        color: widget.tone.bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: textBlock,
    );
  }
}
