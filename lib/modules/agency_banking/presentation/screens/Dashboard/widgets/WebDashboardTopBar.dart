import 'package:citizenone_app/modules/agency_banking/utils/CommDialog.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/app_avatar.dart';

/// Minimal top bar for the desktop web dashboard only — kept separate from
/// the shared WebCustomToolBar (used by the landing page) so restyling this
/// screen can never affect other web screens.
class WebDashboardTopBar extends StatelessWidget {
  const WebDashboardTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // InkWell(
            // onTap: () => showLogoutDialog(context),
            // child:
            AppAvatar(
              size: AppAvatarSize.md,
            ),
            // ),
          ],
        ),
      ),
    );
  }
}
