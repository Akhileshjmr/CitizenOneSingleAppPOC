import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../core/utils/dialog.dart';
import '../data/models/login_models/LoginUserReqResInfo.dart';
import '../data/models/login_models/TenantDetails.dart';
import '../presentation/screens/login/widgets/handleLogin.dart';
import '../theme/colors/Appcolors.dart';

class MobileCustomToolBar extends StatelessWidget
    implements PreferredSizeWidget {
  final bool showMenu;
  final bool showHelpCenter;
  final bool showSearch;
  final bool showLogin;
  final bool showLogout;
  final bool showBankOption;
  final bool isDashboard;

  final GlobalKey<ScaffoldState>? scaffoldKey;
  final String? bankName;
  final Uint8List? bankLogo;
  final LoginUserReqResInfo? loginResponse;
  final List<TenantDetails>? tenants;

  const MobileCustomToolBar({
    super.key,
    this.showMenu = true,
    this.showHelpCenter = true,
    this.showSearch = true,
    this.showLogin = true,
    this.showLogout = true,
    this.showBankOption = false,
    this.isDashboard = false,
    this.scaffoldKey,
    this.bankName,
    this.bankLogo,
    this.loginResponse,
    this.tenants,
  });

  /// 🔹 Logo Widget (size constrained – mobile safe)
  Widget _buildLogo() {
    final defaultLogo =
        const Icon(Icons.account_balance, size: 28, color: Colors.grey);

    if (bankLogo != null) {
      return SizedBox(
        height: 36,
        child: Image.memory(
          bankLogo!,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => defaultLogo,
        ),
      );
    }

    return SizedBox(
      height: 36,
      child: Image.asset(
        'assets/icons/useful_icons/default_bank_logo.png',
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => defaultLogo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: isDashboard ? Colors.white : AppColors.toolBarBackground,
      elevation: 0,
      centerTitle: true,

      /// 🔹 Fixed leading width to avoid shifting
      leadingWidth: 56,

      /// 🔹 Leading Menu Button
      leading: showMenu
          ? IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                if (isDashboard) {
                  scaffoldKey?.currentState?.openDrawer();
                }
              },
            )
          : null,

      /// 🔹 Title (Logo OR Bank Name)
      title: Center(
        child: isDashboard
            ? _buildLogo()
            : (bankName != null
                ? Text(
                    bankName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                : null),
      ),

      /// 🔹 Actions
      actions: [
        if (showHelpCenter)
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.black),
            onPressed: () {},
          ),
        if (showSearch)
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        if (showLogin)
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black),
            onPressed: () {
              DialogUtils.showLoginOptionsDialog(context);
            },
          ),
        if (showBankOption)
          IconButton(
            icon: isDashboard
                ? Image.asset(
                    "assets/icons/useful_icons/bankSelection.png",
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  )
                : const Icon(
                    Icons.account_balance,
                    color: Colors.black,
                  ),
            onPressed: () {
              showAccountDialog(
                context,
                loginResponse!,
                tenants!,
                "",
              );
            },
          ),
        /*if (showLogout)
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              showLogoutDialog(context);
            },
          ),*/
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
