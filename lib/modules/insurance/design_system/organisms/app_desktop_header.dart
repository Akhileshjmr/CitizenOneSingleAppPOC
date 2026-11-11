// =============================================================================
// AppDesktopHeader  —  ORGANISM (desktop-only)
// -----------------------------------------------------------------------------
// Desktop header showing the vendor/bank logo and the agent avatar. Tapping
// the vendor logo opens the Partner Selection popup (see
// partner_selection_popup.dart), which hands off to the parent app.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/di/di_setup.dart';
import 'package:citizenone_app/modules/insurance/core/network/session_image_headers.dart';
import 'package:citizenone_app/modules/insurance/core/services/secure_storage_service.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_spacing.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_avatar.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_network_image.dart';
import 'package:citizenone_app/modules/insurance/design_system/organisms/partner_selection_popup.dart';

class AppDesktopHeader extends StatefulWidget {
  const AppDesktopHeader({super.key});

  static const double height = 72;

  @override
  State<AppDesktopHeader> createState() => _AppDesktopHeaderState();
}

class _AppDesktopHeaderState extends State<AppDesktopHeader> {
  String? _vendorLogo;
  final PartnerSelectionMenuController _partnerMenu =
      PartnerSelectionMenuController();

  @override
  void initState() {
    super.initState();
    _loadVendorLogo();
  }

  Future<void> _loadVendorLogo() async {
    final logo = await sl<SecureStorageService>().getVendorLogo();

    if (mounted) {
      setState(() {
        _vendorLogo = logo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDesktopHeader.height,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.desktopHeaderBorder,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CompositedTransformTarget(
            link: _partnerMenu.layerLink,
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: InkWell(
                onTap: () => _partnerMenu.toggle(context),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                mouseCursor: SystemMouseCursors.click,
                child: VendorLogo(vendorLogo: _vendorLogo),
              ),
            ),
          ),
          const SizedBox(width: 20),
          AppAvatar(
            avatarSize: AppAvatarSize.md,
          ),
        ],
      ),
    );
  }
}

/// Vendor/partner logo mark, shared by [AppDesktopHeader] (dropdown chevron
/// shown — tapping opens the partner selection popup) and
/// [TransactionProcessingDesktopHeader] (chevron hidden — the minimal header
/// shows the mark as a static, non-interactive icon).
class VendorLogo extends StatelessWidget {
  const VendorLogo({
    super.key,
    required this.vendorLogo,
    this.showChevron = true,
  });

  final String? vendorLogo;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppNetworkImage(
          vendorLogo,
          headers: sessionImageHeaders(),
          height: 42,
          fit: BoxFit.contain,
          alignment: Alignment.centerLeft,
          errorWidget: const Icon(
            Icons.shield_outlined,
            size: 28,
            color: AppColors.textSecondary,
          ),
        ),
        if (showChevron)
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 28,
            color: Color(0xFF6B5C7A),
          ),
      ],
    );
  }
}
