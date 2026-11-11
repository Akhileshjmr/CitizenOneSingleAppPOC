import 'package:citizenone_app/modules/agency_banking/core/utils/dialog.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/CommDialog.dart';

class WebCustomToolBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackArrow;
  final bool showLogo;
  final bool showSearch;
  final bool showHelpCenter;
  final bool showLogin;
  final bool showProfile;
  final bool showLogout;
  final bool showTitle;      // New flag
  final String? title;
  const WebCustomToolBar({
    super.key,
    this.showLogo = true,
    this.showSearch = true,
    this.showHelpCenter = true,
    this.showLogin = true,
    this.showProfile = true,
    this.showLogout = true,
    this.showBackArrow=true,
    this.showTitle = false,  // default off
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.toolBarBackground,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showBackArrow)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).maybePop();
                  },
                ),

              // ✅ Logo (smaller on mobile)
              if (showLogo)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Image.asset(
                    "assets/images/bank_logo.png",
                    height: isMobile ? 28 : 40,
                    fit: BoxFit.cover,
                  ),
                ),

              // ✅ Search takes available space
              if (showSearch)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8), // space left & right
                    child: Container(
                      height: isMobile ? 30 : 36,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColors.toolBarContentBackground,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.kBlackWithOpacity),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search,
                              size: 16, color: AppColors.kBlackWithOpacity),
                          SizedBox(width: 6),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Search",
                                border: InputBorder.none,
                                isCollapsed: true,
                              ),
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),


              if (showSearch) const SizedBox(width: 8),
              if (showTitle && title != null)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    title ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              // ✅ Help Center
              if (showHelpCenter)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.toolBarContentBackground,
                      foregroundColor: AppColors.kBlackWithOpacity,
                      side: const BorderSide(color: AppColors.kBlackWithOpacity),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      minimumSize: const Size(80, 40), // width=100, height=45
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // keep rounded
                      ),
                    ),
                    icon: SvgPicture.asset(
                      "assets/icons/ic_phone.svg",
                      height: 18, // bigger icon
                      width: 18,
                    ),
                    label: const Text(
                      "Help center",
                      style: TextStyle(
                        fontSize: 14, // bigger text
                        color: AppColors.kBlackWithOpacity,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),

              // ✅ Login
              if (showLogin)
                InkWell(
                  onTap: () => DialogUtils.showLoginOptionsDialog(context),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "Login",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

              // ✅ Profile (hidden on mobile)
              if (!isMobile && showProfile)
                const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Micheal Hill",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Jmir Infotech",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black54)),
                        ],
                      ),
                      SizedBox(width: 10),
                      CircleAvatar(
                        radius: 18,
                        backgroundImage:
                        AssetImage("assets/images/avatar.png"),
                      ),
                    ],
                  ),
                ),
              if (showLogout)
                InkWell(
                  onTap: () {
                    // Call your logout dialog here
                    showLogoutDialog(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.logout,
                      size: 24,
                      color: Colors.black, // change color if needed
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
