// =============================================================================
// TransactionProcessingDesktopHeader  —  ORGANISM (desktop-only)
// -----------------------------------------------------------------------------
// Minimal replacement for AppDesktopHeader shown ONLY while
// AppRoutes.transactionProcessingPage is active on desktop (see
// AppDesktopShell). No sidebar accompanies this header — the transaction-
// processing content gets the full width instead.
//
// Deliberately static: the vendor/partner mark is shown without its dropdown
// chevron and doesn't open the partner selection popup, and the avatar has
// no menu (it never did — see AppAvatar). Nothing here navigates away from
// the page, matching the "don't let the user leave mid-transaction"
// requirement without disabling/dimming any control.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:citizenone_app/modules/insurance/core/config/app_config.dart';
import 'package:citizenone_app/modules/insurance/core/di/di_setup.dart';
import 'package:citizenone_app/modules/insurance/core/services/secure_storage_service.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/core/theme/tokens/assets.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_avatar.dart';
import 'package:citizenone_app/modules/insurance/design_system/organisms/app_desktop_header.dart';

class TransactionProcessingDesktopHeader extends StatefulWidget {
  const TransactionProcessingDesktopHeader({super.key});

  @override
  State<TransactionProcessingDesktopHeader> createState() =>
      _TransactionProcessingDesktopHeaderState();
}

class _TransactionProcessingDesktopHeaderState
    extends State<TransactionProcessingDesktopHeader> {
  String? _vendorLogo;

  @override
  void initState() {
    super.initState();
    _loadVendorLogo();
  }

  Future<void> _loadVendorLogo() async {
    final logo = await sl<SecureStorageService>().getVendorLogo();
    if (mounted) {
      setState(() => _vendorLogo = logo);
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
          bottom: BorderSide(color: AppColors.desktopHeaderBorder),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 40,
            child: SvgPicture.asset(
              package: AppConfig.packageName,
              AppAssets.citizenOne,
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
            ),
          ),
          Row(
            children: [
              VendorLogo(vendorLogo: _vendorLogo, showChevron: false),
              const SizedBox(width: 20),
              AppAvatar(avatarSize: AppAvatarSize.md),
            ],
          ),
        ],
      ),
    );
  }
}
